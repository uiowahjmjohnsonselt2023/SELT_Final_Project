class User < ApplicationRecord
  before_save :create_session_token
  # Associations
  has_many :items, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :payment_methods, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_items, through: :bookmarks, source: :item, dependent: :destroy

  before_save { self.username = username.downcase }

  # Validations
  validates :username, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.create_with_omniauth(auth)
    create!(
      provider: auth['provider'],
      uid: auth['uid'],
      username: auth['info']['name'],
      email: auth['info']['email'],
    )
  end

  def create_session_token
    self.session_token = SecureRandom.urlsafe_base64
  end

  def add_bookmark(item)
    unless bookmarked_items.include?(item)
      bookmarked_items << item
    end
  end

  def remove_bookmark(item)
    if bookmarked_items.include?(item)
      bookmarked_items.delete(item)
    else
      false
    end
  end

  def bookmarked(item)
    bookmarked_items.include?(item)
  end

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
    #
  end

  def valid_expiration_date?(expiration_date)
    # Regular expression to match the date format MM/YYYY
    regex = /^(0[1-9]|1[0-2])\/\d{4}$/
    regex.match?(expiration_date)
  end


end
