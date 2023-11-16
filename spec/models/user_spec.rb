require 'spec_helper'
require 'rails_helper'

describe User, type: :model do
  describe 'associations' do
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:addresses).dependent(:destroy) }
    it { should have_many(:payment_methods).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_length_of(:username).is_at_most(50) }

    it { should validate_presence_of(:password_digest) }

    it { should validate_presence_of(:email) }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }

    it { should validate_presence_of(:phone_number) }
    it { should validate_numericality_of(:phone_number) }
    it { should validate_length_of(:phone_number).is_at_least(10).is_at_most(15) }
  end

  describe 'callbacks' do
    it 'converts username to lowercase before saving' do
      user = User.new(username: 'TestUser', email: 'test@example.com', password: 'password', phone_number: '1234567890')
      user.save
      expect(user.username).to eq('testuser')
    end
  end

  describe 'uniqueness' do
    let!(:user) { User.create!(username: 'existinguser', email: 'test@example.com', password: 'password', phone_number: '1234567890') }

    it 'is expected to validate that :username is case-insensitively unique' do
      new_user = User.new(username: user.username.upcase)
      new_user.valid?
      expect(new_user.errors[:username]).to include('has already been taken')
    end

    it 'is expected to validate that :email is case-sensitively unique' do
      new_user = User.new(email: user.email)
      new_user.valid?
      expect(new_user.errors[:email]).to include('has already been taken')
    end
  end

  describe 'bookmarked method' do
    let!(:user) { User.create!(username: 'existinguser', email: 'test@example.com', password: 'password', phone_number: '1234567890') }
    let!(:item) { Item.create!(title: 'Test Item', description: 'Test Description', price: 10.00, user_id: user.id) }

    it 'returns false if item is not bookmarked' do
      expect(user.bookmarked(item)).to eq(false)
    end
    it 'returns true if item is bookmarked' do
      user.bookmarked_items << item
      expect(user.bookmarked(item)).to eq(true)
    end
    it 'returns false if item is removed from bookmarks' do
      user.bookmarked_items << item
      user.bookmarked_items.delete(item)
      expect(user.bookmarked(item)).to eq(false)
    end
  end
end
