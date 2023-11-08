class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :shipping_address_1
      t.string :shipping_address_2
      t.string :city
      t.string :state
      t.string :country
      t.string :postal_code

      t.timestamps null: false
    end
  end
end
