class SearchController < ApplicationController

  # Perform search and display results, with optional category filtering
  def index
    @results = Item.search(params[:search_term])
  end


end
