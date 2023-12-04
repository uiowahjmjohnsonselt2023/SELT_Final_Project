class ItemsController < ApplicationController
  before_filter :set_current_user, :only => [:new, :create, :edit, :update, :destroy]
  # Filter for finding the item and handling the case where it is not found
  before_filter :find_item, only: [:show, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update, :destroy]

  # Form for new item
  def new
    @item = Item.new
    @categories = Category.all
  end

  # Create new item listing
  def create
    item = Item.insert_item(
      current_user,
      params[:item][:title],
      params[:item][:description],
      params[:item][:price],
      params[:item][:category_ids],
      params[:item][:images]
    )
    redirect_to item_path(item)
  end

  # Show item details
  def show
    @related_items = @item.find_related_items
    @user = User.find(@item.user_id)
    @bookmarked = current_user.bookmarked_items.include?(@item) if current_user

    if @item.purchased?
      render :purchased
    end
  end

  # Edit item form
  def edit
    correct_user
    @categories = Category.all
  end

  # Update item listing
  def update
    # update the item with the new attributes
    if @item.update_item(params[:item][:title], params[:item][:description], params[:item][:price], params[:item][:category_ids], params[:item][:images], params[:remove_images])
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
    correct_user
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

  private

  # Confirms the correct user.
  def correct_user
    if @item.user != current_user
      redirect_to root_path, alert: "You do not have permission to edit or delete this item."
    end
  end

  def find_item
    # Find the item by id and handle the case where it is not found
    begin
      @item = Item.find params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Item not found."
    end
  end
end

