
class ItemsController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]


  # List all items
  def index

  end

  # Form for new item
  def new

  end

  # Create new item listing
  def create
    @item = Item.new

  end

  # Show item details
  def show
    @item = Item.find(params[:id])
    @related_items = related_items_for(@item)
    @user = User.find(@item.user_id)
  end

  # Edit item form
  def edit

  end

  # Update item listing
  def update

  end

  # Delete item listing
  def destroy

  end
  def related_items_for(item)
    # Fetch other items by the same user, excluding the current item
    Item.where(user_id: item.user_id).where.not(id: item.id).limit(4)
  end


  private

  # Confirms the correct user.
  def correct_user
    @item = Item.find(params[:id])
    redirect_to(root_url) unless @item.user == current_user
  end
end

