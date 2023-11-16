require 'spec_helper'
require 'rails_helper'
if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end

RSpec.describe SearchController, type: :controller do
  before(:each) do
    controller.extend(SessionsHelper)
  end

  let(:user){
    User.create!(
      username: 'testuser',
      password: 'password',
      password_confirmation: 'password',
      email: 'test_email@test.com',
      phone_number: '1234567890'
    )
  }

  let(:items){
    [
      user.items.create!(title: "Item 1", price: 1, description: "Description for item 1"),
      user.items.create!(title: "Item 2", price: 2, description: "Description for item 2")
    ]
  }

  let(:seller) do
    User.create!(
      username: 'seller',
      password: 'password',
      password_confirmation: 'password',
      email: 'seller_email@test.com',
      phone_number: '1234567890'
    )
  end
  let(:low_priced_item) { user.items.create!(title: "Low Priced Item", price: 5, description: "Cheap item") }
  let(:mid_priced_item) { user.items.create!(title: "Mid Priced Item", price: 50, description: "Moderately priced item") }
  let(:high_priced_item) { user.items.create!(title: "High Priced Item", price: 500, description: "Expensive item") }
  let(:bookmarked_item) { user.items.create!(title: "Bookmarked Item", price: 10, description: "Bookmarked item description") }
  let(:non_bookmarked_item) { user.items.create!(title: "Non-Bookmarked Item", price: 20, description: "Non-bookmarked item description") }

  let(:category1) { Category.create!(name: 'Category1') }
  let(:category2) { Category.create!(name: 'Category2') }
  let(:item1) { seller.items.create!(title: "Item1", categories: [category1], price: 10, description: "test") }
  let(:item2) { seller.items.create!(title: "Item2", categories: [category2], price: 20, description: "test") }
  let(:item3) { seller.items.create!(title: "Item3", categories: [category1], price: 30, description: "test") }


  describe "Get #index" do
    context "when user is logged in" do
      before do
        controller.log_in(user)
      end
      it "responds successfully" do
        get :index
        expect(response).to be_successful
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end
      it 'assigns @results' do
        get :index
        expect(assigns(:results)).not_to be_nil
      end
      it 'assigns results to expected value' do
        get :index
        allow(Item).to receive(:search).and_return(items)
        expect(assigns(:results).to_a).to match_array(items)
      end
      # Calls Item.search method
      it 'calls Item.search method' do
        expect(Item).to receive(:search)
        get :index
      end
      # Calls Item.search method with search_term and categories
      it 'calls Item.search method with search_term and categories' do
        params = { search_term: 'test', categories: ['1', '2'] }
        expect(Item).to receive(:search).with(params[:search_term], params[:categories])
        get :index, :search_term => 'test', :categories => ['1', '2']
      end
    end

    context "when user is logged out" do
      it "redirects to the login page" do
        get :index
        expect(response).to redirect_to(login_path)
      end
      it "sets a flash message" do
        get :index
        expect(flash[:error]).to match(/You must be logged in to access this section/)
      end
    end
  end

  describe "Get #index with filtering for the search" do
    before(:each) do
      controller.log_in(user)
    end

    it 'filters by category' do
      params = { search_term: 'test', categories: %w[1 2] }
      expect(Item).to receive(:search).with(params[:search_term], params[:categories])
      get :index, :search_term => 'test', :categories => ['1', '2']
    end

    it 'filters by seller where items are found' do
      # Stub `User.find_by` to return the seller
      allow(User).to receive(:find_by).with(id: user.id).and_return(user)
      allow(User).to receive(:find_by).with(username: 'seller').and_return(user)
      get :index, search_term: 'Item', seller: 'seller'
    end

    it 'filters by seller where no items are found' do
      nonexistent_seller = 'nonexistent_user'
      allow(User).to receive(:find_by).with(id: user.id).and_return(user)
      allow(User).to receive(:find_by).with(username: nonexistent_seller).and_return(nil)

      get :index, params: { search_term: 'No Match', seller: nonexistent_seller }

      expect(assigns(:results)).to be_empty
    end

    it 'filters by min price' do
      get :index, min_price: 10, search_term: 'Item'
      expect(assigns(:results)).to include(mid_priced_item, high_priced_item)
      expect(assigns(:results)).not_to include(low_priced_item)
    end

    it 'filters by max price' do
      get :index, max_price: 100, search_term: 'Item'
      expect(assigns(:results)).to include(low_priced_item, mid_priced_item)
      expect(assigns(:results)).not_to include(high_priced_item)
    end

    it 'returns only bookmarked items when bookmark filter is applied' do
      user.bookmarks.create!(item: bookmarked_item)
      get :index, bookmarks: '1', search_term: 'Item'
      expect(assigns(:results)).to include(bookmarked_item)
      expect(assigns(:results)).not_to include(non_bookmarked_item)
    end

    it 'returns all items when bookmark filter is not applied' do
      get :index
      expect(assigns(:results)).to include(bookmarked_item, non_bookmarked_item)
    end

    it 'filters by bookmarks and seller items' do
      # Stub `User.find_by` to return the seller
      allow(User).to receive(:find_by).with(id: user.id).and_return(user)
      allow(User).to receive(:find_by).with(username: 'seller').and_return(user)
      get :index, search_term: 'Item', seller: 'seller', bookmarks: '1'
    end
  end

  describe "Get #index with combined filters" do
    before do
      controller.log_in(user)
      user.bookmarks.create!(item: item1)
    end

    it 'applies category and seller filters' do
      get :index, categories: [category1.name], seller: seller.username, search_term: 'Item'
      expect(assigns(:results)).to include(item1, item3)
      expect(assigns(:results)).not_to include(item2)
    end

    it 'applies price range and bookmark filters' do
      get :index, min_price: 10, max_price: 25, bookmarks: '1', search_term: 'Item'
      expect(assigns(:results)).to include(item1)
      expect(assigns(:results)).not_to include(item2, item3)
    end

    it 'applies all filters together' do
      get :index, categories: [category1.name], seller: seller.username, min_price: 5, max_price: 15, bookmarks: '1', search_term: 'Item'
      expect(assigns(:results)).to include(item1)
      expect(assigns(:results)).not_to include(item2, item3)
    end
  end

end



