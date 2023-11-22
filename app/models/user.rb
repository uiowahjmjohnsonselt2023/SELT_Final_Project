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


end
