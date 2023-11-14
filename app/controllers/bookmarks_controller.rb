class BookmarksController < ApplicationController
  before_action :require_login

  def create
    begin
      item = Item.find(params[:item_id])
      if current_user.add_bookmark(item)
        render json: { status: :created, message: "Item bookmarked!" }, status: :created
      else
        render json: { status: :unprocessable_entity, message: "Unable to bookmark item!" }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { status: :not_found, message: "Item not found!" }, status: :not_found
    end
  end

  def destroy
    begin
      item = Item.find(params[:item_id])
      if current_user.remove_bookmark(item)
        render json: { status: :removed, message: "Bookmark Deleted!" }, status: :ok
      else
        render json: { status: :unprocessable_entity, message: "Unable to delete bookmark!" }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { status: :not_found, message: "Item not found!" }, status: :not_found
    end
  end
end
