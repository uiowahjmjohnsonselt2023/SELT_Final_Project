class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  # Sign up Page
  def new
    # default: render 'new' template
    @user = User.new
  end

  # Create User
  def create

  end

  # Show User Profile
  def show
    @user = current_user
  end

  # Edit User Profile
  def edit
    @user = User.find(params[:id])
  end

  # Update User Profile
  def update

  end

end
