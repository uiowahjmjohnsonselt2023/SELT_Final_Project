class AddUserRefToPaymentMethods < ActiveRecord::Migration
  def change
    add_reference :payment_methods, :user, index: true, foreign_key: true
  end
end
