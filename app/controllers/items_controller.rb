class ItemsController < ApplicationController
  before_action :require_login
  before_action :correct_user, only: [:edit, :update, :destroy]

  # Form for new item
  def new
    @item = Item.new
  end

  # Create new item listing
  def create

  end

  # Show item details
  def show
    @item = Item.find(params[:id])
    @related_items = @item.find_related_items
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

