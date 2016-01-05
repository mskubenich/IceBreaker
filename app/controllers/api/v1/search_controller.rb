class Api::V1::SearchController < Api::V1Controller
  def index
    lat = current_user.latitude
    lng = current_user.longitude

    render json: {errors: ['You should to set up your location before use search.']}, status: :unprocessable_entity and return if lat.nil? || lng.nil?

    @users_in_radius     = User.near([lat, lng], User::DISTANCE_IN_RADIUS).where.not(id: @current_user.id).order(user_name: :desc)
    @users_out_of_radius = User.near([lat, lng], User::DISTANCE_OUT_OF_RADIUS).where.not(id: [@current_user.id] + @users_in_radius).order(user_name: :desc)
  end
end
