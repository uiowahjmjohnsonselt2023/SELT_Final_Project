class HomeController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def index
    # Fetch all the categories from the database
    @categories = Category.all.limit(4)

    # Fetch suggested items for sale, which might be a curated list based on some logic
    # Replace the 'suggested_items' method with the actual logic you want to use.
    @suggested_items = Item.all.limit(4) # Example: get 10 items for simplicity

    # Fetch items for sale by the current user if they are logged in
    @user_items = current_user.items if current_user

  end

end
