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

describe SessionsController, type: :controller do
  let(:current_user) {
    User.create!(
      username: 'current_user',
      password: 'current_user_password',
      password_confirmation: 'current_user_password',
      email: 'current_user_email@test.com',
      phone_number: '1234567890'
    )
  }

  before(:each) do
    controller.extend(SessionsHelper)
  end

  describe "GET #new" do
    context "when user is logged in" do
      before do
        controller.log_in(current_user)
      end
      it "redirects to the home page" do
        get :new
        expect(response).to redirect_to(root_path)
      end
      it "sets a flash message" do
        get :new
        expect(flash[:error]).to match(/You are already logged in/)
      end
    end

    context "when user is logged out" do
      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST #create" do
    context "when user is logged in" do
      before do
        controller.log_in(current_user)
      end
      it "redirects to the home page" do
        get :create
        expect(response).to redirect_to(root_path)
      end
      it "sets a flash message" do
        get :create
        expect(flash[:error]).to match(/You are already logged in/)
      end
    end

    context "when user is logged out and the entered credentials" do
      let(:user) {
        User.create!(
          username: 'test_user',
          password: 'test_password',
          password_confirmation: 'test_password',
          email: 'test_email@test.com',
          phone_number: '1234567890'
        )
      }
      context "do not match a user in the database" do
        before do
          allow(User).to receive(:find_by).and_return(nil)
        end
        it "renders the new template" do
          get :create, :session => { :username => 'test_user', :password => 'test_password' }
          expect(response).to render_template(:new)
        end
        it "sets a flash message" do
          get :create, :session => { :username => 'test_user', :password => 'test_password' }
          expect(flash[:danger]).to match(/Invalid username\/password combination/)
        end
      end

      context "match a user in the database" do
        before do
          allow(User).to receive(:find_by).and_return(user)
          allow(controller).to receive(:log_in)
        end

        it "logs the user in" do
          get :create, :session => { :username => 'test_user', :password => 'test_password' }
          expect(controller).to have_received(:log_in).with(user)
        end

        it "redirects to the home page" do
          get :create, :session => { :username => 'test_user', :password => 'test_password' }
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is logged in" do
      before do
        controller.log_in(current_user)
        allow(controller).to receive(:log_out)
      end

      it "logs the user out" do
        delete :destroy
        expect(controller).to have_received(:log_out)
      end
    end

    context "when user is logged out" do
      it "redirects to the home page" do
        delete :destroy
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
