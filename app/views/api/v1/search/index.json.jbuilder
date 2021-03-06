json.users_in_radius @users_in_radius do |user|
  json.id          user.id
  json.first_name  user.first_name
  json.last_name   user.last_name
  json.user_name   user.user_name
  json.gender      user.gender
  json.latitude    user.latitude + "0.0000#{rand(4..8)}".to_f
  json.longitude   user.longitude + "0.0000#{rand(4..8)}".to_f
  json.sended_messages_count   current_user.sended_messages_count_to(user)
  json.received_messages_count   current_user.received_messages_count_from(user)
  json.avatar      user.avatar.exists? ? user.avatar.url(:thumb) : user.services.facebook.try(:first).try(:avatar)

  mute = Mute.between current_user, user, type: Mute.mute_types[:ban]
  json.muted !!mute
  json.muted_to mute ? (mute.created_at + 5.minutes) - Time.now.utc : ''
  json.muted_by mute.try(:initiator).try(:id)

  has_opened_conversation = Conversation.has_opened_between(current_user, user)
  json.has_opened_conversartion has_opened_conversation

  conversation_removed_mute = Mute.between current_user, user, type: Mute.mute_types[:conversation_removed]
  removed_by_user = conversation_removed_mute.try(:conversation).try(:removed_by_user)
  if conversation_removed_mute != nil && removed_by_user.try(:id) == nil
    json.removed_by user.id
    json.removed_by_user_name user.user_name
  else
    json.removed_by removed_by_user.try :id
    json.removed_by_user_name removed_by_user.try(:user_name)
  end
  json.removed_to conversation_removed_mute ? (conversation_removed_mute.created_at + 5.minutes) - Time.now.utc : ''

  conversation_finished_mute =  Mute.between current_user, user, type: Mute.mute_types[:finished]
  json.previous_conversation_is_finished !!conversation_finished_mute
  json.previous_conversation_is_finished_to conversation_finished_mute ? (conversation_finished_mute.created_at + 5.minutes) - Time.now.utc : ''

  json.last_activity user['conversation_updated_at'].try(:strftime, "%d/%m/%Y %H:%M")
end

json.users_out_of_radius @users_out_of_radius do |user|
  json.id          user.id
  json.first_name  user.first_name
  json.last_name   user.last_name
  json.user_name   user.user_name
  json.gender      user.gender
  json.latitude    user.latitude
  json.longitude   user.longitude
  json.avatar      user.avatar.exists? ? user.avatar.url(:thumb) : user.services.facebook.try(:first).try(:avatar)

  json.sended_messages_count   current_user.sended_messages_count_to(user)
  json.received_messages_count   current_user.received_messages_count_from(user)


  mute = Mute.between current_user, user, type: Mute.mute_types[:ban]

  json.muted !!mute
  json.muted_to mute ? (mute.created_at + 5.minutes) - Time.now.utc : ''
  json.muted_by mute.try(:initiator).try(:id)


  has_opened_conversation = Conversation.has_opened_between(current_user, user)
  json.has_opened_conversartion has_opened_conversation

  conversation_removed_mute = Mute.between current_user, user, type: Mute.mute_types[:conversation_removed]
  removed_by_user = conversation_removed_mute.try(:conversation).try(:removed_by_user)
  json.removed_by removed_by_user.try :id
  json.removed_by_user_name removed_by_user.try(:user_name)
  json.removed_to conversation_removed_mute ? (conversation_removed_mute.created_at + 5.minutes) - Time.now.utc : ''

  conversation_finished_mute =  Mute.between current_user, user, type: Mute.mute_types[:finished]
  json.previous_conversation_is_finished !!conversation_finished_mute
  json.previous_conversation_is_finished_to conversation_finished_mute ? (conversation_finished_mute.created_at + 5.minutes) - Time.now.utc : ''

  json.last_activity user['conversation_updated_at'].try(:strftime, "%d/%m/%Y %H:%M")
end