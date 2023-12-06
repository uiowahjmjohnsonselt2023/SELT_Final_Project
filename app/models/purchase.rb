class Purchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  belongs_to :address
  belongs_to :payment_method
  has_one :review

  validates :item_id, presence: true
  validates :user_id, presence: true
  # Add validations for address_id and payment_method_id if required:
  validates :address_id, presence: true
  validates :payment_method_id, presence: true

  def reviewed?
    review.present?
  end

end
