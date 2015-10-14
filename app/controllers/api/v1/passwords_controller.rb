class Api::V1::PasswordsController < Api::V1Controller
  skip_before_filter :authenticate_user, only: [:create]

  def create
    @user = User.where(email: params[:email]).try(:first)
    if @user
      begin # TODO remove after deploy
        @user.send_reset_password_instructions path: edit_passwords_url
      rescue Exception => e
        render json: { message: 'A new password sent to your email.', temp_response: edit_passwords_url(reset_password_token: @user.reset_password_token), temp_error: e.message } and return
      end
      render json: { message: 'A new password sent to your email.', temp_response: edit_passwords_url(reset_password_token: @user.reset_password_token) }
    else
      render json: { errors: ['There is no user with given email.'] }, status: :unprocessable_entity
    end
  end
end