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
  let(:addresses_double) { double("Addresses", :address_id => "1") }


  before(:each) do
    controller.extend(SessionsHelper)
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
      allow(current_user).to receive(:received_reviews).and_return([])
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
        post :add_payment_method, :id => current_user.id, :card_number => "1234567890123456", :expiration_month => "1", :expiration_year => "2025"
        expect(response).to redirect_to(edit_user_path(current_user))
      end


      it "sets a flash message" do
        allow(payment_method).to receive(:valid_payment_method_input?).and_return(false)
        post :add_payment_method, :id => current_user.id, :card_number => "1234567890123456", :expiration_month => "1", :expiration_year => "2025"
        expect(flash[:error]).to match("Invalid Payment Method Inputs: 15, 16, or 19 digit card number, 3 digit cvv, and (MM/YYYY) expiration date")
      end

    end

    context "with invalid expiration date" do
      it "redirects to current user path when invalid year" do
        post :add_payment_method, :id => current_user.id, :card_number => "1234567890123456", :expiration_month => "10", :expiration_year => "2018"
        expect(response).to redirect_to(edit_user_path(current_user))
      end

      it "sets a flash message when invalid year" do
        post :add_payment_method, :id => current_user.id, :card_number => "1234567890123456", :expiration_month => "10", :expiration_year => "2018"
        expect(flash[:error]).to match(/Invalid Expiration Date/)
      end

      it "redirects to current user path when invalid month" do
        post :add_payment_method, :id => current_user.id, :card_number => "1234567890123456", :expiration_month => "1", :expiration_year => "2023"
        expect(response).to redirect_to(edit_user_path(current_user))
      end

      it "sets a flash message when invalid month" do
        post :add_payment_method, :id => current_user.id, :card_number => "1234567890123456", :expiration_month => "1", :expiration_year => "2023"
        expect(flash[:error]).to match(/Invalid Expiration Date/)
      end
    end

    context "with valid inputs" do
      it "redirects to current user path" do
        allow(payment_method).to receive(:valid_payment_method_input?).and_return(true)
        expect(payment_methods_double).to receive(:create!)
        post :add_payment_method, :id => current_user.id, :card_number => "1234567890123456", :expiration_month => "10", :expiration_year => "2025"
        expect(response).to redirect_to(edit_user_path(current_user))
      end

      it "sets a flash message" do
        allow(payment_method).to receive(:valid_payment_method_input?).and_return(true)
        expect(payment_methods_double).to receive(:create!)
        post :add_payment_method, :id => current_user.id, :card_number => "1234567890123456", :expiration_month => "10", :expiration_year => "2025"
        expect(flash[:notice]).to match(/Payment Method Added/)
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
        expect(response).to redirect_to(edit_user_path(current_user))
      end

      it "sets a flash message" do
        allow(address).to receive(:valid_address_input?).and_return(false)
        post :add_address, :id => current_user.id, :shipping_address_1 => "123 Main St", :shipping_address_2 => "", :city => "San Francisco", :state => "CA", :country => "USA", :postal_code => "94105"
        expect(flash[:error]).to match(/Invalid Address Inputs/)
      end

      it "redirects to current user path when country is not selected" do
        post :add_address, :id => current_user.id, :shipping_address_1 => "123 Main St", :shipping_address_2 => "", :city => "San Francisco", :state => "CA", :country => "Select Country", :postal_code => "94105"
        expect(response).to redirect_to(user_path(current_user))
      end

      it "sets a flash message when country is not selected" do
        post :add_address, :id => current_user.id, :shipping_address_1 => "123 Main St", :shipping_address_2 => "", :city => "San Francisco", :state => "CA", :country => "Select Country", :postal_code => "94105"
        expect(flash[:error]).to match(/Invalid Address Inputs/)
      end

      it "redirects to current user path when country is United States and state is not selected" do
        post :add_address, :id => current_user.id, :shipping_address_1 => "123 Main St", :shipping_address_2 => "", :city => "San Francisco", :state => "Select State", :country => "United States", :postal_code => "94105"
        expect(response).to redirect_to(user_path(current_user))
      end

      it "sets a flash message when country is United States and state is not selected" do
        post :add_address, :id => current_user.id, :shipping_address_1 => "123 Main St", :shipping_address_2 => "", :city => "San Francisco", :state => "Select State", :country => "United States", :postal_code => "94105"
        expect(flash[:error]).to match(/Invalid Address Inputs/)
      end
    end

    context "with valid inputs" do
      it "redirects to current user path" do
        allow(address).to receive(:valid_address_input?).and_return(true)
        expect(addresses_double).to receive(:create!)
        post :add_address, :id => current_user.id, :shipping_address_1 => "123 Main St", :shipping_address_2 => "", :city => "San Francisco", :state => "CA", :country => "USA", :postal_code => "94105"
        expect(response).to redirect_to(edit_user_path(current_user))
      end

      it "sets a flash message" do
        allow(address).to receive(:valid_address_input?).and_return(true)
        expect(addresses_double).to receive(:create!)
        post :add_address, :id => current_user.id, :shipping_address_1 => "123 Main St", :shipping_address_2 => "", :city => "San Francisco", :state => "CA", :country => "USA", :postal_code => "94105"
        expect(flash[:notice]).to match(/Address Added/)
      end

      it "sets state param if not set and country is not the US" do
        expect(addresses_double).to receive(:create!)
        post :add_address, :id => current_user.id, :shipping_address_1 => "123 Main St", :shipping_address_2 => "", :city => "San Francisco", :state => "Select State", :country => "Vatican City", :postal_code => "94105"
        expect(assigns(:state)).to eq(nil)

      end
    end
  end

  describe "POST #delete_address" do
    before do
      allow(controller).to receive(:set_current_user).and_return(true)
      allow(controller).to receive(:current_user).and_return(current_user)
      allow(User).to receive(:find).and_return(current_user)
      session[:session_token] = current_user.session_token
      allow(current_user).to receive(:addresses).and_return(addresses_double)
    end

    context "with valid inputs" do
      it "redirects to current user path" do
        expect(addresses_double).to receive(:find).and_return(address)
        expect(address).to receive(:destroy)
        delete :delete_address, :id => current_user.id, :address_id => 4
        expect(response).to redirect_to(edit_user_path(current_user))
      end


      it "sets a flash message when successful" do
        expect(addresses_double).to receive(:find).and_return(address)
        allow(address).to receive(:destroy).and_return(true)
        delete :delete_address, :id => current_user.id, :address_id => "1"
        expect(flash[:notice]).to match('Address deleted successfully.')
      end

      it "sets a flash message when unsuccessful" do
        expect(addresses_double).to receive(:find).and_return(address)
        allow(address).to receive(:destroy).and_return(false)
        delete :delete_address, :id => current_user.id, :address_id => "1"
        expect(flash[:alert]).to match('Could not delete the address.')
      end
    end

    context "with invalid inputs" do
      it "redirects to current user path" do
        delete :delete_address, :id => current_user.id, :address_id => ""
        expect(response).to redirect_to(edit_user_path(current_user))
      end

      it "sets a flash message when unsuccessful" do
        delete :delete_address, :id => current_user.id, :address_id => ""
        expect(flash[:alert]).to match('Could not delete the address. Must select an address.')
      end
    end
  end


  describe "DELETE #delete_payment_methods" do
    before do
      allow(controller).to receive(:set_current_user).and_return(true)
      allow(controller).to receive(:current_user).and_return(current_user)
      allow(User).to receive(:find).and_return(current_user)
      session[:session_token] = current_user.session_token
      allow(current_user).to receive(:payment_methods).and_return(addresses_double)
    end

    context "with valid inputs" do
      it "redirects to current user path" do
        expect(addresses_double).to receive(:find).and_return(payment_method)
        expect(payment_method).to receive(:destroy)
        delete :delete_payment_method, :id => current_user.id, :payment_method_id => 4
        expect(response).to redirect_to(edit_user_path(current_user))
      end


      it "sets a flash message when successful" do
        expect(addresses_double).to receive(:find).and_return(payment_method)
        allow(payment_method).to receive(:destroy).and_return(true)
        delete :delete_payment_method, :id => current_user.id, :payment_method_id => "1"
        expect(flash[:notice]).to match('Payment method deleted successfully.')
      end

      it "sets a flash message when unsuccessful" do
        expect(addresses_double).to receive(:find).and_return(payment_method)
        allow(payment_method).to receive(:destroy).and_return(false)
        delete :delete_payment_method, :id => current_user.id, :payment_method_id => "1"
        expect(flash[:alert]).to match('Could not delete the payment method.')
      end
    end

    context "with invalid inputs" do
      it "redirects to current user path" do
        delete :delete_payment_method, :id => current_user.id, :payment_method_id => ""
        expect(response).to redirect_to(edit_user_path(current_user))
      end

      it "sets a flash message when unsuccessful" do
        delete :delete_payment_method, :id => current_user.id, :payment_method_id => ""
        expect(flash[:alert]).to match('Could not delete the payment method. Must select a payment method.')
      end
    end
  end

end

