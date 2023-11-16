class HomeController < ApplicationController
  before_action :require_login

  def index
    # Fetch all the categories from the database
    @categories = Category.all.limit(4)

    # Fetch suggested items for sale, which might be a curated list based on some logic
    # Replace the 'suggested_items' method with the actual logic you want to use.
    # Suggest bookmark items first then random others for four total items
    # Fetch your bookmarked items if you are logged in
    @suggested_items = current_user.bookmarked_items if current_user
    num_items = @suggested_items.length

    if num_items < 4
      @suggested_items = @suggested_items + Item.all.limit(4 - num_items)
    end

    # Fetch items for sale by the current user
    @user_items = current_user.items

  end

end
