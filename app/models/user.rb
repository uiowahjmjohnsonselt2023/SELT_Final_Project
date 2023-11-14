class User < ApplicationRecord
  has_secure_password

  # Associations
  has_many :items, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :payment_methods, dependent: :destroy
  has_many :bookmarks
  has_many :bookmarked_items, through: :bookmarks, source: :item

  before_save { self.username = username.downcase }

  # Validations
  validates :username, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, presence: true, numericality: true, length: { minimum: 10, maximum: 15 }
end
