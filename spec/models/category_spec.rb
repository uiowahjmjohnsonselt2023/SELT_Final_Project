require 'spec_helper'
require 'rails_helper'

describe Category, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many(:items).join_table('items_categories') }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }
  end
end
