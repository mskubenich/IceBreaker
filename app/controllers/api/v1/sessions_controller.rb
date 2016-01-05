class Api::V1::SessionsController < Api::V1Controller
  skip_before_filter :authenticate_user, only: [:create, :facebook]

  def create
    users = User.arel_table
    query = users.project(Arel.star).where(users[:email].eq(session_params[:login]).or(users[:user_name].eq(session_params[:login])))
    @user = User.find_by_sql(query.to_sql).try :first

    if @user && @user.authenticate(session_params[:password])
      sign_in @user, device_params
    else
      render json: { errors: ['Wrong login/password combination.'] }, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.reset_location
    current_session.destroy
    render nothing: true
  end

  def destroy_all
    current_user.session.destroy
    render nothing: true
  end

  def facebook
    @service = Service.facebook.new uid: facebook_params[:facebook_uid], avatar: facebook_params[:facebook_avatar]

    if @service.valid?

      @service = Service.facebook.where(uid: facebook_params[:facebook_uid]).first_or_create do |service|
        service.avatar = facebook_params[:facebook_avatar]
      end

      if @service.user
        @user = @service.user
        @service.assign_attributes avatar: facebook_params[:facebook_avatar]
      else
        @user = User.find_by_email params[:email]
        if @user
          @user.assign_attributes user_params
        else
          @user = User.new user_params
          @user.set_random_password
          @user.services = [@service]
          @service.user = @user
        end
      end

      if @user.save
        @service.update_attribute :user_id, @user.id
        sign_in @user, device_params
      else
        render json: {errors: @service.errors.full_messages}, status: :unprocessable_entity and return
      end
    else
      render json: {errors: @service.errors.full_messages}, status: :unprocessable_entity and return
    end
  end

  private

  def user_params
    params.permit :first_name,
                  :last_name,
                  :user_name,
                  :email,
                  :date_of_birth,
                  :gender,
                  :show_email
  end

  def session_params
    params.permit(:login, :password, :device, :device_token)
  end

  def facebook_params
    params.permit(:facebook_uid, :facebook_avatar)
  end

  def device_params
    {
        device: ['ios', 'android'].include?(params[:device]) ? params[:device] : nil,
        device_token: params[:device_token]
    }
  end

end
