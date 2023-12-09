class HomeController < ApplicationController
  def index
    # Fetch all the categories from the database
    @categories = Category.all
    # Fetch suggested items for sale, which might be a curated list based on some logic
    # Replace the 'suggested_items' method with the actual logic you want to use.
    # Suggest bookmark items first then random others for four total items
    # Fetch your bookmarked items if you are logged in

    @suggested_items = []
    @category_items = []
    @category_order = []

    # Fetch your bookmarked items if you are logged in
    if current_user
      @user_items = current_user.items
      @suggested_items = current_user.get_users_suggested_items
    else
      @suggested_items = User.get_suggested_items
    end



    @categories.each do |category|
      item = category.items.first
      if item
        @category_items << item
        @category_order << category.name
      end
    end
  end
end
