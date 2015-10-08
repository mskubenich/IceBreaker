class UsersController < ApplicationController

  load_and_authorize_resource :user
  skip_before_filter :authenticate_user

  def create
    @user = User.new user_params

    if @user.save
      render json: {ok: true}
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  private 

  def user_params
    params.require(:user).permit!
  end

end