class Api::V1::PasswordsController < Api::V1Controller
  skip_before_filter :authenticate_user, only: [:create]

  def create
    @user = User.where(email: params[:email]).try(:first)
    if @user
      @user.send_reset_password_instructions path: edit_passwords_url
      render json: { message: 'A new password sent to your email.' }
    else
      render json: { errors: ['There is no user with given email.'] }, status: :unprocessable_entity
    end
  end
end