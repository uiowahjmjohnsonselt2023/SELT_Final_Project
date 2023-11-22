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
    puts "Payment Method Params----------------------------------------------------"
    puts params.inspect
    puts params[:card_number]
    puts params[:cvv]
    puts params[:expiration_date]

    expiration_date_str = params[:expiration_date]
    expiration_date = Date.strptime(expiration_date_str, '%m/%Y')
    puts expiration_date
    puts "-----------------------------------------------------------------------"
    @user = current_user

    #User.valid_payment_method(params[:card_number], params[:cvv], expiration_date)


    if PaymentMethod.valid_payment_method(params[:card_number], params[:cvv], params[:expiration_date])
      @user.payment_methods.create!(encrypted_card_number: params[:card_number],encrypted_card_number_iv: params[:cvv] ,expiration_date: expiration_date)
      flash[:alert] = "Payment Method Added"
    else
      flash[:error] = "Invalid Payment Method Inputs"
    end

    redirect_to user_path(@user)
  end

  def add_address
    @user = current_user
    @user.addresses.create!(shipping_address_1: params[:shipping_address_1], shipping_address_2: params[:shipping_address_2], city: params[:city], state: params[:state], country:  params[:country], postal_code: params[:postal_code])
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
