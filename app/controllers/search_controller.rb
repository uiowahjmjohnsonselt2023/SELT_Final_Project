class SearchController < ApplicationController
  before_action :require_login

  # Perform search and display results, with optional category filtering
  def index
    if params[:bookmarks].present?
      # only get the users bookmarked items
      @results = current_user.bookmarked_items
    else
      # set up the min and max price for the price range
      if params[:categories].nil? or params[:categories].empty?
        @results = Item.search params[:search_term], Category.all.map(&:name)
      else
        @results = Item.search(params[:search_term], params[:categories])
      end

      if params[:min_price].present?
        @results = @results.where("price >= ?", params[:min_price])
      end
      if params[:max_price].present?
        @results = @results.where("price <= ?", params[:max_price])
      end
    end
  end
end
