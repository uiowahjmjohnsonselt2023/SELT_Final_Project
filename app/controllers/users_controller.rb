class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  # Sign up Page
  def new
    # default: render 'new' template
  end

  # Create User
  def create

  end

  # Show User Profile
  def show

  end

  # Edit User Profile
  def edit

  end

  # Update User Profile
  def update

  end

end
