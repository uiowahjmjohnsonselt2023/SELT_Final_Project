class Item < ApplicationRecord
  before_save :round_dimensions

  # Associations
  belongs_to :user
  has_many :images, dependent: :delete_all
  has_and_belongs_to_many :categories, join_table: :items_categories
  has_many :bookmarks, dependent: :delete_all
  has_one :purchase, dependent: :delete

  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :price, presence: true, numericality: { greater_than: 0, less_than: 1000000 }
  validates :user_id, presence: true
  validates :length, numericality: { greater_than: 0, less_than: 1000000 }, allow_nil: true
  validates :width, numericality: { greater_than: 0, less_than: 1000000 }, allow_nil: true
  validates :height, numericality: { greater_than: 0, less_than: 1000000 }, allow_nil: true
  validates :weight, numericality: { greater_than: 0, less_than: 1000000 }, allow_nil: true
  validates :dimension_units, inclusion: { in: %w(in ft cm m) }, allow_nil: true
  validates :weight_units, inclusion: { in: %w(oz lbs g kg) }, allow_nil: true
  validates :condition, presence: true, inclusion: { in: 0..4 }

  def self.dimension_units
    %w(in ft cm m)
  end

  def self.weight_units
    %w(oz lbs g kg)
  end

  def self.conditions
    [
      'New',
      'Like New',
      'Used',
      'Well Used',
      'Poor'
    ]
  end

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

  def self.get_users_search_items(current_user, params)
    results = if params[:bookmarks].present? && params[:bookmarks] == '1' && current_user
                current_user.bookmarked_items
              elsif params[:purchased].present? && params[:user_id].present? && (user = User.find_by(id: params[:user_id]))
                user.purchased_items
              elsif params[:categories].present? && params[:search_term].present?
                Item.search(params[:search_term], params[:categories])
              elsif params[:categories].present?
                Item.search(nil, params[:categories])
              elsif params[:search_term].present?
                Item.search(params[:search_term], Category.all.map(&:name))
              else
                Item.all
              end

    if params[:seller].present?
      seller = User.find_by(username: params[:seller])
      results = seller ? results.where("items.user_id = ?", seller.id) : []
      return results if results.empty?
    end

    if params[:min_price].present?
      results = results.where("price >= ?", params[:min_price])
      return results if results.empty?
    end

    if params[:max_price].present?
      results = results.where("price <= ?", params[:max_price])
    end

    results
  end

  def self.get_search_items(params)
    results = if params[:purchased].present? && params[:user_id].present? && (user = User.find_by(id: params[:user_id]))
                user.purchased_items
              elsif params[:categories].present? && params[:search_term].present?
                Item.search(params[:search_term], params[:categories])
              elsif params[:categories].present?
                Item.search(nil, params[:categories])
              elsif params[:search_term].present?
                Item.search(params[:search_term], Category.all.map(&:name))
              else
                Item.all
              end

    if params[:seller].present?
      seller = User.find_by(username: params[:seller])
      results = seller ? results.where("items.user_id = ?", seller.id) : []
      return results if results.empty?
    end

    if params[:min_price].present?
      results = results.where("price >= ?", params[:min_price])
      return results if results.empty?
    end

    if params[:max_price].present?
      results = results.where("price <= ?", params[:max_price])
    end

    results
  end

  def self.insert_item(user, item_to_insert)
    if item_to_insert[:dimension_units].blank?
      item_to_insert[:dimension_units] = nil
    end
    if item_to_insert[:weight_units].blank?
      item_to_insert[:weight_units] = nil
    end
    item = user.items.create!(
      title: item_to_insert[:title],
      description: item_to_insert[:description],
      price: item_to_insert[:price],
      length: item_to_insert[:length],
      width: item_to_insert[:width],
      height: item_to_insert[:height],
      dimension_units: item_to_insert[:dimension_units],
      weight: item_to_insert[:weight],
      weight_units: item_to_insert[:weight_units],
      condition: item_to_insert[:condition]
    )
    item_to_insert[:images].each do |uploaded_image|
      next unless uploaded_image.respond_to?(:tempfile)
      image_file_path = uploaded_image.tempfile.path
      image = MiniMagick::Image.new(image_file_path)
      image.resize('256x256')
      image_type, image_data = Image.get_image_data(image_file_path)
      item.images.create!(data: image_data, image_type: image_type)
    end
    item_to_insert[:category_ids].each do |category_id|
      unless category_id.blank?
        item.categories << Category.find(category_id)
      end
    end
    item
  end

  def update_item(item_to_update)

    # Check that there are still less than 5 images
    if item_to_update[:images].present? && item_to_update[:images].length + self.images.length - item_to_update[:remove_images].length > 5
      return false
    end

    # Only update attributes that are present
    if item_to_update[:dimension_units].blank?
      item_to_update[:dimension_units] = nil
    end
    if item_to_update[:weight_units].blank?
      item_to_update[:weight_units] = nil
    end
    # Update item attributes
    if self.update!(
      title: item_to_update[:title],
      description: item_to_update[:description],
      price: item_to_update[:price],
      length: item_to_update[:length],
      width: item_to_update[:width],
      height: item_to_update[:height],
      dimension_units: item_to_update[:dimension_units],
      weight: item_to_update[:weight],
      weight_units: item_to_update[:weight_units],
      condition: item_to_update[:condition]
    )

      # Update categories
      self.categories = Category.where(id: item_to_update[:category_ids].reject(&:blank?))

      # Adding new images if the user uploaded more
      if item_to_update[:images].present?
        # Handle images
        item_to_update[:images].each do |uploaded_image|
          next unless uploaded_image.respond_to?(:tempfile)
          image_file_path = uploaded_image.tempfile.path
          image = MiniMagick::Image.new(image_file_path)
          image.resize('256x256')
          image_type, image_data = Image.get_image_data(image_file_path)
          self.images.create!(data: image_data, image_type: image_type)
        end
      end

      # Removing images if the user selected to remove any
      if item_to_update[:remove_images].present?
        # reverse the keys of the hash since we want to remove the images from last to first to be able to use the index
        item_to_update[:remove_images] = item_to_update[:remove_images].select { |_, value| value == "1" }.keys.map(&:to_i).sort.reverse

        # remove the images from the item
        item_to_update[:remove_images].each do |index|
          if index >= 0 && index < self.images.length
            self.images.destroy(self.images[index])
          end
        end
      end
      true
    else
      false
    end
  end

  def find_related_items
    # Fetch other items in the same category
    Item.joins(:categories).where(categories: { id: self.categories.pluck(:id) }).where.not(id: self.id).limit(4)
  end

  # Returns true if the item has been purchased
  def purchased?
    purchase.present?
  end

  def dimensions
    "#{length} x #{width} x #{height} #{dimension_units}"
  end

  def condition_text
    Item.conditions[condition]
  end

  private

  def round_dimensions
    self.length = length.round(1) if length
    self.width = width.round(1) if width
    self.height = height.round(1) if height
    self.weight = weight.round(1) if weight
  end
end
