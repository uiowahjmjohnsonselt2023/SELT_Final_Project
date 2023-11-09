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

describe ItemsController, type: :controller do
  before(:each) do
    controller.extend(SessionsHelper)
  end
  describe "GET #show" do
    context "when user is logged in" do
      before do
        user = User.create!(
          username: 'mainuser',
          password: 'password',
          password_confirmation: 'password',
          email: 'test_email@test.com',
          phone_number: '1234567890'
        )
        controller.log_in(user)
      end
      before do
        @user = User.find_by(username: 'mainuser')
        @item = @user.items.create!(title: "Item 1", description: "Description for item 1")
      end

      it "responds successfully" do
        get :show, { :id => @item.id }
        expect(response).to be_successful
      end

      it "renders the show template" do
        get :show, { :id => @item.id }
        expect(response).to render_template(:show)
      end

      it 'assigns @related_items' do
        get :show, { :id => @item.id }
        expect(assigns(:related_items)).not_to be_nil
      end

      it 'assigns @user' do
        get :show, { :id => @item.id }
        expect(assigns(:user)).to eq(@user)
      end
    end
  end
end
