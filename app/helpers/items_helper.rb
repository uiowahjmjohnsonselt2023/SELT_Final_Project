module ItemsHelper

  def find_item
    # Find the item by id and handle the case where it is not found
    begin
      @item = Item.find params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Item not found."
    end
  end

  def set_item
    @item = Item.find_by(id: params[:id])
    unless @item
      redirect_to root_path, alert: "Item not found."
    end
  end
end
