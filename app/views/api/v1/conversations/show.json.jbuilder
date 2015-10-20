json.conversation do
  json.id @conversation.id
  json.created_at @conversation.created_at
  json.updated_at @conversation.updated_at
  json.finished @conversation.done?
  json.status @conversation.status
  if @conversation.removed?
    json.removed_by @conversation.removed_by
  end
  json.muted @conversation.muted? if @conversation.muted?
  json.muted_to @conversation.muted.created_at + 5.minutes if @conversation.muted?
  json.muted_by @conversation.muted_by if @conversation.muted?

  opponent = @conversation.opponent_to current_user
  json.opponent do
    json.id opponent.id
    json.first_name opponent.first_name
    json.last_name opponent.last_name
    json.user_name opponent.user_name
    json.show_email opponent.show_email
    json.avatar opponent.avatar.exists? ? opponent.avatar.url : opponent.services.facebook.first.try(:avatar)
    json.email opponent.email
  end if opponent

  json.messages @conversation.messages do |message|
    json.author    message.author_id == current_user.id ? 'I' : 'He'
    json.author_id message.author_id
    json.text      message.text
    json.viewed    message.viewed
  end
end