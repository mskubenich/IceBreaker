json.users_in_radius @users_in_radius do |user|
  json.id          user.id
  json.first_name  user.first_name
  json.last_name   user.last_name
  json.user_name   user.user_name
  json.gender      user.gender
  json.latitude    user.latitude
  json.longitude   user.longitude
  json.avatar      user.avatar.exists? ? user.avatar.url(:thumb) : user.services.facebook.try(:first).try(:avatar)
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
end