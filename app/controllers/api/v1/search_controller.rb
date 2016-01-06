class Api::V1::SearchController < Api::V1Controller
  def index
    lat = current_user.latitude
    lng = current_user.longitude

    render json: {errors: ['You should to set up your location before use search.']}, status: :unprocessable_entity and return if lat.nil? || lng.nil?

    @users_in_radius =     User.search latitude: lat,
                                       longitude: lng,
                                       current_user: current_user,
                                       distance: User::DISTANCE_IN_RADIUS,
                                       except_ids: current_user.id

    @users_out_of_radius = User.search latitude: lat,
                                       longitude: lng,
                                       current_user: current_user,
                                       distance: User::DISTANCE_OUT_OF_RADIUS,
                                       except_ids: [@current_user.id] + @users_in_radius
  end
end