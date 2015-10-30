ActionMailer::Base.smtp_settings = {
    address:    "smtp.mandrillapp.com",
    port:       587,
    user_name:  ENV['MANDRILL_USER_NAME'],
    password:   ENV['MANDRILL_PASSWORD'],
    authentication: :login
}

MandrillMailer.configure do |config|
  config.api_key = ENV['MANDRILL_PASSWORD']
end
