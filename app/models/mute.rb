class Mute < ActiveRecord::Base
  belongs_to :initiator, class_name: User, foreign_key: :initiator_id
  belongs_to :opponent, class_name: User, foreign_key: :opponent_id

  before_validation :validate_users

  def self.between(user1, user2)
    mute = where(initiator_id: [user1.id, user2.id], opponent_id: [user2.id, user1.id]).try :first
    if mute && mute.created_at > Time.now - 5.minutes
      mute.destroy
      return nil
    end
    mute
  end

  private

  def validate_users
    self.errors.add :base, 'You can not mute youself.' if self.initiator_id == self.opponent_id
  end
end