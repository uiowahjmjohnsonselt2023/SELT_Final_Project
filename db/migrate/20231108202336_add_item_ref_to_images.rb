class AddItemRefToImages < ActiveRecord::Migration
  def change
    add_reference :images, :item, index: true, foreign_key: true
  end
end
