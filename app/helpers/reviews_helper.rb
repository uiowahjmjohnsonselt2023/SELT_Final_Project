module ReviewsHelper

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
      @purchase = Purchase.find_by(item_id: params[:item_id], user: current_user)
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "You do not have permission to review this item."
    end

    if @purchase.nil?
      redirect_to root_path, alert: "You do not have permission to review this item."
    elsif @purchase.reviewed? == false
      redirect_to root_path, alert: "You have not yet reviewed this item."
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
