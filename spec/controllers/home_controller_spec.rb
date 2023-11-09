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
      before do
        user = User.create!(
          username: 'testuser',
          password: 'password',
          password_confirmation: 'password',
          email: 'test_email@test.com',
          phone_number: '1234567890'
        )
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
        expect(assigns(:categories)).not_to be_nil
      end

      it 'assigns @suggested_items' do
        get :index
        expect(assigns(:suggested_items)).not_to be_nil
      end

      it 'assigns @user_items' do
        get :index
        expect(assigns(:user_items)).not_to be_nil
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