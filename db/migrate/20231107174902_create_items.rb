class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title, null: false
      t.text :description
      t.string :tags

      t.timestamps null: false
    end
  end
end
