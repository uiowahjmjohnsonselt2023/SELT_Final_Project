class SearchController < ApplicationController
  before_action :require_login

  # Perform search and display results, with optional category filtering
  def index
    if params[:categories].nil? or params[:categories].empty?
      @results = Item.search params[:search_term], Category.all.map(&:name)
    else
      @results = Item.search(params[:search_term], params[:categories])
    end
  end
end
