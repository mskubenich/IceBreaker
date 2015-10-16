class Api::V1::ConversationsController < Api::V1Controller

  def index
    @per_page = params[:per_page].to_i || 10
    @page = params[:page].to_i || 1
    @conversations = current_user.conversations.order('created_at DESC').limit(@per_page).offset(@page - 1)
    @total = current_user.conversations.count
  end
end