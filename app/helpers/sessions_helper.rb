module SessionsHelper
  def sign_in(user, options = {})
    @current_session = user.create_session device: options[:device], device_token: options[:device_token]
    # cookies.permanent[:session_token] = @current_session.token
    self.current_user = user
    current_session
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user
      @current_user ||= current_session.user if current_session
  end

  def current_session
      @current_session ||= Session.find_by_token([cookies[:session_token], params[:session_token], request.headers['Session-Token']].compact)
  end

  def sign_out
      current_session.destroy if current_session
      # cookies.permanent[:session_token] = nil
      self.current_user = nil
  end

  def destroy_all
      current_session.user.session.destroy if current_session
      # cookies.permanent[:session_token] = nil
      self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

end