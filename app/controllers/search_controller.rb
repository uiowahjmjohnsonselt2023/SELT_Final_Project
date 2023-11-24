class SearchController < ApplicationController
  # Perform search and display results, with optional category filtering
  def index
    @results = if params[:bookmarks].present? && params[:bookmarks] == '1' && current_user
                 current_user.bookmarked_items
               elsif params[:categories].present? && params[:search_term].present?
                 Item.search(params[:search_term], params[:categories])
               elsif params[:categories].present?
                 Item.search(nil, params[:categories])
               elsif params[:search_term].present?
                 Item.search(params[:search_term], Category.all.map(&:name))
               elsif params[:purchased].present? && params[:user_id].present?
                 user = User.find_by(id: params[:user_id])
                 @results = user.purchased_items if user
               else
                 Item.all
               end

    if params[:seller].present?
      seller = User.find_by(username: params[:seller])
      @results = seller ? @results.where("items.user_id = ?", seller.id) : []
    end

    if params[:min_price].present?
      @results = @results.where("price >= ?", params[:min_price])
    end

    if params[:max_price].present?
      @results = @results.where("price <= ?", params[:max_price])
    end
  end
end
