class Api::V1::UsersController < Api::V1Controller

  load_and_authorize_resource :user
  skip_before_filter :authenticate_user, only: [:create]

  def create
    @user = User.new user_params

    if @user.save
      sign_in @user, device: params[:device], device_token: params[:device_token]
    else
      render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity and return
    end
  end

  def update_profile
    @user = current_user
    if @user.update_attributes edit_user_params

    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity and return
    end
  end

  def mute
    already_muted = Mute.where(initiator_id: [current_user.id, params[:opponent_id]], opponent_id: [current_user.id, params[:opponent_id]])
    if already_muted.blank?
      @user = User.find params[:opponent_id]

      @mute = Mute.new initiator_id: current_user.id, opponent_id: @user.id, mute_type: :ban

      if @mute.save
        Conversation.all_between(current_user, @user).each do |c|
          next unless c.active?
          c.update_attribute :status, 3
          c.messages.where(opponent_id: current_user.id).each { |m| m.update_attribute :viewed, true }
        end
        render json: { ok: true }
      else
        render json: {errors: @mute.errors.full_messages}, status: :unprocessable_entity
      end
    else 
      render json: {errors: 'Already muted.'}, status: :unprocessable_entity
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

  def edit_user_params
    result = params.permit :first_name,
                           :last_name,
                           :user_name,
                           :avatar,
                           :date_of_birth,
                           :password,
                           :password_confirmation,
                           :gender,
                           :show_email

    if result[:password].blank? && result[:password_confirmation].blank?
      result.delete(:password)
      result.delete(:password_confirmation)
    end
    result
  end

end
