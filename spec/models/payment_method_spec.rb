require 'spec_helper'
require 'rails_helper'

describe PaymentMethod, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:encrypted_card_number) }
    it { should validate_presence_of(:encrypted_card_number_iv) }
    it { should validate_presence_of(:expiration_date) }
    it { should validate_presence_of(:user_id) }
  end
end
