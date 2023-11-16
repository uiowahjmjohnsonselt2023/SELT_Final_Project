class CheckoutController < ApplicationController
  def show
    @item = Item.find(params[:item_id])
    # additional logic for checkout page
  end
end
