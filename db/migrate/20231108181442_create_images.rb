class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.binary :data

      t.timestamps
    end
  end
end
