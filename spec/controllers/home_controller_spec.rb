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
  before(:each) do
    controller.extend(SessionsHelper)
  end

  describe "GET #index" do
    context "when user is logged in" do
      let(:user) {
        User.create!(
          username: 'testuser',
          password: 'password',
          password_confirmation: 'password',
          email: 'test_email@test.com',
          phone_number: '1234567890'
        )
      }
      let(:items) {
        [
          user.items.create!(title: 'Item1', description: 'test', price: 1),
          user.items.create!(title: 'Item2', description: 'test', price: 2)
        ]
      }
      let(:categories) {
        [
          Category.create!(name: 'Category1'),
          Category.create!(name: 'Category2'),
        ]
      }

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

      it 'assigns @categories' do
        get :index
        expect(assigns(:categories)).to match_array(categories)
      end

      it 'assigns @suggested_items' do
        # Add the items to the user's bookmarks
        user.bookmarked_items << items
        get :index
        expect(assigns(:suggested_items)).to match_array(items)
      end

      it 'assigns @user_items for logged in user' do
        get :index
        expect(assigns(:user_items)).to match_array(items)
      end
    end

    context "when user is not logged in" do
      it "redirects to the login page" do
        get :index
        expect(response).to redirect_to(login_path)
      end

      it "sets a flash message" do
        get :index
        expect(flash[:error]).to match(/You must be logged in to access this section/)
      end

      it 'does not assign @categories' do
        get :index
        expect(assigns(:categories)).to be_nil
      end

      it 'does not assign @suggested_items' do
        get :index
        expect(assigns(:suggested_items)).to be_nil
      end
    end
  end
end
