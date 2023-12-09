class SearchController < ApplicationController
  # Perform search and display results, with optional category filtering
  def index
    @results = if current_user
                  Item.get_users_search_items(current_user, params)
               else
                  Item.get_search_items(params)
               end
  end
end
