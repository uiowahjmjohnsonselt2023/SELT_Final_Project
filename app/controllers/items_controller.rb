class ItemsController < ApplicationController
  before_filter :set_current_user, :only => [:new, :create, :edit, :update, :destroy]
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
    @item = Item.find(params[:id])
    @related_items = @item.find_related_items
    @user = User.find(@item.user_id)
    @bookmarked = current_user.bookmarked_items.include?(@item) if current_user

    if @item.purchased?
      render :purchased
    end
  end

  # Edit item form
  def edit
    @item = Item.find(params[:id])
    @categories = Category.all
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
    if @item.user != current_user
      flash[:error] = "You do not have permission to edit or delete this item"
      redirect_to(root_path)
    end
  end
end

