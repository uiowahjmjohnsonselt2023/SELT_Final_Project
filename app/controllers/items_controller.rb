
class ItemsController < ApplicationController
  before_action :set_item, only: [:show]
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
    @user = @item.user
    # @related_items = related_items_for(@item)
    @related_items = "TEST"
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

  def set_item
    @item = Item.find(params[:id])
  end

  def related_items_for(item)
    # Fetch other items by the same user, excluding the current item
    Item.where(user_id: item.user_id).where.not(id: item.id).limit(4)
  end

  
end

