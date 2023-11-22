
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



  def valid_address_input?(shipping_address_1, shipping_address_2, city, state, country, postal_code)
    valid_shipping_address_1?(shipping_address_1) && valid_shipping_address_2?(shipping_address_2) && valid_city?(city) && valid_state?(state) && valid_country?(country) && valid_postal_code?(postal_code)
  end

  private
  def valid_shipping_address_1?(shipping_address_1)
    shipping_address_1.is_a?(String)
  end

  def valid_shipping_address_2?(shipping_address_2)
    shipping_address_2.is_a?(String)
  end

  def valid_city?(city)
    city.is_a?(String) && city.gsub(/\s+/, "").match?(/\A[a-zA-Z]+\z/)
  end

  def valid_state?(state)
    state.is_a?(String) && state.gsub(/\s+/, "").match?(/\A[a-zA-Z]+\z/)
  end

  def valid_country?(country)
    country.is_a?(String) && country.gsub(/\s+/, "").match?(/\A[a-zA-Z]+\z/)
  end

  def valid_postal_code?(postal_code)
    postal_code.is_a?(String) && postal_code.match?(/\A\d{5}\z/)
  end


end
