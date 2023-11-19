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
  let(:current_user) { instance_double('User', :session_token => "1") }

  before(:each) do
    controller.extend(SessionsHelper)
    database_setup
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  describe "POST #create" do
    before do
      allow(User).to receive(:find_by_provider_and_uid).and_return(current_user)
      allow(User).to receive(:create_with_omniauth).and_return(current_user)
    end

    it "redirects to the home page" do
      post :create
      expect(response).to redirect_to(root_path)
    end
    it "assigns the session token correctly" do
      post :create
      expect(session[:session_token]).to eq("1")
    end
  end

  describe "DELETE #destroy" do
    it "assigns the session token correctly" do
      delete :destroy
      expect(session[:session_token]).to eq(nil)
    end
    it "assigns the current user correctly" do
      delete :destroy
      expect(assigns(:current_user)).to eq(nil)
    end
    it "flashes a notice" do
      delete :destroy
      expect(flash[:notice]).to eq("You have been logged out")
    end
    it "redirects to the home page" do
      delete :destroy
      expect(response).to redirect_to(root_path)
    end
  end
end
