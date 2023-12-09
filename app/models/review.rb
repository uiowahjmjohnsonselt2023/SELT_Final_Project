
class Review< ApplicationRecord
  belongs_to :purchase

  def new_review(params)
    Review.new(
      title: params[:title],
      rating: params[:rating],
      content: params[:content],
      reviewer_id: params[:reviewer_id],
      seller_id: params[:seller_id],
      item_id: params[:item_id]
    )
  end

end
