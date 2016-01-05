class UserMailer < ActionMailer::Base

  default from: "info.icebreaker.app@gmail.com"

  def forgot_password(user, password, options)
    @user = user
    @password = password
    @path = options[:path]
    mail(to: @user.email, subject: 'New password for IceBr8kr account')
  end

  def feedback(user, body)
    @user = user
    @body = body
    mail(to: 'icefeedback@seismicvisionllc.com', subject: "IceBr8kr Feedback")
  end
end
