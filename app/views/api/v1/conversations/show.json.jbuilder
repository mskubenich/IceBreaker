json.conversation do
  json.id @conversation.id
  json.created_at @conversation.created_at
  json.updated_at @conversation.updated_at
  json.finished !@conversation.active?
  json.status @conversation.status
  if @conversation.removed?
    json.removed_by @conversation.removed_by
    json.removed_by_user_name @conversation.removed_by_user.try :user_name
  end
  json.muted @conversation.muted?
  json.muted_to @conversation.muted? ? (@conversation.mute.created_at + 5.minutes) - Time.now.utc : ''
  json.muted_by @conversation.muted_by.try(:id)

  json.your_turn @conversation.messages.count == 0 || @conversation.last_message.author.id != current_user.id

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
    json.viewed     message.author_id == current_user.id ? true : message.viewed
    json.created_at message.created_at.strftime("%d/%m/%Y %H:%M")
  end
end