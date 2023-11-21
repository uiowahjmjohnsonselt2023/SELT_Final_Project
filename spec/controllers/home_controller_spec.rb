require 'spec_helper'
require 'rails_helper'

if RUBY_VERSION >= '2.6.0'
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

describe HomeController, type: :controller do
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
  let(:other_items) {
    [
      instance_double('Item', :user_id => 2),
      instance_double('Item', :user_id => 2),
      instance_double('Item', :user_id => 2),
      instance_double('Item', :user_id => 2),
      instance_double('Item', :user_id => 2)
    ]
  }
  let(:categories) {
    [
      instance_double('Category'),
      instance_double('Category'),
      instance_double('Category')
    ]
  }

  before(:each) do
    controller.extend(SessionsHelper)
    database_setup
  end

  describe "GET #index" do
    before do
      allow(Category).to receive(:all).and_return(categories)
      allow(categories).to receive(:limit).and_return(categories)
    end

    it "assigns @categories" do
      get :index
      expect(assigns(:categories)).to match_array(categories)
    end

    context "when user is logged in" do
      before do
        session[:session_token] = current_user.session_token
        allow(controller).to receive(:current_user).and_return(current_user)
        allow(current_user).to receive(:items).and_return(current_user_items)
      end

      context "when user has 0 items bookmarked" do
        before do
          allow(current_user).to receive(:bookmarked_items).and_return(current_user_items)
          allow(current_user_items).to receive(:limit).and_return([])
          allow(Item).to receive(:where).and_return(other_items)
          allow(other_items).to receive(:not).and_return(other_items)
          allow(other_items).to receive(:limit).and_return(other_items[0..3])
        end

        it 'assigns @suggested_items' do
          get :index
          expect(assigns(:suggested_items)).to match_array(other_items[0..3])
        end

        it "assigns @user_items" do
          get :index
          expect(assigns(:user_items)).to match_array(current_user_items)
        end
      end

      context "when user has 1-3 items bookmarked" do
        before do
          allow(current_user).to receive(:bookmarked_items).and_return(current_user_items)
          allow(current_user_items).to receive(:limit).and_return(current_user_items[0..1])
          allow(Item).to receive(:where).and_return(other_items)
          allow(other_items).to receive(:not).and_return(other_items)
          allow(other_items).to receive(:limit).and_return(other_items[0..1])
        end

        it 'assigns @suggested_items' do
          get :index
          expect(assigns(:suggested_items)).to match_array(current_user_items[0..1] + other_items[0..1])
        end

        it "assigns @user_items" do
          get :index
          expect(assigns(:user_items)).to match_array(current_user_items)
        end
      end

      context "when user has 4 or more items bookmarked" do
        before do
          allow(current_user).to receive(:bookmarked_items).and_return(current_user_items)
          allow(current_user_items).to receive(:limit).and_return(current_user_items[0..3])
        end

        it 'assigns @suggested_items' do
          get :index
          expect(assigns(:suggested_items)).to match_array(current_user_items[0..3])
        end

        it "assigns @user_items" do
          get :index
          expect(assigns(:user_items)).to match_array(current_user_items)
        end
      end
    end

    context "when user is not logged in" do
      before do
        session[:session_token] = nil
        allow(controller).to receive(:current_user).and_return(nil)
        allow(Item).to receive(:all).and_return(other_items)
        allow(other_items).to receive(:not).and_return(other_items)
        allow(other_items).to receive(:limit).and_return(other_items[0..3])
      end

      it 'assigns @suggested_items' do
        get :index
        expect(assigns(:suggested_items)).to match_array(other_items[0..3])
      end

      it "does not assign @user_items" do
        get :index
        expect(assigns(:user_items)).to be_nil
      end
    end
  end
end
