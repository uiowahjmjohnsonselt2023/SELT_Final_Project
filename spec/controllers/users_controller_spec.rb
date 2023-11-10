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

RSpec.describe UsersController, type: :controller do
  before(:each) do
    controller.extend(SessionsHelper)
  end
  let(:user) do
    User.create!(
      username: 'testuser',
      password: 'password',
      password_confirmation: 'password',
      email: 'test_user@test.com',
      phone_number: '1234567890'
    )
  end

  let(:other_user) do
    User.create!(
      username: 'otheruser',
      password: 'password',
      password_confirmation: 'password',
      email: 'other_user@test.com',
      phone_number: '0987654321'
    )
  end


  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end

    it "assigns a new User to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "GET #show" do
    context "when user is logged in" do
      before do
        controller.log_in(user)
      end

      it "renders the show template" do
        get :show, params: { id: user.id }
        expect(response).to render_template(:show)
      end

      it "assigns the requested user to @user" do
        get :show, params: { id: user.id }
        expect(assigns(:user)).to eq(user)
      end
    end

    context "when user is not logged in" do
      it "redirects to the login page" do
        get :show, params: { id: user.id }
        expect(response).to redirect_to(login_path)
      end
    end

  end


end



