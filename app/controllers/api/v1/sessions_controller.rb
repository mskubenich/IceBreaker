class Api::V1::SessionsController < Api::V1Controller
  skip_before_filter :authenticate_user, only: [:create, :facebook]

  def create
    users = User.arel_table
    query = users.project(Arel.star).where(users[:email].eq(session_params[:login]).or(users[:user_name].eq(session_params[:login])))
    @user = User.find_by_sql(query.to_sql).try :first

    if @user && @user.authenticate(session_params[:password])
      sign_in @user
      render json: { session_token: current_session.token}
    else
      render json: { errors: ['Wrong login/password combination.'] }, status: :unprocessable_entity
    end

  end

  def destroy
    current_session.destroy
    render nothing: true
  end

  def facebook
    @service = Service.facebook.new uid: facebook_params[:facebook_uid], avatar: facebook_params[:facebook_avatar]
    @user = User.new user_params

    if @service.valid? && @user.valid?
      @service = Service.facebook.where(uid: facebook_params[:facebook_uid]).first_or_create do |service|
        service.avatar = facebook_params[:facebook_avatar]
      end

      @service.user ||= @user
      @service.user.save

      @service.update_attribute :user_id, @user.id

      sign_in @user
    else
      render json: {errors: @service.errors.full_messages + @user.errors.full_messages}, status: :unprocessable_entity and return
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

  def session_params
    params.permit(:login, :password)
  end

  def facebook_params
    params.permit(:facebook_uid, :facebook_avatar)
  end

end