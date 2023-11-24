class CheckoutController < ApplicationController
  before_action :require_login
  before_action :set_item, only: [:show, :purchase]

  def show
    # @item is already set by set_item
    @user = current_user
    @item
    @seller = User.find(@item.user_id)
  end


  def purchase
    selected_address_id = params[:address_id]
    selected_payment_method_id = params[:payment_method_id]

    # No need to find @item again, it's already set by set_item
    result = current_user.purchase_item(@item, selected_address_id, selected_payment_method_id)

    if result[:success]
      redirect_to root_path, notice: result[:message]
    else
      redirect_to root_path, alert: result[:message]
    end
  end

  private

  def set_item
    @item = Item.find_by(id: params[:id])
    unless @item
      redirect_to root_path, alert: "Item not found." # Change to root_path or an existing path
    end
  end

  def require_login
    unless current_user
      flash[:error] = "You must be logged in to access this section"
      redirect_to root_path # Ensure this path is correct
    end
  end
end
