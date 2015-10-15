class Api::V1::MessagesController < Api::V1Controller
  def unread
    @messages = current_user.unread_messages
    if @messages.count > 0

    else
      render json: { message: 'You have no unread messages' }
    end
  end
end