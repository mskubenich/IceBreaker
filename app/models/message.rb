class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :author, class_name: User, foreign_key: :author_id

  validates :author_id, presence: true
  validates :conversation_id, presence: true
  validates :text, presence: true

  after_validation :validate_message_type
  after_validation :validate_radius
  after_validation :validate_conversation_finished
  after_validation :validate_conversation_removed
  after_validation :validate_mute_between_conversations
  after_save :update_user
  after_create :send_push_notification
  after_save :update_messages
  after_save :update_conversation

  def opponent
    if self.author.id == conversation.initiator.id
      conversation.opponent
    else
      conversation.initiator
    end
  end

  private

  def validate_mute_between_conversations
    mute = Mute.between author, opponent, type: Mute.mute_types[:conversation_removed]
    self.errors.add :base, "Conversation removed by #{ mute.initiator.try :user_name }.You have #{ ((Time.now - mute.created_at)/60).round } minutes before another conversation can be started!" if mute
    mute = Mute.between author, opponent, type: Mute.mute_types[:finished]
    self.errors.add :base, "Previous conversations is finished.You have #{ ((Time.now - mute.created_at)/60).round } minutes before another conversation can be started!" if mute
    mute = Mute.between author, opponent, type: Mute.mute_types[:ban]
    self.errors.add :base, "Conversation muted by #{ mute.initiator.try :user_name }.You have #{ ((Time.now - mute.created_at)/60).round } minutes before another conversation can be started!" if mute
  end

  def validate_conversation_finished
    self.errors.add :base, "Conversation done." if conversation.finished?
  end

  def validate_conversation_removed
    self.errors.add :base, "Conversation removed." if conversation.removed?
  end

  def validate_radius
    self.errors.add :base, 'User is out of radius.' unless conversation.initiator.in_radius? conversation.opponent
  end

  def validate_message_type
    case conversation.messages.count
      when 0 # initial

      when 1
        self.errors.add :author_id, 'You can not send messages to this conversation. There is not your turn.' if author.id == conversation.initial_message.author.id
      when 2
        self.errors.add :author_id, 'You can not send messages to this conversation. There is not your turn.' if author.id == conversation.reply_message.author.id
      else
        self.errors.add :base, 'Conversation closed.'
    end
  end

  def update_conversation
    conversation.update_attributes messages_count: conversation.messages.count
    if conversation.messages.count == 3
      conversation.update_attributes status: :finished
      mute = Mute.create initiator_id: conversation.initiator.id, opponent_id: conversation.opponent.id, mute_type: :finished
    end
  end

  def update_user
    author.update_attribute :sended_messages_count, author.sended_messages_count.to_i + 1
    opponent.update_attribute :received_messages_count, opponent.received_messages_count.to_i + 1
  end

  def send_push_notification
    opponent.send_push_notification message: "#{ author.user_name } : #{ text }"
  end

  def update_messages
    conversation.messages.where(opponent_id: self.author_id, viewed: false).each { |m| m.update_attribute :viewed, true }
  end
end