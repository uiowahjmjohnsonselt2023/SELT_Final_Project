# app/models/payment_method.rb
class PaymentMethod < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :encrypted_card_number, presence: true
  validates :encrypted_card_number_iv, presence: true
  validates :expiration_date, presence: true
  validates :user_id, presence: true
end
