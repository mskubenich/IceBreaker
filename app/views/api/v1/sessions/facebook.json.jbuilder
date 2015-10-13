json.session_token current_session.token
json.user do
  json.email @user.email
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.gender @user.gender
  json.date_of_birth @user.date_of_birth
  json.user_name @user.user_name
  json.avatar @user.avatar.exists? ? @user.avatar.url : @user.services.facebook.first.try(:avatar)
  json.show_email !!@user.show_email
end