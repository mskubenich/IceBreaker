class Api::V1Controller < ApiController
  skip_before_filter :authenticate_user, only: [:app_url]

  def app_url
    if params[:device]
      render json: {app_url: params[:device].downcase == 'http://ice-br8ker.com/icon.png'? 'android' : 'http://ice-br8ker.com/icon.png'}
    else
      render json: {error: 'No device type given.'},status: :unprocessable_entity
    end
  end

end
