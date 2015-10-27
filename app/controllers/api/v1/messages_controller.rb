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

    mute = Mute.where(initiator_id: current_user.id, opponent_id: @opponent.id).try :first
    if !mute
      mute = Mute.where(initiator_id: @opponent.id, opponent_id: current_user.id).try :first
    end

    if mute
      case mute.mute_type
        when "conversation_removed"
          render json: {errors: ["Conversation removed by #{ mute.initiator.try :user_name }.You have #{ ((Time.now - mute.created_at)/60).round } minutes before another conversation can be started!"]}, status: :unprocessable_entity
        when "finished"
          render json: {errors: ["Previous conversations is finished.You have #{ ((Time.now - mute.created_at)/60).round } minutes before another conversation can be started!"]}, status: :unprocessable_entity
        when "ban"
          render json: {errors: ["Conversation muted by #{ mute.initiator.try :user_name }.You have #{ ((Time.now - mute.created_at)/60).round } minutes before another conversation can be started!"]}, status: :unprocessable_entity
        else
          render json: {errors: ["Conversation is muted"]}, status: :unprocessable_entity
      end
    else
      @conversation = Conversation.between_users initiator: current_user, opponent: @opponent
      render json: {errors: @conversation.errors.full_messages }, status: :unprocessable_entity and return if @conversation.errors.any?

      @message = @conversation.messages.new text: params[:message], author_id: current_user.id, opponent_id: @opponent.id
      if @message.save
        render json: {message: 'Message sent.'}
      else
        render json: {errors: @message.errors.full_messages}, status: :unprocessable_entity
      end
    end
  end
end