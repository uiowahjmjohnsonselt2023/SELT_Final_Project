class CheckoutController < ApplicationController
  before_action :require_login
  before_action :set_item, only: [:show, :purchase]

  def show
    # @item is already set by set_item
    puts "Made it to show controller call --------------------------------------------"

    @user = current_user
    @item
    @seller = User.find(@item.user_id)
  end


  def purchase

    puts "Made it to purchase controller call --------------------------------------------"
    selected_address_id = params[:address_id]
    selected_payment_method_id = params[:payment_method_id]


    # No need to find @item again, it's already set by set_item
    result = current_user.purchase_item(@item, selected_address_id, selected_payment_method_id)

    selected_address_id = params[:address_id]
    selected_payment_method_id = params[:payment_method_id]

    # Log the received params
    puts "Selected address ID: #{selected_address_id}"
    puts "Selected payment method ID: #{selected_payment_method_id}"



    if result[:success]
      puts "Success --------------------------------------------"
      redirect_to root_path, notice: result[:message]
    else
      puts "Failure --------------------------------------------"
      redirect_to root_path, alert: result[:message]
    end
  end

  private

  def set_item
    @item = Item.find_by(id: params[:id])
    unless @item
      puts "Item not found --------------------------------------------"
      redirect_to root_path, alert: "Item not found." # Change to root_path or an existing path
    end
  end

  #def correct_user
  #  @user = User.find(params[:id])
  #  if @user != current_user
  #    flash[:error] = "You do not have permission to edit or delete this user"
  #    redirect_to(root_path)
  #  end
  #end

  def require_login
    unless current_user
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_path # Ensure this path is correct
    end
  end
end
