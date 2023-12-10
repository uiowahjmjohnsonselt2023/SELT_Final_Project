require 'spec_helper'
require 'rails_helper'

describe User, type: :model do
  describe 'associations' do
    it { should have_many(:items).dependent(:delete_all) }
    it { should have_many(:addresses).dependent(:delete_all) }
    it { should have_many(:payment_methods).dependent(:delete_all) }
    it { should have_many(:bookmarks).dependent(:delete_all) }
    it { should have_many(:bookmarked_items).through(:bookmarks).source(:item).dependent(:delete_all) }
  end

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_length_of(:username).is_at_most(50) }

    it { should validate_presence_of(:email) }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
  end

  describe 'callbacks' do
    it 'converts username to lowercase before saving' do
      user = User.new(username: 'TestUser', email: 'test@example.com')
      user.save
      expect(user.username).to eq('testuser')
    end
  end

  describe 'uniqueness' do
    let!(:user) { User.create!(username: 'existinguser', email: 'test@example.com') }

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

  describe 'bookmarked' do
    let(:user) { User.create!(username: 'testuser', email: 'testemail@gmail.com') }
    let(:item) { instance_double('Item') }

    context 'when item is bookmarked' do
      before do
        allow(user).to receive(:bookmarked_items).and_return([item])
      end

      it 'returns true' do
        expect(user.bookmarked(item)).to eq(true)
      end
    end

    context 'when item is not bookmarked' do
      before do
        allow(user).to receive(:bookmarked_items).and_return([])
      end

      it 'returns false' do
        expect(user.bookmarked(item)).to eq(false)
      end
    end
  end

  describe 'add_bookmark' do
    let(:user) { User.create!(username: 'testuser', email: 'testemail@gmail.com') }
    let(:item) { instance_double('Item') }
    context 'when item is not bookmarked' do
      before do
        allow(user).to receive(:bookmarked_items).and_return([])
      end
      it 'adds item to bookmarked_items' do
        allow(Item).to receive(:find_by).and_return(item)
        expect(user.bookmarked_items).to receive(:<<).with(item)
        user.add_bookmark(item)
      end
    end

    context 'when item is already bookmarked' do
      before do
        allow(user).to receive(:bookmarked_items).and_return([item])
      end
      it 'does not add item to bookmarked_items' do
        allow(Item).to receive(:find_by).and_return(item)
        expect(user.bookmarked_items).not_to receive(:<<).with(item)
        user.add_bookmark(item)
      end
    end
  end

  describe 'remove_bookmark' do
    let(:user) { User.create!(username: 'testuser', email: 'testemail@gmail.com') }
    let(:item) { instance_double('Item') }
    context 'when item is bookmarked' do
      before do
        allow(user).to receive(:bookmarked_items).and_return([item])
      end
      it 'removes item from bookmarked_items' do
        allow(Item).to receive(:find_by).and_return(item)
        expect(user.bookmarked_items).to receive(:delete).with(item)
        user.remove_bookmark(item)
      end
    end

    context 'when item is not bookmarked' do
      before do
        allow(user).to receive(:bookmarked_items).and_return([])
      end
      it 'does not remove item from bookmarked_items' do
        allow(Item).to receive(:find_by)
        expect(user.bookmarked_items).not_to receive(:delete).with(item)
        user.remove_bookmark(item)
      end
      it 'returns false' do
        allow(Item).to receive(:find_by)
        expect(user.remove_bookmark(item)).to eq(false)
      end
    end
  end

  describe 'purchase_item' do
    let(:user) { User.create!(username: 'testuser', email: 'user@gmail.com') }
    let(:item) { instance_double('Item') }
    let(:address) { instance_double('Address', id: 1)  }
    let(:payment_method) { instance_double('PaymentMethod', id: 1) }
    let(:purchase) { instance_double('Purchase') }

    context 'when item is not found' do
      it 'returns an error message' do
        result = user.purchase_item(nil, address.id, payment_method.id)
        expect(result).to eq({ success: false, message: 'Item not found.' })
      end
    end

    context 'when item has already been purchased' do
      before do
        allow(item).to receive(:purchase).and_return(true)
      end
      it 'returns an error message' do
        result = user.purchase_item(item, address.id, payment_method.id)
        expect(result).to eq({ success: false, message: 'This item has already been purchased.' })
      end
    end

    context 'when purchase is successful' do
      before do
        allow(item).to receive(:purchase).and_return(false)
        allow(user.purchases).to receive(:create).and_return(purchase)
        allow(purchase).to receive(:persisted?).and_return(true)
      end
      it 'adds item to purchased_items' do
        result = user.purchase_item(item, address.id, payment_method.id)
        expect(result).to eq({ success: true, message: 'Purchase successful!' })
      end
    end

    context 'when purchase is unsuccessful' do
      before do
        allow(item).to receive(:purchase).and_return(false)
        allow(user.purchases).to receive(:create).and_return(purchase)
        allow(purchase).to receive(:persisted?).and_return(false)
        allow(purchase).to receive_message_chain(:errors, :full_messages).and_return(['error'])
      end
      it 'returns an error message' do
        # Here, set up a scenario where purchase would fail. For example, an invalid address_id
        result = user.purchase_item(item, nil, payment_method.id)
        expect(result[:success]).to be false
        expect(result[:message]).to include("Purchase Unsuccessful!")
      end
    end
  end




end
