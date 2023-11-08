
class Item < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1000 }

  def self.search(search_term)
    if search_term
      where('title LIKE :search_term OR description LIKE :search_term', search_term: "%#{search_term}%")
    else
      all
    end
  end
end
