class Conversation < ActiveRecord::Base
  has_many :messages, -> { order('created_at ASC') }, dependent: :destroy

  scope :active,        ->  { where(created_at: Time.zone.now - 1.months..Time.zone.now) }
  scope :out_of_radius, ->  { where(in_radius: [false, nil]) }
  scope :in_radius,     ->  { where(in_radius: true) }

  belongs_to :initiator, class_name: User, foreign_key: :initiator_id
  belongs_to :opponent, class_name: User, foreign_key: :opponent_id
  belongs_to :removed_by_user, class_name: User, foreign_key: :removed_by

  enum status: { active: 0, removed: 1, finished: 2 }

  validates :initiator_id, presence: true
  validates :opponent_id, presence: true
  before_validation :validate_ids

  MUTED_TIME = 5.hours

  def initial_message
    messages.order('created_at DESC').offset(0).limit(1).try :first
  end

  def reply_message
    messages.order('created_at DESC').offset(1).limit(1).try :first
  end

  def finished_message
    messages.order('created_at DESC').offset(2).limit(1).try :first
  end

  def self.between_users(initiator:, opponent:)
    conversation = where(initiator_id: [initiator.id, opponent.id], opponent_id: [opponent.id, initiator.id]).order('created_at ASC').last
    if !conversation || conversation.finished?
      conversation = Conversation.create initiator_id: initiator.id, opponent_id: opponent.id
    end
    conversation
  end

  def self.has_opened_between(initiator, opponent)
    conversations = Conversation.arel_table

    query = conversations
        .project(conversations[:initiator_id], conversations[:opponent_id], conversations[:messages_count])
        .where(
            conversations[:initiator_id].in([initiator.id, opponent.id])
                .and(conversations[:opponent_id].in([opponent.id, initiator.id])
                         .and(conversations[:status].eq(0))))
        .take(1)

    conversation = Conversation.find_by_sql(query)
    conversation.any?
  end

  def muted?
    !!mute
  end

  def muted_by
    mute.try :initiator
  end

  def mute
    Mute.between initiator, opponent
  end

  def done?
    messages.count == 3
  end

  def last_message
    messages.last
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

  private

  def validate_ids
    self.errors.add :base, 'You can not write to yourself.' if initiator.id == opponent.id
  end
end