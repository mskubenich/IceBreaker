json.conversations @conversations do |conversation|
  json.id conversation.id
  json.created_at conversation.created_at
  json.updated_at conversation.updated_at
  json.finished !conversation.active?
  json.status conversation.status
  json.removed_by conversation.removed_by if conversation.removed?
  json.removed_by_user_name conversation.removed_by_user.try :user_name if conversation.removed?
  json.muted conversation.muted?
  json.muted_to conversation.muted? ? (conversation.mute.created_at + 5.minutes) - Time.now.utc : ''
  json.muted_by conversation.muted_by.try(:id)

  opponent = conversation.opponent_to current_user
  json.opponent do
    json.id opponent.id
    json.first_name opponent.first_name
    json.last_name opponent.last_name
    json.user_name opponent.user_name
    json.show_email opponent.show_email
    json.avatar opponent.avatar.exists? ? opponent.avatar.url : opponent.services.facebook.first.try(:avatar)
    json.email opponent.email
  end

  last_message = conversation.last_message
  json.last_message do
    json.author last_message.author_id == current_user.id ? 'I' : 'He'
    json.author_id last_message.author_id
    json.text last_message.text
    json.viewed last_message.viewed
    json.created_at last_message.created_at.strftime("%d/%m/%Y %H:%M")
  end if last_message
end
json.page @page
json.total @total
json.per_page @per_page