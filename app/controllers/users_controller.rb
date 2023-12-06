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

    payment_method = PaymentMethod.new

    today = Date.today

    if params[:expiration_year].to_i < today.year
      flash[:error] = "Invalid Expiration Date"
      redirect_to user_path(@user)
      return
    elsif params[:expiration_year].to_i == today.year && params[:expiration_month].to_i <= today.month
      flash[:error] = "Invalid Expiration Date"
      redirect_to user_path(@user)
      return
    end

    expiration_date = params[:expiration_month] + '/' + params[:expiration_year]

    if payment_method.valid_payment_method_input?(params[:card_number], expiration_date)
      #expiration_date = Date.strptime(expiration_date, "%m/%Y")
      if @user.payment_methods.create!(card_number: params[:card_number], expiration_date: expiration_date)
        flash[:alert] = "Payment Method Added"
      else
        flash[:error] = "Error Adding Payment Method"
      end
    else
      flash[:error] = "Invalid Payment Method Inputs: 15, 16, or 19 digit card number, 3 digit cvv, and (MM/YYYY) expiration date"
    end

    redirect_to user_path(@user)
  end

  def add_address
    @user = current_user

    input_check = Address.new

    if input_check.valid_address_input?(params[:shipping_address_1], params[:shipping_address_2], params[:city], params[:state], params[:country], params[:postal_code])
      if @user.addresses.create!(shipping_address_1: params[:shipping_address_1], shipping_address_2: params[:shipping_address_2], city: params[:city], state: params[:state], country:  params[:country], postal_code: params[:postal_code])
        flash[:alert] = "Address Added"
      else
        flash[:error] = "Error Adding Address"
      end
    else
      flash[:error] = "Invalid Address Inputs"
    end
    redirect_to user_path(@user)
  end

  def delete_address
    address = current_user.addresses.find(params[:address_id])
    if address.destroy
      redirect_to edit_user_path(current_user), notice: 'Address deleted successfully.'
    else
      redirect_to edit_user_path(current_user), alert: 'Could not delete the address.'
    end
  end

  def delete_payment_method
    payment_method = current_user.payment_methods.find(params[:payment_method_id])
    if payment_method.destroy
      redirect_to edit_user_path(current_user), notice: 'Payment method deleted successfully.'
    else
      redirect_to edit_user_path(current_user), alert: 'Could not delete the payment method.'
    end
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
