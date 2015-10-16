class Api::V1::ConversationsController < Api::V1Controller

  load_and_authorize_resource :conversation

  def index
    @per_page = params[:per_page].to_i || 10
    @page = params[:page].to_i || 1

    @page = 1 if @page < 1
    @per_page = 1 if @per_page < 1

    @conversations = current_user.conversations.order('created_at DESC').limit(@per_page).offset(@page - 1)
    @total = current_user.conversations.count
  end

  def show
    @conversation = Conversation.find params[:id]
  end

  def destroy
    @conversation.update_attributes status: :removed, removed_by: current_user.id
    render nothing: true
  end
end