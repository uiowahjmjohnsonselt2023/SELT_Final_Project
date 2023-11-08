class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  # Login page
  def new
    # Renders the login form
  end

  # Create Login Session
  def create
    user = User.find_by(username: params[:session][:username].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path
    else
      flash.now[:danger] = 'Invalid username/password combination'
      render 'new'
    end
  end

  # Destroy Login Session
  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
