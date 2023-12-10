class UsersController < ApplicationController
  before_filter :set_current_user, :only => [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # Show User Profile
  def show
    @user = User.find(params[:id])
    @reviews = @user.received_reviews
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
      redirect_to edit_user_path(current_user)
      return
    elsif params[:expiration_year].to_i == today.year && params[:expiration_month].to_i <= today.month
      flash[:error] = "Invalid Expiration Date"
      redirect_to edit_user_path(current_user)
      return
    end

    expiration_date = params[:expiration_month] + '/' + params[:expiration_year]

    if payment_method.valid_payment_method_input?(params[:card_number], expiration_date)
      @user.payment_methods.create!(card_number: params[:card_number], expiration_date: expiration_date)
      flash[:notice] = "Payment Method Added"
    else
      flash[:error] = "Invalid Payment Method Inputs: 15, 16, or 19 digit card number, 3 digit cvv, and (MM/YYYY) expiration date"
    end

    redirect_to edit_user_path(current_user)
  end

  def add_address
    @user = current_user

    input_check = Address.new

    if params[:country] == "Select Country"
      flash[:error] = "Invalid Address Inputs"
      redirect_to user_path(@user)
    elsif params[:country] == "United States" && params[:state] == "Select State"
      flash[:error] = "Invalid Address Inputs"
      redirect_to user_path(@user)
    end

    if params[:state] == "Select State"
      params[:state] = ""
    end

    if input_check.valid_address_input?(params[:shipping_address_1], params[:shipping_address_2], params[:city], params[:state], params[:country], params[:postal_code])
      @user.addresses.create!(shipping_address_1: params[:shipping_address_1], shipping_address_2: params[:shipping_address_2], city: params[:city], state: params[:state], country: params[:country], postal_code: params[:postal_code])
      flash[:notice] = "Address Added"
    else
      flash[:error] = "Invalid Address Inputs"
    end
    redirect_to edit_user_path(current_user)
  end

  def delete_address

    if params[:address_id].blank?
      redirect_to edit_user_path(current_user), alert: 'Could not delete the address. Must select an address.'
    else
      address = current_user.addresses.find(params[:address_id])
      if address.destroy
        redirect_to edit_user_path(current_user), notice: 'Address deleted successfully.'
      else
        redirect_to edit_user_path(current_user), alert: 'Could not delete the address.'
      end
    end



  end

  def delete_payment_method
    if params[:payment_method_id].blank?
      redirect_to edit_user_path(current_user), alert: 'Could not delete the payment method. Must select a payment method.'

    else
      payment_method = current_user.payment_methods.find(params[:payment_method_id])

      if payment_method.destroy
        redirect_to edit_user_path(current_user), notice: 'Payment method deleted successfully.'
      else
        redirect_to edit_user_path(current_user), alert: 'Could not delete the payment method.'
      end

    end


  end

  # Delete User Profile
  def destroy

  end
end
