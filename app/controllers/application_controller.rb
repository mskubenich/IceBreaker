class ApplicationController < ActionController::Base

  include ApplicationHelper
  include SessionsHelper

  before_filter :authenticate_user

  rescue_from Exception, with: :catch_exceptions

  def authenticate_user
    if current_user
      if Time.now - current_session.updated_at > 24.hours
        current_session.destroy
        respond_with_errors
      else
        current_session.update_attribute :updated_at, Time.now
      end
    else
      respond_with_errors
    end
  end

  private

  def respond_with_errors
    render json: {errors: ['Access denied.'] }, status: :unauthorized and return
  end

  def catch_exceptions(e)

    if e.kind_of? CanCan::AccessDenied
      respond_with_errors
    end

    if e.kind_of? ActiveRecord::UnknownAttributeError
      render json: {errors: ['Invalid request.'], message: e.message }, status: :unprocessable_entity and return
    end

    # ErrorMessage.create(
    #     class_name: e.class,
    #     message: e.message,
    #     trace: e.backtrace.join("\n"),
    #     params: params,
    #     headers: request.headers,
    #     cookies: cookies.to_json,
    #     user_agent: request.user_agent,
    #     request: request.inspect
    # )

    raise
  end
end
