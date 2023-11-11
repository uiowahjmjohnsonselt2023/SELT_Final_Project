class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
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
    if @user != current_user
      flash[:error] = "You do not have permission to edit or delete this user"
      redirect_to(root_path)
    end
  end
end
