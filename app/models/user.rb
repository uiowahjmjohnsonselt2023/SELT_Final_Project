class User < ApplicationRecord
  before_save :create_session_token
  # Associations
  has_many :items, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :payment_methods, dependent: :destroy
  has_many :bookmarks
  has_many :bookmarked_items, through: :bookmarks, source: :item
  has_many :purchases
  has_many :purchased_items, through: :purchases, source: :item

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


  def purchase_item(item, address_id, payment_method_id)
    return { success: false, message: 'Item not found.' } unless item

    if item.purchase.present?
      { success: false, message: 'This item has already been purchased.' }
    else
      purchase = purchases.create(item: item, address_id: address_id, payment_method_id: payment_method_id)
      if purchase.persisted?
        { success: true, message: 'Purchase successful!' }
      else
        { success: false, message: "Purchase Unsuccessful!\n" + purchase.errors.full_messages.join("\n") }
      end
    end
  end
end
