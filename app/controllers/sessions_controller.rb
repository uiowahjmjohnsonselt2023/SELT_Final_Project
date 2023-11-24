class SessionsController < ApplicationController
  skip_before_filter :set_current_user

  # Create Login Session
  def create
    auth = request.env['omniauth.auth']
    user = User.find_by_provider_and_uid(auth['provider'], auth['uid']) || User.create_with_omniauth(auth)
    session[:session_token] = user.session_token
    redirect_to root_path
  end

  # Destroy Login Session
  def destroy
    session[:session_token] = nil
    @current_user = nil
    flash[:notice] = "You have been logged out"
    redirect_to root_path
  end
end
