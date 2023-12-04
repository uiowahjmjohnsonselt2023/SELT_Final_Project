class AddDescriptorsToItems < ActiveRecord::Migration
  def change
    add_column :items, :length, :float
    add_column :items, :width, :float
    add_column :items, :height, :float
    add_column :items, :dimension_units, :string
    add_column :items, :weight, :float
    add_column :items, :weight_units, :string
    add_column 
    add_column :items, :condition, :integer
  end
end
