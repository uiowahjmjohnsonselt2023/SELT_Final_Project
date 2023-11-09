
class Address < ApplicationRecord
  # Assuming each address belongs to a user
  belongs_to :user

  # Basic validations
  validates :shipping_address_1, presence: true
  validates :shipping_address_2, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :postal_code, presence: true, numericality: { only_integer: true }, length: { maximum: 10 }
  validates :user_id, presence: true
end
