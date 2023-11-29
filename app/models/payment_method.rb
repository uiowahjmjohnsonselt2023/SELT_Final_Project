# app/models/payment_method.rb
class PaymentMethod < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :encrypted_card_number, presence: true
  validates :expiration_date, presence: true
  validates :user_id, presence: true

  def valid_payment_method_input?(card_number, expiration_date)
    valid_card_number?(card_number) && valid_expiration_date?(expiration_date)
  end

  private

  def valid_card_number?(card_number)
    return false unless card_number.is_a?(String)
    card_number = card_number.gsub(/\s+/, "")

    # Check to make sure the card number is a valid length
    valid_lengths = [15, 16, 19]
    return false unless valid_lengths.include?(card_number.length) and card_number.match?(/\A\d+\z/)

    true
  end

  def valid_expiration_date?(expiration_date)
    # Regular expression to match the date format MM/YYYY
    regex = /^(0[1-9]|1[0-2])\/\d{4}$/
    regex.match?(expiration_date)
  end

end
