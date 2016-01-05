class Mute < ActiveRecord::Base
  belongs_to :initiator, class_name: User, foreign_key: :initiator_id
  belongs_to :opponent, class_name: User, foreign_key: :opponent_id
  belongs_to :conversation

  before_validation :validate_users

  enum mute_type: { ban: 0, conversation_removed: 1, finished: 2 }

  def self.between(user1, user2, options = {})
    mute = where(initiator_id: [user1.id, user2.id], opponent_id: [user2.id, user1.id], mute_type: options[:type]).try :first
    if mute && mute.updated_at < (Time.now.utc - 5.minutes)
      return nil
    end
    mute
  end

  private

  def validate_users
    self.errors.add :base, 'You can not mute youself.' if self.initiator_id == self.opponent_id
  end
end
