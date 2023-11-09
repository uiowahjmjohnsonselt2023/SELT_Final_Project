
class Item < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :images, dependent: :destroy
  has_and_belongs_to_many :categories, join_table: :items_categories

  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 1000 }

  def self.search(search_term)
    if search_term
      where('title LIKE :search_term OR description LIKE :search_term', search_term: "%#{search_term}%")
    else
      all
    end
  end

end
