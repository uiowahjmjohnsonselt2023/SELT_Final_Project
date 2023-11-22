# app/models/payment_method.rb
class PaymentMethod < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :encrypted_card_number, presence: true
  validates :encrypted_card_number_iv, presence: true
  validates :expiration_date, presence: true
  validates :user_id, presence: true

  def valid_payment_method_input?(card_number, card_iv, expiration_date)
    valid_card_number?(card_number) && valid_card_iv?(card_iv) && valid_expiration_date?(expiration_date)
  end

  private

  def valid_card_number?(card_number)
    # Add validation logic for the card number
    # Check to make sure the card number is a string and only contains digits
    return false unless card_number.is_a?(String) && card_number.match?(/\A\d+\z/)

    # Check to make sure the card number is a valid length
    valid_lengths = [15, 16, 19]
    return false unless valid_lengths.include?(card_number.length)

    true
  end

  def valid_card_iv?(card_iv)
    # Add validation logic for the card IV
    card_iv.is_a?(String) && card_iv.match?(/\A\d{3}\z/)
  end

  def valid_expiration_date?(expiration_date)
    # Regular expression to match the date format MM/YYYY
    regex = /^(0[1-9]|1[0-2])\/\d{4}$/
    regex.match?(expiration_date)
  end

end
