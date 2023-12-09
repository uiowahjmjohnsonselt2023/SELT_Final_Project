require 'spec_helper'
require 'rails_helper'

describe Faq, type: :model do
  let(:validator) { Validator.new }

  describe '#valid_address_input?' do
    context 'with valid inputs' do
      it 'returns true' do
        expect(validator.valid_address_input?('123 Main St', 'Apt 4', 'Cityville', 'Stateville', 'Countryland', '12345')).to be true
      end

      it 'returns true' do
        expect(validator.valid_address_input?('121 Main St', 'Apt 4', 'Cityville', 'State ville', 'Countryland', '12345')).to be true
      end
    end

    context 'with invalid inputs' do
      it 'returns false' do
        expect(validator.valid_address_input?(nil, 'Apt 4', 'Cityville', 'Stateville', 'Countryland', '12345')).to be false
      end

      it 'returns true' do
        expect(validator.valid_address_input?('123 Main St', nil, 'Cityville', 'Stateville', 'Countryland', '12345')).to be true
      end

      it 'returns false' do
        expect(validator.valid_address_input?('123 Main St', 'Apt 4', nil, 'Stateville', 'Countryland', '12345')).to be false
      end

      it 'returns true' do
        expect(validator.valid_address_input?('123 Main St', 'Apt 4', 'Cityville', nil, 'Countryland', '12345')).to be true
      end

      it 'returns false' do
        expect(validator.valid_address_input?('123 Main St', 'Apt 4', 'Cityville', 'Stateville', nil, '12345')).to be false
      end

      it 'returns false' do
        expect(validator.valid_address_input?('123 Main St', 'Apt 4', 'Cityville', 'Stateville', 'Countryland', nil)).to be false
      end
    end
  end






end
