class ItemsController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]

  # List all items
  def index

  end

  # Form for new item
  def new
    @item = Item.new
    @categories = Category.all
  end

  # Create new item listing
  def create
    item = Item.new.insert_item(params[:item][:title], params[:item][:description], params[:item][:price], current_user.id, params[:item][:category_ids], params[:item][:images])
    redirect_to item_path(item)
  end

  # Show item details
  def show
    @item = Item.find(params[:id])
    @related_items = related_items_for(@item)
    @user = User.find(@item.user_id)
  end

  # Edit item form
  def edit
    puts "HERE 2"
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
    redirect_to(root_path) unless @item.user == current_user
  end
end

