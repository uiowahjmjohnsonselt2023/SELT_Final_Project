
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
    redirect_to(root_path) unless @item.user == current_user
  end
end

