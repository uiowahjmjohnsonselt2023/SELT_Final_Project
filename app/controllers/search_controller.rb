class SearchController < ApplicationController
  before_action :require_login

  # Perform search and display results, with optional category filtering
  def index
    puts params[:search_term]
    @results = Item.search(params[:search_term], params[:categories])
  end
end
