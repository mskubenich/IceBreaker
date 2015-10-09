class Api::V1::SessionsController < Api::V1Controller
  skip_before_filter :authenticate_user, only: [:create]

  def create
    users = User.arel_table
    query = users.project(Arel.star).where(users[:email].eq(session_params[:login]).or(users[:user_name].eq(session_params[:login])))
    @user = User.find_by_sql(query.to_sql).try :first

    if @user && @user.authenticate(session_params[:password])
      sign_in @user
      render json: {session_token: current_session.token}
    else
      render json: { errors: ['Wrong login/password combination.'] }, status: :unprocessable_entity
    end

  end

  def destroy

  end

  private

  def session_params
    params.permit(:login, :password)
  end

end