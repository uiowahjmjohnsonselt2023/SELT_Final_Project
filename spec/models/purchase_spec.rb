require 'rails_helper'

RSpec.describe Purchase, type: :model do


  let(:purchase) { Purchase.new }



  describe 'reviewed' do
    it 'should return true if the purchase has been reviewed' do
      purchase.review = Review.new
      expect(purchase.reviewed?).to eq(true)
    end
  end
end
