# app/models/image.rb
class Image < ApplicationRecord
  # Associations
  belongs_to :item

  # Validations
  validates :data, presence: true
end
