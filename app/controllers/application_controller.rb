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

  def correct_purchase_create
    # Make sure the purchase can be found and the user is correct
    begin
      @purchase = Purchase.find_by(item_id: params[:review][:item_id], user: current_user)

    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "You do not have permission to review this item"
      return
    end

    if @purchase.nil?
      redirect_to root_path, alert: "You do not have permission to review this item"
    elsif @purchase.reviewed?
      redirect_to root_path, alert: "You have already reviewed this item."
    end

  end

  def correct_purchase_destroy
    # Make sure the purchase can be found and the user is correct
    begin
      @purchase = Purchase.find_by(item_id: params[:item_id], user: current_user)
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "You do not have permission to review this item."
      return
    end

    if @purchase.nil?
      redirect_to root_path, alert: "You do not have permission to review this item."
    elsif @purchase.reviewed? == false
      redirect_to root_path, alert: "You have not yet reviewed this item."
    end
  end


  def find_user
    # Find the user by id and handle the case where it is not found
    begin
      @user = User.find params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "User not found."
    end
  end


  def find_review
    # Find the item by id and handle the case where it is not found
    begin
      @review = Review.find params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Review not found."
      return
    end

    if @review.nil?
      redirect_to root_path, alert: "Review not found."
    elsif @review.purchase.user != current_user
      redirect_to root_path, alert: "You do not have permission to edit or delete this item."
    end
  end

end
