class CreateItemsCategoriesJoinTable < ActiveRecord::Migration
  def change
    create_table :items_categories, id: false do |t|
      t.belongs_to :item, index: true
      t.belongs_to :category, index: true
    end
  end
end
