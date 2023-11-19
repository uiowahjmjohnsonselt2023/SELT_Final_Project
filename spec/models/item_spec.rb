require 'spec_helper'
require 'rails_helper'

describe Item, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:images).dependent(:destroy) }
    it { should have_and_belong_to_many(:categories).join_table('items_categories') }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:user_id) }

    it { should validate_length_of(:title).is_at_most(255) }
    it { should validate_length_of(:description).is_at_most(1000) }
    it { should validate_numericality_of(:price).is_greater_than(0).is_less_than(1000000) }
  end

  describe 'Item.search' do
    before(:all) do
      # Create users
      user = User.create!(username: 'testuser', email: 'test@example.com')

      # Create categories
      @category1 = Category.create!(name: 'Electronics')
      @category2 = Category.create!(name: 'Books')
      @category3 = Category.create!(name: 'Games')
      @category4 = Category.create!(name: 'Clothing')
      @category5 = Category.create!(name: 'Random')

      # Create items
      @item1 = user.items.create!(title: 'Laptop', description: 'A high-performance laptop that you can play games on.', price: 1000)
      @item2 = user.items.create!(title: 'Book', description: 'A book on Ruby programming.', price: 20)
      @item3 = user.items.create!(title: 'Games', description: 'A fun game.', price: 50)
      @item4 = user.items.create!(title: 'Shirt', description: 'A nice shirt.', price: 30)

      # Associate items with categories
      @item1.categories << @category1
      @item2.categories << @category2
      @item3.categories << @category3
      @item4.categories << @category4
    end

    after(:all) do
      # Clean up any created data
      User.delete_all
      Category.delete_all
      Item.delete_all
    end

    context 'when no search term or categories are provided' do
      it 'should return all items in random order' do
        expect(Item.search(nil, nil)).to match_array([@item1, @item2, @item3, @item4])
      end
    end

    context 'when only categories are provided' do
      it 'should return items matching the categories in order of number of matching categories' do
        expect(Item.search(nil, %w[Electronics])).to match_array([@item1])
        expect(Item.search(nil, %w[Games])).to match_array([@item3])
        expect(Item.search(nil, %w[Books Clothing])).to match_array([@item2, @item4])
        expect(Item.search(nil, %w[Electronics Books Games Clothing])).to match_array([@item1, @item2, @item3, @item4])
        expect(Item.search(nil, %w[Random])).to match_array([])
      end
    end

    context 'when only a search term is provided' do
      it 'should return items matching the search term in order of relevance' do
        expect(Item.search('laptop', nil)).to match_array([@item1])
        expect(Item.search('game', nil)).to match_array([@item1, @item3])
        expect(Item.search('', nil)).to match_array([@item1, @item2, @item3, @item4])
      end
    end

    context 'when both a search term and categories are provided' do
      it 'should return items matching the categories and search term in order of number of matching categories and then relevance' do
        expect(Item.search('laptop', %w[Electronics])).to match_array([@item1])
        expect(Item.search('game', %w[Electronics])).to match_array([@item1])
        expect(Item.search('game', %w[Electronics Books])).to match_array([@item1])
        expect(Item.search('game', %w[Electronics Books Games])).to match_array([@item1, @item3])
        expect(Item.search('game', %w[Electronics Books Games Clothing])).to match_array([@item1, @item3])
        expect(Item.search('A', %w[Electronics Books Games Clothing])).to match_array([@item1, @item2, @item3, @item4])
        expect(Item.search('game', %w[Random])).to match_array([])
      end
    end
  end

  describe 'Item.insert_item' do
    let(:current_user) {
      User.create!(
        username: 'current_user',
        email: 'current_user@gmail.com'
      )
    }
    let(:title) { 'Sample Item' }
    let(:description) { 'Sample Description' }
    let(:price) { 100 }
    let(:image) { MiniMagick::Image.open('spec/support/fixtures/test_image.png') }
    let(:category) { Category.create!(name: 'Electronics') }
    let(:category_ids) { [category.id] }

    before do
      allow(User).to receive(:find_by_session_token).and_return(current_user)
    end

    it 'creates an item with correct attributes' do
      item = Item.insert_item(current_user, title, description, price, category_ids, [image])
      expect(item).to be_persisted
      expect(item.title).to eq(title)
      expect(item.description).to eq(description)
      expect(item.price).to eq(price)
    end

    it 'attaches images to the item' do
      item = Item.insert_item(current_user, title, description, price, category_ids, [image])
      expect(item.images).not_to be_empty
    end

    it 'assigns categories to the item' do
      item = Item.insert_item(current_user, title, description, price, category_ids, [image])
      expect(item.categories).to include(category)
    end
  end

  describe '#find_related_items' do
    let(:user) {
      User.create!(
        username: 'current_user',
        email: 'current_user_email@test.com',
      )
    }
    let(:search_item) {
      user.items.create!(title: "Item 1", description: "Description for item 1", price: 1.00)
    }

    let(:other_items) {
      [
        user.items.create!(title: "Item 2", description: "Description for item 2", price: 2.00),
        user.items.create!(title: "Item 3", description: "Description for item 3", price: 3.00),
        user.items.create!(title: "Item 4", description: "Description for item 4", price: 4.00),
        user.items.create!(title: "Item 5", description: "Description for item 5", price: 5.00),
        user.items.create!(title: "Item 6", description: "Description for item 6", price: 6.00),
      ]
    }
    it 'should return other items by the same user' do
      expect(search_item.find_related_items).to match_array(other_items[0..3])
    end
  end
end
