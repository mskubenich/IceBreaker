class Api::V1::ConversationsController < Api::V1Controller

  load_and_authorize_resource :conversation

  def index
    @per_page = params[:per_page].to_i || 10
    @page = params[:page].to_i || 1

    @page = 1 if @page < 1
    @per_page = 1 if @per_page < 1

    conversations = Conversation.arel_table

    query = conversations.project(Arel.star).where(conversations[:removed_by].not_eq(current_user.id).and(conversations[:initiator_id].eq(current_user.id).or(conversations[:opponent_id].eq(current_user.id)))).order('created_at DESC').take(@per_page).skip(@page - 1)

    @conversations = Conversation.find_by_sql(query)
    query_count = query.clone
    @total = Conversation.find_by_sql(query_count).count
  end

  def show
    @conversation = Conversation.find params[:id]
  end

  def destroy
    @conversation.update_attributes status: :removed, removed_by: current_user.id
    render nothing: true
  end
end