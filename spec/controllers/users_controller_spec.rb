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

describe UsersController, type: :controller do
  let(:current_user) { instance_double('User', :session_token => "1", :id => "1") }
  let(:user) { instance_double('User', :session_token => "2", :id => "2") }
  let(:search_item) { instance_double('Item', :user_id => user.id) }
  let(:other_items) {
    [
      instance_double('Item', :user_id => user.id),
      instance_double('Item', :user_id => user.id),
      instance_double('Item', :user_id => user.id),
    ]
  }

  before(:each) do
    controller.extend(SessionsHelper)
    database_setup
  end

  describe ":set_current_user" do
    context "when user is logged in" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(current_user)
        session[:session_token] = current_user.session_token
        allow(User).to receive(:find).and_return(current_user)
      end

      it "assigns @current_user" do
        get :edit, { :id => current_user.id }
        expect(assigns(:current_user)).to eq(current_user)
      end
    end

    context "when user is logged out" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(nil)
        session[:session_token] = nil
      end

      it "does not assign @current_user" do
        get :edit, { :id => current_user.id }
        expect(assigns(:current_user)).to eq(nil)
      end
    end
  end

  describe ":correct_user" do
    context "when the user is correct" do
      before do
        allow(controller).to receive(:set_current_user).and_return(true)
        allow(controller).to receive(:current_user).and_return(current_user)
        allow(User).to receive(:find).and_return(current_user)
        session[:session_token] = current_user.session_token
      end

      it "does not set a flash message" do
        get :edit, { :id => current_user.id }
        expect(flash[:error]).to eq(nil)
      end
    end

    context "when the user is incorrect" do
      before do
        allow(controller).to receive(:set_current_user).and_return(true)
        allow(controller).to receive(:current_user).and_return(current_user)
        allow(User).to receive(:find).and_return(user)
        session[:session_token] = current_user.session_token
      end

      it "redirects to the home page" do
        get :edit, { :id => user.id }
        expect(response).to redirect_to(root_path)
      end

      it "sets a flash message" do
        get :edit, { :id => user.id }
        expect(flash[:error]).to match(/You do not have permission to edit or delete this user/)
      end
    end
  end

  describe "GET #show" do
    before do
      allow(User).to receive(:find).and_return(current_user)
      session[:session_token] = current_user.session_token
    end
    it "renders the show template" do
      get :show, { :id => current_user.id }
      expect(response).to render_template(:show)
    end

    it 'assigns @user' do
      get :show, { :id => current_user.id }
      expect(assigns(:user)).to eq(current_user)
    end
  end

  describe "GET #edit" do
    before do
      allow(controller).to receive(:set_current_user).and_return(true)
      allow(controller).to receive(:current_user).and_return(current_user)
      allow(User).to receive(:find).and_return(current_user)
      session[:session_token] = current_user.session_token
    end

    it "renders the edit template" do
      get :edit, { :id => current_user.id }
      expect(response).to render_template(:edit)
    end

    it 'assigns @user' do
      get :edit, { :id => current_user.id }
      expect(assigns(:user)).to eq(current_user)
    end
  end

  describe "POST #add_payment_method" do
    before do
      allow(controller).to receive(:set_current_user).and_return(true)
      allow(controller).to receive(:current_user).and_return(current_user)
      allow(User).to receive(:find).and_return(current_user)
      session[:session_token] = current_user.session_token
    end

    context "with valid inputs" do
      it "adds a new payment method and redirects" do
        #allow(current_user.payment_methods).to receive(:create!).with(hash_including(:encrypted_card_number, :encrypted_card_number_iv, :expiration_date))
        post :add_payment_method, params: { :card_number => "1234567890123456", :cvv => "123", :expiration_date => "10/2024" }
        expect(response).to redirect_to(user_path(current_user))
        expect(flash[:alert]).to eq("Payment Method Added")
      end
    end
  end

end

