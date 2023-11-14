class BookmarksController < ApplicationController

  def create
    item = Item.find(params[:item_id])
    current_user.bookmarked_items << item
    # Redirect or respond as appropriate
  end

  def destroy
    item = Item.find(params[:item_id])
    bookmark = current_user.bookmarks.find_by(item_id: item.id)
    bookmark.destroy if bookmark
    # Redirect or respond as appropriate
  end

end
