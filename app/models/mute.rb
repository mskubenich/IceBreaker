class Mute < ActiveRecord::Base
  belongs_to :initiator, class_name: User, foreign_key: :initiator_id
  belongs_to :opponent, class_name: User, foreign_key: :opponent_id
  belongs_to :conversation

  before_validation :validate_users
  after_save :send_push_notification

  enum mute_type: { ban: 0, conversation_removed: 1 }

  def self.between(user1, user2, options = {})
    mute = where(initiator_id: [user1.id, user2.id], opponent_id: [user2.id, user1.id], mute_type: options[:type]).try :first
    if mute && ((mute.created_at + 5.minutes) - Time.now.utc < 0)
      mute.destroy
      return nil
    end
    mute
  end

  private

  def validate_users
    self.errors.add :base, 'You can not mute youself.' if self.initiator_id == self.opponent_id
  end

  def send_push_notification
    opponent.send_push_notification message: "You have been ignored by #{ initiator.user_name }" if self.mute_type == :ban
    opponent.send_push_notification message: "User #{ initiator.user_name } removed conversation with you." if self.mute_type == :conversation_removed
  end
end