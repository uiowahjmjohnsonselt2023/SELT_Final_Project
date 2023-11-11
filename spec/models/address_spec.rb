require 'spec_helper'
require 'rails_helper'

describe Address, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:shipping_address_1) }
    it { should validate_presence_of(:shipping_address_2) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:postal_code) }
    it { should validate_presence_of(:user_id) }

    it { should validate_numericality_of(:postal_code) }

    it { should validate_length_of(:postal_code).is_at_most(10) }
  end
end
