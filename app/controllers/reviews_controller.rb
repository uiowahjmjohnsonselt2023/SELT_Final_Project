class ReviewsController < ApplicationController

  before_filter :set_current_user, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :find_review, only: [:show, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update, :destroy]

  # validations
  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :content, presence: true, length: { maximum: 500 }
  validates :reviewer_id, presence: true
  validates :seller_id, presence: true
  validates :item_id, presence: true

  def index

  end

  def new
    @review = Review.new
  end

  def create

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
