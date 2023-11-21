class ApplicationController < ActionController::Base
  include SessionsHelper

  protected

  def set_current_user
    @current_user ||= User.find_by_session_token(session[:session_token])
    unless @current_user
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_path
    end
  end

  def current_user?(id)
    @current_user.id.to_s == id.to_s
  end

end
