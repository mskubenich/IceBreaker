class Api::V1::LocationController < Api::V1Controller

  def update
    if params[:latitude].nil? || params[:longitude].nil?
      render json: { errors: ['Latitude or Longitude are missed'] }, status: :unprocessable_entity
    else
      current_user.set_location(params[:latitude], params[:longitude])
      current_user.back_in_radius
      render json: { message: 'New location was set successfully' }
    end
  end

  def destroy
    current_user.reset_location
    render json: { message: 'Location was reset successfully' }
  end
end