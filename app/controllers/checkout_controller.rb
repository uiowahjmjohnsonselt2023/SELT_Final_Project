class CheckoutController < ApplicationController
  before_action :require_login
  before_action :set_item, only: [:show, :purchase]

  def show
    @item = Item.find(params[:item_id])
  end

  def purchase
    @item = Item.find_by(params[:item_id])
    result = current_user.purchase_item(@item)

    if result[:success]
      redirect_to item_path(@item), notice: result[:message]
    else
      redirect_to item_path(@item), alert: result[:message]
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to items_path, alert: "Item not found."
  end

  def require_login
    unless current_user
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_path # or whatever your login path is
    end
  end
end
