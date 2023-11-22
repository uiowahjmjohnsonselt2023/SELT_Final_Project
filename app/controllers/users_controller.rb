class UsersController < ApplicationController
  before_filter :set_current_user, :only => [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # Show User Profile
  def show
    @user = User.find(params[:id])
  end

  # Edit User Profile
  def edit
    @user = current_user
  end

  # Update User Profile
  def update

  end

  def add_payment_method
    @user = current_user
    @user.payment_methods.create!(encrypted_card_number: "encrypted_card_number", encrypted_card_number_iv: "encrypted_card_number_iv", expiration_date: Date.new(2025,01,01).to_s(:long))
    redirect_to user_path(@user)
  end

  def add_address
    @user = current_user
    @user.addresses.create!(shipping_address_1: "123 Main St", shipping_address_2: "Apt 1", city: "Anytown", state: "State", country: "Country", postal_code: "12345")
    redirect_to user_path(@user)
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
