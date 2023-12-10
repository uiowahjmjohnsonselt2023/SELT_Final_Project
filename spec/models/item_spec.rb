require 'spec_helper'
require 'rails_helper'

describe Item, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:images).dependent(:delete_all) }
    it { should have_and_belong_to_many(:categories).join_table('items_categories') }
    it { should have_many(:bookmarks).dependent(:delete_all) }
    it { should have_one(:purchase).dependent(:delete) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:condition) }

    it { should validate_length_of(:title).is_at_most(255) }
    it { should validate_length_of(:description).is_at_most(1000) }

    it { should validate_numericality_of(:price).is_greater_than(0).is_less_than(1000000) }
    it { should validate_numericality_of(:length).is_greater_than(0).is_less_than(1000000).allow_nil }
    it { should validate_numericality_of(:width).is_greater_than(0).is_less_than(1000000).allow_nil }
    it { should validate_numericality_of(:height).is_greater_than(0).is_less_than(1000000).allow_nil }
    it { should validate_numericality_of(:weight).is_greater_than(0).is_less_than(1000000).allow_nil }

    it { should validate_inclusion_of(:dimension_units).in_array(%w[in ft cm m]).allow_nil }
    it { should validate_inclusion_of(:weight_units).in_array(%w[oz lbs g kg]).allow_nil }
    it { should validate_inclusion_of(:condition).in_range(0..4) }

  end

  describe 'Item.dimension_units' do
    it 'should return the correct dimension units' do
      expect(Item.dimension_units).to match_array(%w[in ft cm m])
    end
  end

  describe 'Item.weight_units' do
    it 'should return the correct weight units' do
      expect(Item.weight_units).to match_array(%w[oz lbs g kg])
    end
  end

  describe 'Item.conditions' do
    it 'should return the correct conditions' do
      expect(Item.conditions).to match_array([
                                               'New',
                                               'Like New',
                                               'Used',
                                               'Well Used',
                                               'Poor'
                                             ])
    end
  end

  describe 'Item.search' do
    before(:all) do
      user = User.create!(username: 'testuser', email: 'test@example.com')

      # Create categories
      @category1 = Category.create!(name: 'Electronics')
      @category2 = Category.create!(name: 'Books')
      @category3 = Category.create!(name: 'Games')
      @category4 = Category.create!(name: 'Clothing')
      @category5 = Category.create!(name: 'Random')

      # Create items
      @item1 = user.items.create!(
        title: 'Laptop',
        description: 'A high-performance laptop that you can play games on.',
        price: 1000,
        width: 10, length: 10, height: 10, dimension_units: 'in',
        weight: 10, weight_units: 'oz',
        condition: 0
      )
      @item2 = user.items.create!(
        title: 'Book',
        description: 'A book on Ruby programming.',
        price: 20,
        width: 10, length: 10, height: 10, dimension_units: 'in',
        weight: 10, weight_units: 'oz',
        condition: 0
      )
      @item3 = user.items.create!(
        title: 'Games',
        description: 'A fun game.',
        price: 50,
        width: 10, length: 10, height: 10, dimension_units: 'in',
        weight: 10, weight_units: 'oz',
        condition: 0
      )
      @item4 = user.items.create!(
        title: 'Shirt',
        description: 'A nice shirt.',
        price: 30,
        width: 10, length: 10, height: 10, dimension_units: 'in',
        weight: 10, weight_units: 'oz',
        condition: 0
      )

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

  describe 'Item.get_users_search_items' do
    let(:current_user) { instance_double('User', id: 1) }
    let(:other_user2) { instance_double('User', id: 2, username: 'other_user2') }
    let(:other_user3) { instance_double('User', id: 3, username: 'other_user3') }

    context 'when bookmarks are requested' do
      let(:item1) { instance_double('Item', id: 1) }
      let(:item2) { instance_double('Item', id: 2) }
      let(:current_user_bookmarked_items) { [item1, item2] }

      context 'when current user is not provided' do
        it 'returns an empty array' do
          params = { bookmarks: '1' }
          expect(Item.get_users_search_items(nil, params)).to eq([])
        end
      end
      context 'when no bookmarks are present' do
        before do
          allow(current_user).to receive(:bookmarked_items).and_return([])
        end
        it 'returns an empty array' do
          params = { bookmarks: '1' }
          expect(described_class.get_users_search_items(current_user, params)).to eq([])
        end
      end
      context 'when bookmarks are present' do
        before do
          allow(current_user).to receive(:bookmarked_items).and_return(current_user_bookmarked_items)
        end
        it 'returns bookmarked items for the current user' do
          params = { bookmarks: '1' }
          expect(Item.get_users_search_items(current_user, params)).to eq(current_user_bookmarked_items)
        end
      end
    end

    context 'when purchased items are requested' do
      let(:item1) { instance_double('Item', id: 1) }
      let(:item2) { instance_double('Item', id: 2) }
      let(:current_user_purchased_items) { [item1, item2] }

      context 'when current user is not provided' do
        it 'returns an empty array' do
          params = { purchased: '1' }
          expect(Item.get_users_search_items(nil, params)).to eq([])
        end
      end
      context 'when no purchased items are present' do
        before do
          allow(current_user).to receive(:purchased_items).and_return([])
        end
        it 'returns an empty array' do
          params = { purchased: '1' }
          expect(described_class.get_users_search_items(current_user, params)).to eq([])
        end
      end
      context 'when purchased items are present' do
        before do
          allow(current_user).to receive(:purchased_items).and_return(current_user_purchased_items)
        end
        it 'returns purchased items for the current user' do
          params = { purchased: '1' }
          expect(Item.get_users_search_items(current_user, params)).to eq(current_user_purchased_items)
        end
      end
    end

    context 'when categories or search term are provided' do
      let(:item1) { instance_double('Item', id: 1) }
      let(:item2) { instance_double('Item', id: 2) }
      let(:item3) { instance_double('Item', id: 3) }
      let(:item4) { instance_double('Item', id: 4) }
      let(:return_items) { [item1, item2, item3, item4] }
      it 'returns items matching the categories and search term' do
        params = { categories: %w[Electronics], search_term: 'laptop' }
        expect(Item).to receive(:search).with('laptop', %w[Electronics]).and_return(return_items)
        expect(Item.get_users_search_items(current_user, params)).to eq(return_items)
      end
    end

    context 'when categories are provided' do
      let(:item1) { instance_double('Item', id: 1) }
      let(:item2) { instance_double('Item', id: 2) }
      let(:item3) { instance_double('Item', id: 3) }
      let(:item4) { instance_double('Item', id: 4) }
      let(:return_items) { [item1, item2, item3, item4] }
      it 'returns items matching the categories' do
        params = { categories: %w[Electronics] }
        expect(Item).to receive(:search).with(nil, %w[Electronics]).and_return(return_items)
        expect(Item.get_users_search_items(current_user, params)).to eq(return_items)
      end
    end

    context 'when a search term is provided' do
      let(:item1) { instance_double('Item', id: 1) }
      let(:item2) { instance_double('Item', id: 2) }
      let(:item3) { instance_double('Item', id: 3) }
      let(:item4) { instance_double('Item', id: 4) }
      let(:return_items) { [item1, item2, item3, item4] }
      it 'returns items matching the search term' do
        params = { search_term: 'laptop' }
        expect(Item).to receive(:search).with('laptop', Category.all.map(&:name)).and_return(return_items)
        expect(Item.get_users_search_items(current_user, params)).to eq(return_items)
      end
    end

    context 'when search term, categories, bookmarked, and purchased are not filled' do
      let(:item1) { instance_double('Item', id: 1) }
      let(:item2) { instance_double('Item', id: 2) }
      let(:item3) { instance_double('Item', id: 3) }
      let(:item4) { instance_double('Item', id: 4) }
      let(:return_items) { [item1, item2, item3, item4] }
      it 'returns all items' do
        params = {}
        expect(Item).to receive(:all).and_return(return_items)
        expect(Item.get_users_search_items(current_user, params)).to eq(return_items)
      end
    end

    context 'when a seller is provided' do
      let(:item1) { instance_double('Item', id: 1, user_id: 2) }
      let(:item2) { instance_double('Item', id: 2, user_id: 2) }
      let(:return_items) { [item1, item2] }

      before do
        allow(Item).to receive(:all).and_return(return_items)
      end

      context 'when the seller is not found' do
        before do
          allow(User).to receive(:find_by).with(username: 'testuser').and_return(nil)
        end
        it 'returns an empty array' do
          params = { seller: 'testuser' }
          expect(Item.get_users_search_items(current_user, params)).to eq([])
        end
      end

      context 'when the seller is found but does not have items' do
        before do
          allow(User).to receive(:find_by).with(username: 'other_user3').and_return(other_user3)
          allow(return_items).to receive(:where).and_return([])
        end
        it 'returns an empty array' do
          params = { seller: 'other_user3' }
          expect(Item.get_users_search_items(current_user, params)).to eq([])
        end
      end

      context 'when the seller is found and has items' do
        before do
          allow(User).to receive(:find_by).with(username: 'other_user2').and_return(other_user2)
          allow(return_items).to receive(:where).and_return(return_items)
        end
        it 'returns items for the seller' do
          params = { seller: 'other_user2' }
          expect(Item.get_users_search_items(current_user, params)).to eq(return_items)
        end
      end
    end

    context 'when seller, min_price, and max_price are provided' do
      let(:item1) { instance_double('Item', id: 1, price: 10) }
      let(:item2) { instance_double('Item', id: 2, price: 20) }
      let(:item3) { instance_double('Item', id: 3, price: 30) }
      let(:item4) { instance_double('Item', id: 4, price: 40) }
      let(:return_items) { [item1, item2, item3, item4] }

      before do
        allow(Item).to receive(:all).and_return(return_items)
        allow(User).to receive(:find_by).with(username: 'other_user2').and_return(other_user2)
      end

      context 'when seller has no items' do
        before do
          allow(return_items).to receive(:where).and_return([])
        end
        it 'returns an empty array' do
          expect(Item.get_users_search_items(current_user, { seller: 'other_user2', min_price: 10, max_price: 20 })).to eq([])
        end
      end

      context 'when seller has items' do
        before do
          allow(return_items).to receive(:where).with("items.user_id = ?", 2).and_return(return_items)
          allow(return_items).to receive(:where).with("price >= ?", 10).and_return(return_items)
          allow(return_items).to receive(:where).with("price <= ?", 20).and_return([item1, item2])
          allow(return_items).to receive(:where).with("price <= ?", 30).and_return([item1, item2, item3])
        end
        it 'returns items for the seller' do
          expect(Item.get_users_search_items(current_user, { seller: 'other_user2', min_price: 10, max_price: 20 })).to eq([item1, item2])
        end
        it 'returns items for the seller' do
          expect(Item.get_users_search_items(current_user, { seller: 'other_user2', min_price: 10, max_price: 30 })).to eq([item1, item2, item3])
        end
      end
    end
  end

  describe 'Item.get_search_items' do
    let(:other_user2) { instance_double('User', id: 2, username: 'other_user2') }
    let(:other_user3) { instance_double('User', id: 3, username: 'other_user3') }

    let(:item1) { instance_double('Item', id: 1, price: 10) }
    let(:item2) { instance_double('Item', id: 2, price: 20) }
    let(:item3) { instance_double('Item', id: 3, price: 30) }
    let(:item4) { instance_double('Item', id: 4, price: 40) }
    let(:return_items) { [item1, item2, item3, item4] }

    context 'when categories or search term are provided' do
      it 'returns items matching the categories and search term' do
        params = { categories: %w[Electronics], search_term: 'laptop' }
        expect(Item).to receive(:search).with('laptop', %w[Electronics]).and_return(return_items)
        expect(Item.get_search_items(params)).to eq(return_items)
      end
    end

    context 'when categories are provided' do
      it 'returns items matching the categories' do
        params = { categories: %w[Electronics] }
        expect(Item).to receive(:search).with(nil, %w[Electronics]).and_return(return_items)
        expect(Item.get_search_items(params)).to eq(return_items)
      end
    end

    context 'when a search term is provided' do
      it 'returns items matching the search term' do
        params = { search_term: 'laptop' }
        expect(Item).to receive(:search).with('laptop', Category.all.map(&:name)).and_return(return_items)
        expect(Item.get_search_items(params)).to eq(return_items)
      end
    end

    context 'when search term, categories, bookmarked, and purchased are not filled' do
      it 'returns all items' do
        params = {}
        expect(Item).to receive(:all).and_return(return_items)
        expect(Item.get_search_items(params)).to eq(return_items)
      end
    end

    context 'when a seller is provided' do
      let(:item1) { instance_double('Item', id: 1, user_id: 2) }
      let(:item2) { instance_double('Item', id: 2, user_id: 2) }
      let(:return_items) { [item1, item2] }

      before do
        allow(Item).to receive(:all).and_return(return_items)
      end

      context 'when the seller is not found' do
        before do
          allow(User).to receive(:find_by).with(username: 'testuser').and_return(nil)
        end
        it 'returns an empty array' do
          params = { seller: 'testuser' }
          expect(Item.get_search_items(params)).to eq([])
        end
      end

      context 'when the seller is found but does not have items' do
        before do
          allow(User).to receive(:find_by).with(username: 'other_user3').and_return(other_user3)
          allow(return_items).to receive(:where).and_return([])
        end
        it 'returns an empty array' do
          params = { seller: 'other_user3' }
          expect(Item.get_search_items(params)).to eq([])
        end
      end

      context 'when the seller is found and has items' do
        before do
          allow(User).to receive(:find_by).with(username: 'other_user2').and_return(other_user2)
          allow(return_items).to receive(:where).and_return(return_items)
        end
        it 'returns items for the seller' do
          params = { seller: 'other_user2' }
          expect(Item.get_search_items(params)).to eq(return_items)
        end
      end
    end

    context 'when seller, min_price, and max_price are provided' do
      before do
        allow(Item).to receive(:all).and_return(return_items)
        allow(User).to receive(:find_by).with(username: 'other_user2').and_return(other_user2)
      end

      context 'when seller has no items' do
        before do
          allow(return_items).to receive(:where).and_return([])
        end
        it 'returns an empty array' do
          expect(Item.get_search_items({ seller: 'other_user2', min_price: 10, max_price: 20 })).to eq([])
        end
      end

      context 'when seller has items' do
        before do
          allow(return_items).to receive(:where).with("items.user_id = ?", 2).and_return(return_items)
          allow(return_items).to receive(:where).with("price >= ?", 10).and_return(return_items)
          allow(return_items).to receive(:where).with("price <= ?", 20).and_return([item1, item2])
          allow(return_items).to receive(:where).with("price <= ?", 30).and_return([item1, item2, item3])
        end
        it 'returns items for the seller' do
          expect(Item.get_search_items({ seller: 'other_user2', min_price: 10, max_price: 20 })).to eq([item1, item2])
        end
        it 'returns items for the seller' do
          expect(Item.get_search_items({ seller: 'other_user2', min_price: 10, max_price: 30 })).to eq([item1, item2, item3])
        end
      end
    end
  end

  describe 'Item.insert_item' do
    let(:current_user) { instance_double('User', id: 1) }
    let(:item) { instance_double('Item') }
    let(:image) { instance_double('Image') }
    let(:item_to_insert) { {
      :title => 'Title',
      :description => 'Description',
      :price => 100,
      :category_ids => [1, 2],
      :images => [image],
      :length => 10, :width => 10, :height => 10, :dimension_units => 'in',
      :weight => 10, :weight_units => 'oz',
      :condition => 0

    } }

    before do
      allow(current_user).to receive(:items).and_return(Item)
      allow(item).to receive(:add_images)
      allow(item).to receive(:add_categories)
    end

    context 'when no dimension units are selected' do
      before do
        allow(Item).to receive(:create!).and_return(item)
        item_to_insert[:dimension_units] = ""
      end
      it 'dimension units are changed' do
        Item.insert_item(current_user, item_to_insert)
        expect(Item).to have_received(:create!).with(
          title: 'Title',
          description: 'Description',
          price: 100,
          length: 10, width: 10, height: 10, dimension_units: nil,
          weight: 10, weight_units: 'oz',
          condition: 0
        )
      end

      it 'returns the correct created item' do
        expect(Item.insert_item(current_user, item_to_insert)).to eq(item)
      end
    end

    context 'when no weight units are selected' do
      before do
        allow(Item).to receive(:create!).and_return(item)
        item_to_insert[:weight_units] = ""
      end
      it 'weight units are changed' do
        Item.insert_item(current_user, item_to_insert)
        expect(Item).to have_received(:create!).with(
          title: 'Title',
          description: 'Description',
          price: 100,
          length: 10, width: 10, height: 10, dimension_units: 'in',
          weight: 10, weight_units: nil,
          condition: 0
        )
      end

      it 'returns the correct created item' do
        expect(Item.insert_item(current_user, item_to_insert)).to eq(item)
      end
    end

    context 'when all fields are filled' do
      before do
        allow(Item).to receive(:create!).and_return(item)
      end
      it 'creates the item with the correct attributes' do
        Item.insert_item(current_user, item_to_insert)
        expect(Item).to have_received(:create!).with(
          title: 'Title',
          description: 'Description',
          price: 100,
          length: 10, width: 10, height: 10, dimension_units: 'in',
          weight: 10, weight_units: 'oz',
          condition: 0
        )
      end

      it 'returns the correct created item' do
        expect(Item.insert_item(current_user, item_to_insert)).to eq(item)
      end
    end
  end

  describe 'add_images' do
    let(:item) {
      Item.create!(
        title: 'Title',
        description: 'Description',
        price: 100,
        length: 10, width: 10, height: 10, dimension_units: 'in',
        weight: 10, weight_units: 'oz',
        condition: 0,
        user_id: 1
      )
    }
    let(:uploaded_image) { instance_double('ActionDispatch::Http::UploadedFile') }
    let(:tempfile) { instance_double('Tempfile') }
    let(:mini_magick_image) { instance_double('MiniMagick::Image') }

    before do
      allow(uploaded_image).to receive(:respond_to?).with(:tempfile).and_return(true)
      allow(uploaded_image).to receive(:tempfile).and_return(tempfile)
      allow(tempfile).to receive(:path).and_return('spec/support/fixtures/test_image.png')
      allow(Image).to receive(:get_image_data).with('spec/support/fixtures/test_image.png').and_return(['image_type', 'image_data'])
      allow(item).to receive(:images).and_return(Image)
      allow(Image).to receive(:create!)
    end

    context 'when no images are provided' do
      it 'does not add any images' do
        images = []
        item.add_images(images)
        expect(item).not_to have_received(:images)
      end
    end

    context 'when images are provided' do
      it 'adds the correct number of images' do
        images = [uploaded_image]
        item.add_images(images)
        expect(item).to have_received(:images).exactly(1).times
      end
      it 'adds the correct number of images' do
        images = [uploaded_image, uploaded_image]
        item.add_images(images)
        expect(item).to have_received(:images).exactly(2).times
      end

      it 'creates the image with the correct attributes' do
        images = [uploaded_image]
        item.add_images(images)
        expect(Image).to have_received(:create!).with(
          data: 'image_data',
          image_type: 'image_type'
        )
      end
    end
  end

  describe 'add_categories' do
    let(:item) {
      Item.create!(
        title: 'Title',
        description: 'Description',
        price: 100,
        length: 10, width: 10, height: 10, dimension_units: 'in',
        weight: 10, weight_units: 'oz',
        condition: 0,
        user_id: 1,
        categories: []
      )
    }
    let(:category1) { Category.create!(name: 'Electronics') }
    let(:category2) { Category.create!(name: 'Books') }
    let(:category3) { Category.create!(name: 'Games') }
    let(:category4) { Category.create!(name: 'Clothing') }
    let(:category5) { Category.create!(name: 'Random') }

    before do
      allow(Category).to receive(:find).with(1).and_return(category1)
      allow(Category).to receive(:find).with(2).and_return(category2)
      allow(Category).to receive(:find).with(3).and_return(category3)
      allow(Category).to receive(:find).with(4).and_return(category4)
      allow(Category).to receive(:find).with(5).and_return(category5)

    end

    context 'when no categories are provided' do
      it 'does not add any categories' do
        item.add_categories([])
        expect(item.categories).to eq([])
      end
    end

    context 'when categories are provided' do
      it 'adds the correct number of categories' do
        item.add_categories([1])
        expect(item.categories.length).to eq(1)
      end
      it 'adds the correct number of categories' do
        item.add_categories([1, 2, 5])
        expect(item.categories.length).to eq(3)
      end

      it 'adds the correct categories' do
        item.add_categories([1])
        expect(item.categories).to include(category1)
      end
      it 'adds the correct categories' do
        item.add_categories([1, 5])
        expect(item.categories).to include(category1)
        expect(item.categories).to include(category5)
      end
      it 'adds the correct categories' do
        item.add_categories([1, 2, 4, 5])
        expect(item.categories).to include(category1)
        expect(item.categories).to include(category2)
        expect(item.categories).to include(category4)
        expect(item.categories).to include(category5)
      end
    end
  end

  describe 'Item.update_item' do
    let(:current_user) { instance_double('User', id: 1) }
    let(:image1) { instance_double('Image', id: 1) }
    let(:image2) { instance_double('Image', id: 2) }
    let(:image3) { instance_double('Image', id: 3) }

    let(:item) {
      Item.create!(
        title: 'Title1',
        description: 'Description1',
        price: 100,
        length: 10, width: 10, height: 10, dimension_units: 'in',
        weight: 10, weight_units: 'oz',
        condition: 0,
        user_id: 1
      )
    }

    let(:item_updates) { {
      :title => 'Title2',
      :description => 'Description2',
      :price => 200,
      :category_ids => [1, 2],
      :images => [image3],
      :length => 20, :width => 20, :height => 20, :dimension_units => 'in',
      :weight => 20, :weight_units => 'oz',
      :condition => 2
    } }

    let(:images_to_remove) { {
      '1' => '1',
      '2' => '1'
    } }

    before do
      allow(item).to receive(:add_images)
      allow(item).to receive(:add_categories)
    end

    context 'when there are too many images provided' do
      before do
        allow(item).to receive(:check_image_limit).and_return(true)
      end
      it 'returns false' do
        expect(item.update_item(item_updates, images_to_remove)).to eq(false)
      end
    end

    context 'when no dimension units are selected' do
      before do
        allow(item).to receive(:update!).and_return(true)
        allow(images_to_remove).to receive(:present?).and_return(false)
        item_updates[:dimension_units] = ""
      end
      it 'dimension units are changed and update is called with the correct parameters' do
        item.update_item(item_updates, images_to_remove)
        expect(item).to have_received(:update!).with(
          title: 'Title2',
          description: 'Description2',
          price: 200,
          length: 20, width: 20, height: 20, dimension_units: nil,
          weight: 20, weight_units: 'oz',
          condition: 2
        )
      end
    end

    context 'when no weight units are selected' do
      before do
        allow(item).to receive(:update!).and_return(true)
        allow(images_to_remove).to receive(:present?).and_return(false)
        item_updates[:weight_units] = ""
      end
      it 'weight units are changed and update is called with the correct parameters' do
        item.update_item(item_updates, images_to_remove)
        expect(item).to have_received(:update!).with(
          title: 'Title2',
          description: 'Description2',
          price: 200,
          length: 20, width: 20, height: 20, dimension_units: 'in',
          weight: 20, weight_units: nil,
          condition: 2
        )
      end
    end

    context 'when all fields are filled' do
      before do
        allow(item).to receive(:update!).and_return(true)
        allow(images_to_remove).to receive(:present?).and_return(false)
      end
      it 'update is called with the correct parameters' do
        item.update_item(item_updates, images_to_remove)
        expect(item).to have_received(:update!).with(
          title: 'Title2',
          description: 'Description2',
          price: 200,
          length: 20, width: 20, height: 20, dimension_units: 'in',
          weight: 20, weight_units: 'oz',
          condition: 2
        )
      end
    end

    context 'when invalid parameters are entered' do
      before do
        allow(item).to receive(:update!).and_return(false)
        allow(images_to_remove).to receive(:present?).and_return(false)
      end
      it 'returns false' do
        expect(item.update_item(item_updates, images_to_remove)).to eq(false)
      end
    end

    context 'when images are provided' do
      before do
        allow(item).to receive(:update!).and_return(true)
        allow(images_to_remove).to receive(:present?).and_return(false)
      end
      it 'adds the correct number of images' do
        item.update_item(item_updates, images_to_remove)
        expect(item).to have_received(:add_images).exactly(1).times
      end

      it 'adds the correct images' do
        item.update_item(item_updates, images_to_remove)
        expect(item).to have_received(:add_images).with([image3])
      end
    end

    context 'when images are provided to remove' do
      before do
        allow(item).to receive(:update!).and_return(true)
        allow(images_to_remove).to receive(:present?).and_return(true)
        allow(item).to receive(:images).and_return([image1, image2])
        allow(item.images).to receive(:destroy)
      end
      it 'removes the correct number of images' do
        item.update_item(item_updates, images_to_remove)
        expect(item.images).to have_received(:destroy).exactly(1).times
      end
    end
  end

  describe '#find_related_items' do
    let(:category) { instance_double('Category', id: 1) }
    let(:item) {
      Item.create!(
        title: 'Title1',
        description: 'Description1',
        price: 100,
        length: 10, width: 10, height: 10, dimension_units: 'in',
        weight: 10, weight_units: 'oz',
        condition: 0,
        user_id: 1
      )
    }

    let(:ids) { [1] }

    let(:related_item) { instance_double('Item', id: 2) }
    let(:unrelated_item) { instance_double('Item', id: 3) }

    before do
      allow(item).to receive(:categories).and_return(Category)
      allow(Category).to receive(:pluck).with(:id).and_return(ids)

      allow(Item).to receive(:joins).with(:categories).and_return(Item)
      allow(Item).to receive(:where).with(categories: { id: ids }).and_return(Item)

      allow(Item).to receive(:where).and_return(Item)
      allow(Item).to receive(:not).with(id: item.id).and_return(Item)
      allow(Item).to receive(:limit).with(4).and_return([related_item])
    end

    it 'returns items in the same category' do
      expect(item.find_related_items).to include(related_item)
      expect(item.find_related_items).not_to include(unrelated_item)
    end
  end

  describe '#purchased?' do
    let(:item) {
      Item.create!(
        title: 'Title1',
        description: 'Description1',
        price: 100,
        length: 10, width: 10, height: 10, dimension_units: 'in',
        weight: 10, weight_units: 'oz',
        condition: 0,
        user_id: 1
      )
    }
    let(:purchase) { instance_double('Purchase') }

    context 'when the item has not been purchased' do
      before do
        allow(item).to receive(:purchase).and_return(nil)
      end
      it 'should return false' do
        expect(item.purchased?).to eq(false)
      end
    end
    context 'when the item has been purchased' do
      before do
        allow(item).to receive(:purchase).and_return(purchase)
      end
      it 'should return true' do
        expect(item.purchased?).to eq(true)
      end
    end
  end

  describe 'dimensions' do
    let(:item) {
      Item.create!(
        title: 'Title1',
        description: 'Description1',
        price: 100,
        length: 10, width: 10, height: 10, dimension_units: 'in',
        weight: 10, weight_units: 'oz',
        condition: 0,
        user_id: 1
      )
    }

    it 'should return the correct dimensions' do
      expect(item.dimensions).to eq('10.0 x 10.0 x 10.0 in')
    end
  end

  describe 'condition_text' do
    let(:item) {
      Item.create!(
        title: 'Title1',
        description: 'Description1',
        price: 100,
        length: 10, width: 10, height: 10, dimension_units: 'in',
        weight: 10, weight_units: 'oz',
        condition: 0,
        user_id: 1
      )
    }

    it 'should return the correct condition text' do
      expect(item.condition_text).to eq('New')
    end
    it 'should return the correct condition text' do
      item.condition = 1
      expect(item.condition_text).to eq('Like New')
    end
  end

  describe 'round_dimensions' do
    let(:item) {
      Item.create!(
        title: 'Title1',
        description: 'Description1',
        price: 100,
        length: 10.123, width: 10.123, height: 10.123, dimension_units: 'in',
        weight: 10, weight_units: 'oz',
        condition: 0,
        user_id: 1
      )
    }

    it 'should return the correct rounded dimensions' do
      expect(item.dimensions).to eq('10.1 x 10.1 x 10.1 in')
    end
  end

end
