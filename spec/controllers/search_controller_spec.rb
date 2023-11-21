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

describe SearchController, type: :controller do
  let(:current_user) { instance_double('User', :session_token => "1", :id => 1) }
  let(:current_user_items) {
    [
      instance_double('Item', :user_id => 1),
      instance_double('Item', :user_id => 1),
      instance_double('Item', :user_id => 1),
      instance_double('Item', :user_id => 1),
      instance_double('Item', :user_id => 1)
    ]
  }
  let(:seller) { instance_double('User', :session_token => "2", :username => "seller", :id => 2) }

  let(:categories) {
    [
      instance_double('Category', :name => 'Category 1'),
      instance_double('Category', :name => 'Category 2'),
      instance_double('Category', :name => 'Category 3')
    ]
  }

  let(:items) {
    [
      instance_double('Item', :categories => categories[0], :user_id => 2),
      instance_double('Item', :categories => categories[1], :user_id => 2),
      instance_double('Item', :categories => categories[2], :user_id => 2),
    ]
  }

  before(:each) do
    controller.extend(SessionsHelper)
    database_setup
  end

  describe "Get #index" do
    context "when user is logged in" do
      before do
        session[:session_token] = current_user.session_token
        allow(controller).to receive(:current_user).and_return(current_user)
      end

      context "when user does a blank search" do
        before do
          allow(Item).to receive(:all).and_return(items)
        end

        it "assigns @results to all items" do
          get :index
          expect(assigns(:results)).to match_array(items)
        end
      end

      context "when user searches for only bookmarked items" do
        before do
          allow(current_user).to receive(:bookmarked_items).and_return(items)
        end

        it "assigns @results to bookmarked items" do
          get :index, :bookmarks => '1'
          expect(assigns(:results)).to match_array(items)
        end
      end
    end

    context "when user is not logged in" do
      before do
        session[:session_token] = nil
        allow(controller).to receive(:current_user).and_return(nil)
      end

      context "when user does a blank search" do
        before do
          allow(Item).to receive(:all).and_return(items)
        end

        it "assigns @results to all items" do
          get :index
          expect(assigns(:results)).to match_array(items)
        end
      end

      context "when user searches for only bookmarked items" do
        before do
          allow(Item).to receive(:all).and_return(items)
        end

        it "assigns @results to all items" do
          get :index, :bookmarks => '1'
          expect(assigns(:results)).to match_array(items)
        end
      end
    end

    context "when user searches with categories only" do
      before do
        session[:session_token] = nil
        allow(controller).to receive(:current_user).and_return(nil)
        allow(Item).to receive(:search).and_return(items[0..1])
      end

      it "calls Item.search with correct parameters" do
        expect(Item).to receive(:search).with(nil, %w[1 2])
        get :index, :categories => %w[1 2]
      end

      it "assigns @results correctly" do
        get :index, :categories => %w[1 2]
        expect(assigns(:results)).to match_array(items[0..1])
      end
    end

    context "when user searches with search term only" do
      before do
        session[:session_token] = nil
        allow(controller).to receive(:current_user).and_return(nil)
        allow(Item).to receive(:search).and_return(items[0..1])
        allow(Category).to receive(:all).and_return(categories)
      end

      it "calls Item.search with correct parameters" do
        expect(Item).to receive(:search).with('test', ["Category 1", "Category 2", "Category 3"])
        get :index, :search_term => 'test'
      end

      it "assigns @results correctly" do
        get :index, :search_term => 'test'
        expect(assigns(:results)).to match_array(items[0..1])
      end
    end

    context "when user searches with search term and categories" do
      before do
        session[:session_token] = nil
        allow(controller).to receive(:current_user).and_return(nil)
        allow(Item).to receive(:search).and_return(items[0..1])
        allow(Category).to receive(:all).and_return(categories)
      end

      it "calls Item.search with correct parameters" do
        expect(Item).to receive(:search).with('test', %w[1 2])
        get :index, :search_term => 'test', :categories => %w[1 2]
      end

      it "assigns @results correctly" do
        get :index, :search_term => 'test', :categories => %w[1 2]
        expect(assigns(:results)).to match_array(items[0..1])
      end
    end

    context "when user searches with seller" do
      before do
        session[:session_token] = nil
        allow(controller).to receive(:current_user).and_return(nil)
        allow(Item).to receive(:all).and_return(items)
      end

      context "when seller exists" do
        before do
          allow(User).to receive(:find_by).with(username: seller.username).and_return(seller)
          allow(items).to receive(:where).and_return(items)
        end

        it "calls Item.where with correct parameters" do
          expect(items).to receive(:where).with("items.user_id = ?", seller.id)
          get :index, :seller => seller.username
        end

        it "assigns @results correctly" do
          get :index, :seller => seller.username
          expect(assigns(:results)).to match_array(items)
        end
      end

      context "when seller does not exist" do
        before do
          allow(User).to receive(:find_by).with(username: seller.username).and_return(nil)
        end

        it "doesnt call Item.where" do
          expect(items).not_to receive(:where)
          get :index, :seller => seller.username
        end

        it "assigns @results correctly" do
          get :index, :seller => seller.username
          expect(assigns(:results)).to match_array([])
        end
      end
    end

    context "when user searches with price" do
      before do
        session[:session_token] = nil
        allow(controller).to receive(:current_user).and_return(nil)
        allow(Item).to receive(:all).and_return(items)
        allow(items).to receive(:where).and_return(items)
      end

      context "when user searches with just min_price" do
        it "calls Item.where with correct parameters" do
          expect(items).to receive(:where).with("price >= ?", "10")
          get :index, :min_price => "10"
        end

        it "assigns @results correctly" do
          get :index, :min_price => "10"
          expect(assigns(:results)).to match_array(items)
        end
      end

      context "when user searches with just max_price" do
        it "calls Item.where with correct parameters" do
          expect(items).to receive(:where).with("price <= ?", "10")
          get :index, :max_price => "10"
        end

        it "assigns @results correctly" do
          get :index, :max_price => "10"
          expect(assigns(:results)).to match_array(items)
        end
      end

      context "when user searches with both min_price and max_price" do
        it "calls Item.where with correct parameters" do
          expect(items).to receive(:where).with("price >= ?", "10")
          expect(items).to receive(:where).with("price <= ?", "20")
          get :index, :min_price => "10", :max_price => "20"
        end

        it "assigns @results correctly" do
          get :index, :min_price => "10", :max_price => "20"
          expect(assigns(:results)).to match_array(items)
        end
      end
    end
  end
end





