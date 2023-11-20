class AddDetailsToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :address_id, :integer
    add_column :purchases, :payment_method_id, :integer
    add_index :purchases, :address_id
    add_index :purchases, :payment_method_id
    # If you want to enforce referential integrity at the database level:
    add_foreign_key :purchases, :addresses
    add_foreign_key :purchases, :payment_methods
  end
end
