class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.string :encrypted_card_number
      t.string :expiration_date

      t.timestamps
    end
  end
end
