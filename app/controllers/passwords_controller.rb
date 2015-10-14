class PasswordsController < ApplicationController
  skip_before_filter :authenticate_user

  layout 'client'

  def update
    @user = User.where(reset_password_token: params[:reset_password_token]).try(:first) if params[:reset_password_token].present?
    flash[:error] = 'Can\'t find user by given reset password token.' unless @user

    if @user
      if @user.update_attributes(user_params)
        flash[:notice] = 'Password successfully changed.'
        render 'index'
      else
        render 'edit'
      end
    else
      render 'edit'
    end
  end

  def edit
    @user = User.where(reset_password_token: params[:reset_password_token]).try(:first) if params[:reset_password_token].present?

    flash[:error] = 'Can\'t find user by given reset password token.' unless @user
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end