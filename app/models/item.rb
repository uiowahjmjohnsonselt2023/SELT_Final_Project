
class Item < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :images, dependent: :destroy

  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :tags, length: { maximum: 255 }

  before_save :downcase_tags

  def self.search(search_term)
    if search_term
      where('title LIKE :search_term OR description LIKE :search_term', search_term: "%#{search_term}%")
    else
      all
    end
  end

  private

  def downcase_tags
    self.tags = tags.downcase if tags.present?
  end
end
