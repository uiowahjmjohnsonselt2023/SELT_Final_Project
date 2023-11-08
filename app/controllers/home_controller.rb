class HomeController < ApplicationController
  skip_before_action :require_login, only: [:index]

  def index
    # Fetch all categories. You would need a Category model for this,
    # or you can remove this line if you don't have different categories.
    @categories = Category.all if defined?(Category)
    # TODO fix this to use the database categories
    # Should get up to ten categories from the database
    @categories = [{:id => 1, :name => "Category 1"}, {:id => 2, :name => "Category 2"}, {:id => 2, :name => "Category 3"}, {:id => 2, :name => "Category 4"}, {:id => 2, :name => "Category 5"}]

    # Fetch suggested items for sale, which might be a curated list based on some logic
    # Replace the 'suggested_items' method with the actual logic you want to use.
    @suggested_items = Item.all.limit(3) # Example: get 10 items for simplicity

    # Fetch items for sale by the current user if they are logged in
    @user_items = current_user.items if current_user
  end

end
