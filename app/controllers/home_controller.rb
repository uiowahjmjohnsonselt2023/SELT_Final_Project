class HomeController < ApplicationController

  def index
    # Fetch all the categories from the database
    @categories = Category.all
    # Fetch suggested items for sale, which might be a curated list based on some logic
    # Replace the 'suggested_items' method with the actual logic you want to use.
    # Suggest bookmark items first then random others for four total items
    # Fetch your bookmarked items if you are logged in
    num_items = 0

    @suggested_items = []
    @category_items = []
    @category_order = []



    # Fetch your bookmarked items if you are logged in
    if current_user
      # Select bookmarked items that have not been purchased
      @suggested_items = current_user.bookmarked_items.includes(:purchase).where(purchases: { item_id: nil }).limit(4)
      num_items = @suggested_items.length
      @user_items = current_user.items

      # If there are less than 4 bookmarked items, fill the rest with other items that have not been purchased
      if num_items < 4
        additional_items = Item.includes(:purchase).where.not(user: current_user).where(purchases: { item_id: nil }).limit(4 - num_items)
        @suggested_items += additional_items
      end
    else
      # Fetch 4 items that have not been purchased for non-logged-in users
      @suggested_items = Item.includes(:purchase).where(purchases: { item_id: nil }).limit(4)
    end
    @categories.each do |category|
      item = Item.search(nil, category.name).first
      if item
        @category_items << item
        @category_order << category.name
      end
      end
  end
end
