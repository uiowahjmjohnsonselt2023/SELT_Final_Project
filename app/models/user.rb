class User < ApplicationRecord
  has_many :items, dependent: :destroy
  # Ensures username uniqueness by downcasing the username attribute
  before_save { self.username = username.downcase }

  # Validates the presence of a username, and that it's no longer than 50 characters
  validates :username, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  # If using has_secure_password:
  # - Ensures passwords are present and match
  # - Requires a password_digest attribute on the model (which you'll need to add via a migration)
  # - Provides methods to set and authenticate against a BCrypt password (this requires the bcrypt gem)
  has_secure_password

  # Validates the presence of a password, requiring a minimum length of 6 characters
  validates :password, presence: true, length: { minimum: 4 }
end
