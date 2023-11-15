class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # Sign up Page
  def new
    if !logged_in?
      @user = User.new
    else
      redirect_to root_path
    end
  end

  # Create User
  def create
    @user = User.find_by(username: params[:session][:username])
    if @user
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash[:error] = "Invalid username or password"
      redirect_to login_path
    end
  end

  # Show User Profile
  def show
    @user = current_user
  end

  # Edit User Profile
  def edit
    @user = current_user
  end

  # Update User Profile
  def update

  end

  # Delete User Profile
  def destroy

  end

  private

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    if @user != current_user
      flash[:error] = "You do not have permission to edit or delete this user"
      redirect_to(root_path)
    end
  end
end
