class CheckoutController < ApplicationController
  before_action :require_login
  before_action :set_item, only: [:show, :purchase]

  def show
    # @item is already set by set_item
    puts "Made it to show controller call --------------------------------------------"
    def show
      @item = Item.find(params[:item_id])
    end
  end

  def purchase

    puts "Made it to purchase controller call --------------------------------------------"


    # No need to find @item again, it's already set by set_item
    result = current_user.purchase_item(@item)

    puts "Made it here --------------------------------------------"
    puts "Outputting current items purchased"
    puts @current_user.purchased_items.inspect
    puts "Made it here --------------------------------------------"


    if result[:success]
      puts "Success --------------------------------------------"
      redirect_to item_path(@item), notice: result[:message]
    else
      puts "Failure --------------------------------------------"
      redirect_to item_path(@item), alert: result[:message]
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

  def require_login
    unless current_user
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_path # Ensure this path is correct
    end
  end
end
