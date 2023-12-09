module SessionsHelper
  # Returns the current logged-in user (if any).
  def current_user
    if session[:session_token]
      @current_user ||= User.find_by_session_token(session[:session_token])
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user by removing their ID from the session.
  def log_out
    session.delete(:session_token)
    @current_user = nil
  end

  def require_login
    unless current_user
      flash[:error] = "You must be logged in to access this section"
      redirect_to root_path # Ensure this path is correct
    end
  end
end
