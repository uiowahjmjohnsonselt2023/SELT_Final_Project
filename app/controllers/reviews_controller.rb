class ReviewsController < ApplicationController

  before_filter :set_current_user, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :find_review, only: [:show, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update, :destroy]


  # validations
  # validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  # validates :content, presence: true, length: { maximum: 500 }
  # validates :reviewer_id, presence: true
  # validates :seller_id, presence: true
  # validates :item_id, presence: true

  def index

  end

  def new
    @review = Review.new
  end

  def create

    @review = Review.new(
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

  def show

  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  # Confirms the correct user.
  def correct_user
    if @item.user != current_user
      redirect_to root_path, alert: "You do not have permission to edit or delete this item."
    end
  end

  def find_review
    # Find the item by id and handle the case where it is not found
    @review = Review.find params[:id]
  end

end
