class Api::V1::UsersController < Api::V1Controller

  load_and_authorize_resource :user
  skip_before_filter :authenticate_user

  def create
    @user = User.new user_params

    if @user.save
      sign_in @user
    else
      render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity and return
    end
  end

  private 

  def user_params
    params.permit :first_name,
                  :last_name,
                  :user_name,
                  :email,
                  :avatar,
                  :date_of_birth,
                  :password,
                  :password_confirmation,
                  :gender,
                  :show_email
  end

end