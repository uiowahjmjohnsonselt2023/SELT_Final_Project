require 'spec_helper'
require 'rails_helper'

describe PaymentMethod, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:encrypted_card_number) }
    it { should validate_presence_of(:expiration_date) }
    it { should validate_presence_of(:user_id) }
  end

  describe '#valid_payment_method_input?' do
    let(:payment_method) { PaymentMethod.new }

    context 'when card number is invalid' do
      it 'returns false' do
        expect(payment_method.valid_payment_method_input?('123', '01/2020')).to eq(false)
      end
    end

    context 'when card number is valid' do
      it 'returns true' do
        expect(payment_method.valid_payment_method_input?('1234567890123456', '01/2020')).to eq(true)
      end
    end

    context 'Spaces in a valid number' do
      it 'returns true' do
        expect(payment_method.valid_payment_method_input?('1234 5678 9012 3456', '01/2020')).to eq(true)
      end
    end

    context 'when expiration date is invalid' do
      it 'returns false' do
        expect(payment_method.valid_payment_method_input?('1234567890123456', '01/20')).to eq(false)
      end
    end

    context 'when expiration date is valid' do
      it 'returns true' do
        expect(payment_method.valid_payment_method_input?('1234567890123456', '01/2020')).to eq(true)
      end
    end
  end
end
