class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :author, class_name: User, foreign_key: :author_id

  validates :author_id, presence: true
  validates :conversation_id, presence: true
  validates :text, presence: true

  after_validation :validate_message_type, :validate_radius, :validate_muted, :validate_finished
  after_save :update_conversation
  after_save :update_user
  after_save :send_push_notification

  def opponent
    if self.author.id == conversation.initiator.id
      conversation.opponent
    else
      conversation.initiator
    end
  end

  private

  def validate_muted
    self.errors.add :base, "You have #{ ((Time.now - conversation.mute.created_at)/60).round } minutes before another conversation can be started!" if conversation.muted?
  end

  def validate_finished
    self.errors.add :base, "Conversation done." if conversation.done?
  end

  def validate_radius
    self.errors.add :base, 'User is out of radius.' unless conversation.initiator.in_radius? conversation.opponent
  end

  def validate_message_type
    case conversation.messages.count
      when 0 # initial

      when 1
        self.errors.add :author_id, 'You can not send messages to this conversation. There is not your turn.' if author.id == conversation.initial_message.author
      when 2
        self.errors.add :author_id, 'You can not send messages to this conversation. There is not your turn.' if author.id == conversation.reply_message.author
      else
        self.errors.add :base, 'Conversation closed.'
    end
  end

  def update_conversation
    conversation.update_attributes messages_count: conversation.messages.count
    conversation.update_attributes status: :finished if conversation.messages.count == 3
  end

  def update_user
    author.update_attribute :sended_messages_count, author.sended_messages_count.to_i + 1
    opponent.update_attribute :received_messages_count, opponent.received_messages_count.to_i + 1
  end

  def send_push_notification
    opponent.send_push_notification message: "#{ author.user_name } : #{ text }"
  end
end