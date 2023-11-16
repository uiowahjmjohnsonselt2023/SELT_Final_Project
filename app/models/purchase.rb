class Purchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :item

  validates :item_id, presence: true
  validates :user_id, presence: true

end
