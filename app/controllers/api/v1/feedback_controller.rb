class Api::V1::FeedbackController < Api::V1Controller

  def create
    render json: { errors: ['Feedback body can\'t be blank.'] }, status: :unprocessable_entity and return if params[:message].blank?
    current_user.send_feedback(params[:message])
    render json: { message: 'Feedback was sent successfully' }
  end
end