class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :item, index: true, foreign_key: true
      t.binary :data

      t.timestamps null: false
    end
  end
end
