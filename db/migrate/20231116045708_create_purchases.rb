class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true

      t.timestamps null: false
    end

    add_index :purchases, :item_id, unique: true
  end
end
