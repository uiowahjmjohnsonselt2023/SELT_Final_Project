class ItemsController < ApplicationController
  before_filter :set_current_user, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :find_item, only: [:show, :edit, :update, :destroy]
  before_filter :correct_user_for_item, only: [:edit, :update, :destroy]

  # Form for new item
  def new
    @item = Item.new
    @categories = Category.all
  end

  # Create new item listing
  def create
    @item = Item.insert_item(current_user, params[:item])
    redirect_to item_path(@item)
  end

  # Show item details
  def show
    @related_items = @item.find_related_items
    @user = User.find(@item.user_id)
    @bookmarked = current_user.bookmarked_items.include?(@item) if current_user
    @reviews = @user.received_reviews
    if @item.purchased?
      render :purchased
    end
  end

  # Edit item form
  def edit
    @categories = Category.all
  end

  # Update item listing
  def update
    # update the item with the new attributes
    if @item.update_item(params[:item])
      # set a flash message if the item was updated successfully
      flash[:success] = "Item updated successfully"
    else
      # set a flash message if the item was not updated successfully
      flash[:error] = "Item could not be updated"
    end

    redirect_to item_path(Item.find(params[:id]))
  end

  # Delete item listing
  def destroy
    if @item.destroy
      flash[:success] = "Item deleted successfully"
    else
      flash[:error] = "Item could not be deleted"
    end
    redirect_to root_path
  end

  def related_items_for(item)
    # Fetch other items by the same user, excluding the current item
    Item.where(user_id: item.user_id).where.not(id: item.id).limit(4)
  end
end

