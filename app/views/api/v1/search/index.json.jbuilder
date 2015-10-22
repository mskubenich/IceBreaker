json.users_in_radius @users_in_radius do |user|
  json.id          user.id
  json.first_name  user.first_name
  json.last_name   user.last_name
  json.user_name   user.user_name
  json.gender      user.gender
  json.latitude    user.latitude
  json.longitude   user.longitude
  json.sended_messages_count   current_user.sended_messages_count_to(user)
  json.received_messages_count   current_user.received_messages_count_from(user)
  json.avatar      user.avatar.exists? ? user.avatar.url(:thumb) : user.services.facebook.try(:first).try(:avatar)

  mute = Mute.between current_user, user, type: Mute.mute_types[:ban]

  json.muted !!mute
  json.muted_to mute ? (mute.created_at + 5.minutes) - Time.now.utc : ''
  json.muted_by mute.try(:initiator).try(:id)

  json.has_opened_conversartion !!Conversation.has_opened_between(current_user, user)
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
  json.has_opened_conversartion !!Conversation.has_opened_between(current_user, user)

  json.sended_messages_count   current_user.sended_messages_count_to(user)
  json.received_messages_count   current_user.received_messages_count_from(user)


  mute = Mute.between current_user, user, type: Mute.mute_types[:ban]

  json.muted !!mute
  json.muted_to mute ? (mute.created_at + 5.minutes) - Time.now.utc : ''
  json.muted_by mute.try(:initiator).try(:id)
end