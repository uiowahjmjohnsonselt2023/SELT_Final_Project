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

  let(:payment_method) { instance_double('PaymentMethod', :valid_payment_method_input? => true) }
  let(:payment_methods_double) { double("PaymentMethods") }

  let(:address) { instance_double('Address', :valid_address_input? => true) }
  let(:addresses_double) { double("Addresses") }


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
      allow(PaymentMethod).to receive(:new).and_return(payment_method)
      allow(current_user).to receive(:payment_methods).and_return(payment_methods_double)
    end

    context "with invalid inputs" do
      it "redirects to current user path" do
        allow(payment_method).to receive(:valid_payment_method_input?).and_return(false)
        post :add_payment_method, :id => current_user.id, :card_number => "1234567890123456", :cvv => "123", :expiration_date => "10/2024"
        expect(response).to redirect_to(user_path(current_user))
      end

      it "sets a flash message" do
        allow(payment_method).to receive(:valid_payment_method_input?).and_return(false)
        post :add_payment_method, :id => current_user.id, :card_number => "1234567890123456", :cvv => "123", :expiration_date => "10/2024"
        expect(flash[:error]).to match(/Invalid Payment Method Inputs/)
      end
    end

    context "with valid inputs" do
      it "redirects to current user path" do
        allow(payment_method).to receive(:valid_payment_method_input?).and_return(true)
        expect(payment_methods_double).to receive(:create!)
        post :add_payment_method, :id => current_user.id, :card_number => "1234567890123456", :cvv => "123", :expiration_date => "10/2024"
        expect(response).to redirect_to(user_path(current_user))
      end

      it "sets a flash message" do
        allow(payment_method).to receive(:valid_payment_method_input?).and_return(true)
        expect(payment_methods_double).to receive(:create!)
        post :add_payment_method, :id => current_user.id, :card_number => "1234567890123456", :cvv => "123", :expiration_date => "10/2024"
        expect(flash[:alert]).to match(/Payment Method Added/)
      end
    end
  end

  describe "POST #add_address" do
    before do
      allow(controller).to receive(:set_current_user).and_return(true)
      allow(controller).to receive(:current_user).and_return(current_user)
      allow(User).to receive(:find).and_return(current_user)
      session[:session_token] = current_user.session_token
      allow(Address).to receive(:new).and_return(address)
      allow(current_user).to receive(:addresses).and_return(addresses_double)
    end

    context "with invalid inputs" do
      it "redirects to current user path" do
        allow(address).to receive(:valid_address_input?).and_return(false)
        post :add_address, :id => current_user.id, :shipping_address_1 => "123 Main St", :shipping_address_2 => "", :city => "San Francisco", :state => "CA", :country => "USA", :postal_code => "94105"
        expect(response).to redirect_to(user_path(current_user))
      end

      it "sets a flash message" do
        allow(address).to receive(:valid_address_input?).and_return(false)
        post :add_address, :id => current_user.id, :shipping_address_1 => "123 Main St", :shipping_address_2 => "", :city => "San Francisco", :state => "CA", :country => "USA", :postal_code => "94105"
        expect(flash[:error]).to match(/Invalid Address Inputs/)
      end
    end

    context "with valid inputs" do
      it "redirects to current user path" do
        allow(address).to receive(:valid_address_input?).and_return(true)
        expect(addresses_double).to receive(:create!)
        post :add_address, :id => current_user.id, :shipping_address_1 => "123 Main St", :shipping_address_2 => "", :city => "San Francisco", :state => "CA", :country => "USA", :postal_code => "94105"
        expect(response).to redirect_to(user_path(current_user))
      end

      it "sets a flash message" do
        allow(address).to receive(:valid_address_input?).and_return(true)
        expect(addresses_double).to receive(:create!)
        post :add_address, :id => current_user.id, :shipping_address_1 => "123 Main St", :shipping_address_2 => "", :city => "San Francisco", :state => "CA", :country => "USA", :postal_code => "94105"
        expect(flash[:alert]).to match(/Address Added/)
      end
    end
  end

end

