class SessionsController < ApplicationController
  before_action :require_login, only: [:destroy]

  # Login page
  def new
    # Renders the login form if user is not logged in
    if logged_in?
      flash[:error] = "You are already logged in"
      redirect_to root_path
    end
  end

  # Create Login Session
  def create
    if logged_in?
      flash[:error] = "You are already logged in"
      redirect_to root_path
      return
    end
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
