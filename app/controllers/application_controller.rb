class ApplicationController < ActionController::Base
  include SessionsHelper
  include ReviewsHelper

  protected

  def find_item
    begin
      @item = Item.find params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Item not found."
    end
  end

  def set_item
    @item = Item.find_by(id: params[:id])
    unless @item
      redirect_to root_path, alert: "Item not found."
    end
  end

  def round_dimensions
    self.length = length.round(1) if length
    self.width = width.round(1) if width
    self.height = height.round(1) if height
    self.weight = weight.round(1) if weight
  end

  def set_current_user
    @current_user ||= User.find_by_session_token(session[:session_token])
    unless @current_user
      flash[:error] = "You must be logged in to access this section"
      redirect_to root_path
    end
  end

  def correct_user
    @user = User.find(params[:id])
    if @user != current_user
      flash[:error] = "You do not have permission to edit or delete this user"
      redirect_to(root_path)
    end
  end

  def correct_user_for_item
    if @item.user != current_user
      redirect_to root_path, alert: "You do not have permission to edit or delete this item."
    end
  end

  def correct_user_for_purchase
    if @purchase.user != current_user
      redirect_to root_path, alert: "You do not have permission to edit or delete this item."
    end
  end
end
