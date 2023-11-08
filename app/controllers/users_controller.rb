class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update, :destroy]

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
    redirect_to(root_path) unless @user == current_user
  end
end
