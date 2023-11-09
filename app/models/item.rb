
class Item < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :images, dependent: :destroy
  has_and_belongs_to_many :categories, join_table: :items_categories

  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 1000 }

  def self.search(search_term, category_names)
    items = all

    # Scenario 1: No search term or categories, return all items in random order
    return items.order('RANDOM()') if search_term.blank? && category_names.blank?

    # Scenario 2: Categories provided, sort by number of matching categories
    if category_names.present?
      category_ids = Category.where(name: category_names).pluck(:id)
      items = items.joins(:categories).where(categories: { id: category_ids })
      items = items.group('items.id').order('COUNT(categories.id) DESC')
    end

    # Scenario 3: Search term provided, sort by number of matches in title/description
    if search_term.present? && category_names.blank?
      items = items.select("items.*, (LENGTH(title) - LENGTH(REPLACE(LOWER(title), LOWER(?), '')))/LENGTH(?) AS title_matches", search_term, search_term)
                   .select("items.*, (LENGTH(description) - LENGTH(REPLACE(LOWER(description), LOWER(?), '')))/LENGTH(?) AS description_matches", search_term, search_term)
                   .order('title_matches DESC, description_matches DESC')
    end

    # Scenario 4: Both search term and categories provided, sort by category match count and then search term match
    if search_term.present? && category_names.present?
      items = items.select("items.*, (LENGTH(title) - LENGTH(REPLACE(LOWER(title), LOWER(?), '')))/LENGTH(?) AS title_matches", search_term, search_term)
                   .select("items.*, (LENGTH(description) - LENGTH(REPLACE(LOWER(description), LOWER(?), '')))/LENGTH(?) AS description_matches", search_term, search_term)
                   .group('items.id')
                   .order('COUNT(categories.id) DESC, title_matches DESC, description_matches DESC')
    end

    items
  end

end
