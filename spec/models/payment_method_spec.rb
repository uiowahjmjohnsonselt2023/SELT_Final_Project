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

    context 'when saving a valid payment method' do

      it 'Payment Method is valid' do
        expect(payment_method.valid_payment_method_input?('1234567890123456', '01/2020')).to eq(true)
        payment_method = PaymentMethod.create!(card_number: '1234567890123456', expiration_date: '01/2020', user_id: "1")
        expect(payment_method.save).to be true
      end
    end

    context 'when saving an invalid payment method' do
        it 'Payment Method is invalid' do
          payment_method = PaymentMethod.create(card_number: '123789456', expiration_date: '01/2020', user_id: "1")
          expect(payment_method.save).to be false
        end
    end
  end

  describe 'last_four_digits' do
    let(:payment_method) { PaymentMethod.create!(card_number: '1234567890123456', expiration_date: '01/2020', user_id: "1") }
    it 'returns last four digits of card number' do
      expect(payment_method.last_four_digits).to eq('3456')
    end
  end

end
