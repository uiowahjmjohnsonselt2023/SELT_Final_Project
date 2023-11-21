class Item < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :images, dependent: :destroy
  has_and_belongs_to_many :categories, join_table: :items_categories
  has_many :bookmarks, dependent: :destroy

  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :price, presence: true, numericality: { greater_than: 0, less_than: 1000000 }
  validates :user_id, presence: true

  def self.search(search_term, category_names)
    items = all

    # Scenario 1: No search term or categories, return all items in random order
    return items.order(Arel.sql('RANDOM()')) if search_term.blank? && category_names.blank?

    # Scenario 2: Categories provided, sort by number of matching categories
    if category_names.present?
      category_ids = Category.where(name: category_names).pluck(:id)
      items = items.joins(:categories).where(categories: { id: category_ids })
      items = items.group('items.id').order(Arel.sql('COUNT(categories.id) DESC'))
    end

    # Scenarios 3 and 4: Search term provided
    if search_term.present?
      # For SQLite, we'll just do a simple LIKE match
      # For PostgreSQL, we could use ILIKE for case-insensitive matching or more complex text search features
      match_condition = Rails.env.production? ? 'ILIKE' : 'LIKE'
      items = items.where("title #{match_condition} :search OR description #{match_condition} :search", search: "%#{search_term}%")

      if category_names.blank?
        # Scenario 3: Only search term is provided, sort by relevance
        items = items.order(Arel.sql('title DESC, description DESC'))
      else
        # Scenario 4: Both search term and categories provided, sort by category match count and then search term match
        items = items.group('items.id').order(Arel.sql('COUNT(categories.id) DESC, title DESC, description DESC'))
      end
    end

    items
  end

  def self.insert_item(user, title, description, price, category_ids, images)
    item = user.items.create!(title: title, description: description, price: price)
    images.each do |uploaded_image|
      next unless uploaded_image.respond_to?(:tempfile)
      image_file_path = uploaded_image.tempfile.path
      image = MiniMagick::Image.new(image_file_path)
      image.resize('256x256')
      image_type, image_data = Image.get_image_data(image_file_path)
      item.images.create!(data: image_data, image_type: image_type)
    end
    category_ids.each do |category_id|
      unless category_id.blank?
        item.categories << Category.find(category_id)
      end
    end
    item
  end

  def find_related_items
    # Fetch other items by the same user, excluding the current item
    Item.where(user_id: user_id).where.not(id: id).limit(4)
  end
end
