class ReviewsController < ApplicationController

  before_filter :set_current_user, :only => [:create, :edit, :update, :destroy]
  before_filter :correct_purchase_create, only: [:create]
  before_filter :correct_purchase_destroy, only: [:destroy]
  before_filter :correct_user_for_purchase, only: [:create, :edit, :update, :destroy]
  before_filter :find_review, only: [:edit, :update, :destroy]

  def create
    @review = Review.new_review(params[:review])

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
end
