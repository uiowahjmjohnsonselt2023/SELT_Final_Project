class User < ApplicationRecord
  before_save :create_session_token
  # Associations
  has_many :items, dependent: :delete_all
  has_many :addresses, dependent: :delete_all
  has_many :payment_methods, dependent: :delete_all
  has_many :bookmarks, dependent: :delete_all
  has_many :bookmarked_items, through: :bookmarks, source: :item, dependent: :delete_all
  has_many :purchases, dependent: :delete_all
  has_many :purchased_items, through: :purchases, source: :item, dependent: :delete_all
  has_many :reviews, dependent: :delete_all

  has_many :written_reviews, class_name: 'Review', foreign_key: 'reviewer_id', dependent: :destroy
  has_many :received_reviews, class_name: 'Review', foreign_key: 'seller_id', dependent: :destroy

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

  def add_bookmark(item_id)
    item = Item.find_by(id: item_id)
    unless bookmarked_items.include?(item)
      bookmarked_items << item
    end
  end

  def remove_bookmark(item_id)
    item = Item.find_by(id: item_id)
    if bookmarked_items.include?(item)
      bookmarked_items.delete(item)
    else
      false
    end
  end

  def bookmarked(item)
    bookmarked_items.include?(item)
  end

  def get_users_suggested_items
    # Select bookmarked items that have not been purchased
    suggested_items = bookmarked_items.includes(:purchase).where(purchases: { item_id: nil }).limit(4)
    num_items = suggested_items.length

    # If there are less than 4 bookmarked items, fill the rest with other items that have not been purchased
    if num_items < 4
      excluded_item_ids = suggested_items.map(&:id)
      additional_items = Item.includes(:purchase)
                             .where.not(user: self)
                              .where.not(id: excluded_item_ids)
                             .where(purchases: { item_id: nil })
                             .limit(4 - num_items)
      suggested_items += additional_items
    end
    suggested_items
  end

  def self.get_suggested_items
    Item.includes(:purchase).where(purchases: { item_id: nil }).limit(4)
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
