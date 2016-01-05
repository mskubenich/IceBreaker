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

    @conversation = Conversation.new_between_users(initiator: current_user, opponent: @opponent) if current_user.in_radius? @opponent

    if @conversation
      if @conversation.save
        @message = @conversation.messages.new(text: params[:message], author_id: current_user.id, opponent_id: @opponent.id, show_email: current_user.show_email)
        if @message.save
          render json: {message: 'Message sent.'}
        else
          @conversation.destroy
          render json: {errors: @message.errors.full_messages}, status: :unprocessable_entity
        end
      else
        render json: {errors: @conversation.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {errors: ["#{@opponent.user_name} is out of radius."]}, status: :unprocessable_entity
    end
  end
end
