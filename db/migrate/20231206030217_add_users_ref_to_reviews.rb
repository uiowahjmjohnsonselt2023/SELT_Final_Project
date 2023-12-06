class AddUsersRefToReviews < ActiveRecord::Migration
  def change
    add_reference :reviews, :reviewer, index: true
    add_foreign_key :reviews, :users, column: :reviewer_id

    # Add reference for the seller
    add_reference :reviews, :seller, index: true
    add_foreign_key :reviews, :users, column: :seller_id

    add_reference :reviews, :purchase, index: true, foreign_key: true

    add_reference :reviews, :item, index: true, foreign_key: true

  end
end
