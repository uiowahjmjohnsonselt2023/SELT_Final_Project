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

  def omniauth
    puts ""
    puts "HERE 1"
    puts ""
    @user = User.find_or_create_by(uid: request.env['omniauth.auth']['uid'], provider: request.env['omniauth.auth']['provider']) do |u|
      puts ""
      puts request.env['omniauth.auth'].inspect
      puts ""
      puts request.env['omniauth.auth']['info'].inspect
      puts ""
      puts request.env['omniauth.auth']['info']['name']
      puts ""

      u.username = request.env['omniauth.auth']['info']['name']
      u.email = request.env['omniauth.auth']['info']['email']
      u.phone_number = request.env['omniauth.auth']['info']['phone']
    end
    puts ""
    puts "HERE 2"
    puts ""
    puts @user.valid?
    puts ""
    if @user.valid?
      puts ""
      puts "HERE 3"
      puts ""
      session[:user_id] = @user.id
      redirect_to root_path
    else
      puts ""
      puts "HERE 4"
      puts ""
      render :new
    end
  end
end
