class BookmarksController < ApplicationController
  before_action :set_current_user

  def create
    begin
      if current_user.add_bookmark(params[:item_id])
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
      if current_user.remove_bookmark(params[:item_id])
        render json: { status: :removed, message: "Bookmark Deleted!" }, status: :ok
      else
        render json: { status: :unprocessable_entity, message: "Unable to delete bookmark!" }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { status: :not_found, message: "Item not found!" }, status: :not_found
    end
  end
end
