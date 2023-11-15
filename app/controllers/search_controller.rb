class SearchController < ApplicationController
  before_action :require_login

  # Perform search and display results, with optional category filtering
  def index
    puts "SELLER Ay Yo: #{params[:seller]}"
    # Start with all items or just bookmarked items based on the bookmarks param
    if params[:bookmarks].present? and params[:bookmarks] == '1'
      # Only get the user's bookmarked items
      @results = current_user.bookmarked_items
    else
      @results = Item.all
    end

    # Filter by categories if any are selected
    if params[:categories].present?
      @results = @results.joins(:categories).where(categories: { name: params[:categories] })
      @results = @results.search(params[:search_term], params[:categories])
    else
      @results = @results.search(params[:search_term], Category.all.map(&:name))
    end

    if params[:seller].present?
      # Filter to only the specified seller
      # Need to get the user ID from the username
      @results = @results.where("user_id = ?", User.find_by(username: params[:seller]).id)
    end

    # Filter by price range if specified
    @results = @results.where("price >= ?", params[:min_price]) if params[:min_price].present?
    @results = @results.where("price <= ?", params[:max_price]) if params[:max_price].present?
  end
end
