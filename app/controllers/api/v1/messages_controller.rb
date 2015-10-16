class Api::V1::MessagesController < Api::V1Controller
  def unread
    @messages = current_user.unread_messages
    if @messages.count > 0

    else
      render json: { message: 'You have no unread messages' }
    end
  end

  def create
    @opponent = User.where( id: params[:opponent_id]).try :first

    render json: {errors: ['Can\'t find opponent by id.']}, status: :unprocessable_entity and return unless @opponent

    @conversation = Conversation.between_users initiator: current_user, opponent: @opponent

    @message = @conversation.messages.new text: params[:message], author_id: current_user.id
    if @message.save
      render json: {message: 'Message sent.'}
    else
      render json: {errors: @message.errors}, status: :unprocessable_entity
    end
  end
end