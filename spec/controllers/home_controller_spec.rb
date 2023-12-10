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
  let(:test_item1){ [instance_double('Item', :user_id => 1)] }
  let(:test_item2){ [instance_double('Item', :user_id => 2)] }
  let(:test_item3){ [instance_double('Item', :user_id => 3)] }
  let(:test_items){
    [
      test_item1,
      test_item2,
      test_item3
    ]
  }
  let(:category1) {instance_double('Category', :name => "category1")}
  let(:category2) {instance_double('Category', :name => "category2")}
  let(:category3) {instance_double('Category', :name => "category3")}
  let(:categories) {
    [
      category1,
      category2,
      category3
    ]
  }

  before(:each) do
    controller.extend(SessionsHelper)
  end

  describe "GET #index" do
    before do
      allow(Category).to receive(:all).and_return(categories)
    end

    it "assigns @categories" do
      allow(category1).to receive(:items).and_return(test_item1)
      allow(test_item1).to receive(:first).and_return(test_items[0])
      allow(category2).to receive(:items).and_return(test_item2)
      allow(test_item2).to receive(:first).and_return(test_items[1])
      allow(category3).to receive(:items).and_return(test_item3)
      allow(test_item3).to receive(:first).and_return(test_items[2])


      get :index
      expect(assigns(:category_items)).to match_array(test_items)
      expect(assigns(:category_order)).to match_array(categories.map{|c| c.name})
    end
    context "when user is logged in" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(current_user)
        session[:session_token] = current_user.session_token
        allow(User).to receive(:find).and_return(current_user)
        allow(Category).to receive(:all).and_return([])
      end

      it "assigns @suggested_items" do
        #allow(User).to receive(:get_suggested_items)
        allow(current_user).to receive(:get_users_suggested_items).and_return(test_items)
        allow(current_user).to receive(:items).and_return(true)


        allow(User).to receive(:get_suggested_items).and_return(test_items)
        get :index
        expect(assigns(:user_items)).to eq(true)
        expect(assigns(:suggested_items)).to eq(test_items)
      end
    end

  end
end
