# app/models/image.rb
class Image < ApplicationRecord
  # Associations
  belongs_to :item

  # Validations
  validates :data, presence: true
  validates :item_id, presence: true

  def data_uri
    "data:image/jpg;base64,#{Base64.encode64(data).gsub("\n", '')}".html_safe
  end
end
