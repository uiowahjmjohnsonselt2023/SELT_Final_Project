# app/models/image.rb
class Image < ApplicationRecord
  # Associations
  belongs_to :item

  # Validations
  validates :data, presence: true
  validates :image_type, presence: true
  validates :item_id, presence: true


  def get_image_data(image_file_path)
    image_type = File.extname(image_file_path).delete('.')
    image_data = File.open(image_file_path, 'rb') { |file| file.read }
    [image_type, image_data]
  end

  def data_uri
    "data:image/#{image_type};base64,#{Base64.encode64(data).gsub("\n", '')}".html_safe
  end
end
