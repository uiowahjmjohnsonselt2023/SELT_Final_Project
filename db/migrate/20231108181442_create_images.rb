class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.binary :data

      t.timestamps null: false
    end
  end
end
