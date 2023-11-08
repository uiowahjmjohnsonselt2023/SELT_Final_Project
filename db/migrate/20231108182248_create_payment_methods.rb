class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.references :user, index: true, foreign_key: true
      t.string :encrypted_card_number
      t.string :encrypted_card_number_iv
      t.date :expiration_date

      t.timestamps null: false
    end
  end
end
