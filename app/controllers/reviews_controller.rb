class ReviewsController < ApplicationController

  before_filter :set_current_user, :only => [:create, :edit, :update, :destroy]
  before_filter :correct_purchase_create, only: [:create]
  before_filter :correct_purchase_destroy, only: [:destroy]
  before_filter :correct_user, only: [:create, :edit, :update, :destroy]
  before_filter :find_review, only: [:edit, :update, :destroy]

  def create

    @review = Review.new(
      title: params[:review][:title],
      rating: params[:review][:rating],
      content: params[:review][:content],
      reviewer_id: params[:review][:reviewer_id],
      seller_id: params[:review][:seller_id],
      item_id: params[:review][:item_id]
    )

    # Assuming current_user is the one who made the purchase
    purchase = Purchase.find_by(item_id: params[:review][:item_id], user: current_user)

    if purchase && !purchase.reviewed?
      @review.purchase = purchase
      if @review.save
        flash[:notice] = "Review was saved"
        redirect_to item_path(@review.item_id)
      else
        flash[:error] = "Review could not be saved"
        redirect_to item_path(@review.item_id)
      end
    else
      flash[:alert] = "You have already reviewed this item or the purchase does not exist."
      redirect_to item_path(@review.item_id)
    end
  end

  def destroy
    if @review.destroy
      flash[:notice] = "Review deleted successfully"
      @review.purchase.update(review: nil)
    else
      flash[:error] = "Review could not be deleted"
    end
    redirect_to user_path(current_user)
  end

  def edit

  end

  def update

  end

  private

  def correct_purchase_create
    # Make sure the purchase can be found and the user is correct
    begin
      @purchase = Purchase.find_by(item_id: params[:review][:item_id], user: current_user)
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "You do not have permission to review this item 1."
    end

    if @purchase.nil?
      redirect_to root_path, alert: "You do not have permission to review this item 2."
    elsif @purchase.reviewed?
        redirect_to root_path, alert: "You have already reviewed this item."
    end
  end

  def correct_purchase_destroy
    # Make sure the purchase can be found and the user is correct
    begin
      @purchase = Purchase.find_by(item_id: params[:review][:item_id], user: current_user)
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "You do not have permission to review this item."
    end

    if @purchase.nil?
      redirect_to root_path, alert: "You do not have permission to review this item."
    elsif @purchase.reviewed? == false
      redirect_to root_path, alert: "You have not yet reviewed this item."
    end
  end

  # Confirms the correct user.
  def correct_user
    if @purchase.user != current_user
      redirect_to root_path, alert: "You do not have permission to edit or delete this item."
    end
  end

  def find_review
    # Find the item by id and handle the case where it is not found
    begin
      @review = Review.find params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Review not found."
    end

    if @review.nil?
      redirect_to root_path, alert: "Review not found."
    elsif @review.purchase.user != current_user
      redirect_to root_path, alert: "You do not have permission to edit or delete this item."
    end
  end

end
