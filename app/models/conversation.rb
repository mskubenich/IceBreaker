class Conversation < ActiveRecord::Base
  has_many :messages, -> { order('created_at DESC') }

  scope :unfinished,    ->  { where(messages_count: 3) }
  scope :active,        ->  { where(created_at: Time.zone.now - 1.months..Time.zone.now) }
  scope :out_of_radius, ->  { where(in_radius: false) }
  scope :in_radius,     ->  { where(in_radius: true) }

  belongs_to :initiator, class_name: User, foreign_key: :initiator_id
  belongs_to :opponent, class_name: User, foreign_key: :opponent_id
  belongs_to :removed_by_user, class_name: User, foreign_key: :removed_by

  enum status: { active: 0, removed: 1 }

  MUTED_TIME = 5.hours

  def initial_message
    messages.order('created_at ASC').offset(0).limit(1).try :first
  end

  def reply_message
    messages.order('created_at ASC').offset(1).limit(1).try :first
  end

  def finished_message
    messages.order('created_at ASC').offset(2).limit(1).try :first
  end

  def self.between_users initiator:, opponent:
    conversation = where(initiator_id: [initiator.id, opponent.id], opponent_id: [opponent.id, initiator.id]).order('created_at ASC').last
    conversation = Conversation.create initiator_id: initiator.id, opponent_id: opponent.id if !conversation || conversation.muted_done?
    conversation
  end

  def muted?
    done? && ( Time.now - finished_message.created_at < MUTED_TIME )
  end

  def muted_done?
    done? && ( Time.now - finished_message.created_at > MUTED_TIME )
  end

  def done?
    messages.count == 3
  end

  def last_message
    messages.order('created_at DESC').try :first
  end

  def opponent_to(user)
    if user.id == self.initiator_id
      self.opponent
    elsif user.id == self.opponent_id
      self.initiator
    else
      nil
    end
  end
end