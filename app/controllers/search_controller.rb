class SearchController < ApplicationController

  # Perform search and display results, with optional category filtering
  def index
    puts params.inspect # Just for debugging
    @results = Item.search(params[:search_term], params[:categories])
    puts @results.inspect # Just for debugging
  end



end
