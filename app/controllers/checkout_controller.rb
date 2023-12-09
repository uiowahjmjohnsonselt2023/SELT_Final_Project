class CheckoutController < ApplicationController
  before_action :require_login
  before_action :set_item, only: [:show, :purchase]

  def show
    @user = current_user
    @seller = User.find(@item.user_id)
  end


  def purchase
    # No need to find @item again, it's already set by set_item
    result = current_user.purchase_item(@item, params[:address_id], params[:payment_method_id])

    if result[:success]
      redirect_to root_path, notice: result[:message]
    else
      redirect_to root_path, alert: result[:message]
    end
  end
end
