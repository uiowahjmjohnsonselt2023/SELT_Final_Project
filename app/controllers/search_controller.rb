class SearchController < ApplicationController
  # Perform search and display results, with optional category filtering
  def index
    @results = if params[:bookmarks].present? && params[:bookmarks] == '1'
                 current_user.bookmarked_items
               else
                 Item.all
               end

    if params[:categories].present?
      @results = @results.joins(:categories).where(categories: { name: params[:categories] })
      @results = @results.search(params[:search_term], params[:categories])
    else
      @results = @results.search(params[:search_term], Category.all.map(&:name))
    end

    if params[:seller].present?
      seller = User.find_by(username: params[:seller])
      @results = seller ? @results.where("items.user_id = ?", seller.id) : Item.none
    end

    if params[:min_price].present?
      @results = @results.where("price >= ?", params[:min_price])
    end

    if params[:max_price].present?
      @results = @results.where("price <= ?", params[:max_price])
    end
  end
end
