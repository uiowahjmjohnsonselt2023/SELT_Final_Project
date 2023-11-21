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

describe CheckoutController, type: :controller do
  let(:current_user) { instance_double('User', :session_token => "1") }
  let(:item) { instance_double('Item', :id=> 1, :user_id => 2) }
  let(:seller) { instance_double('User2', :id => 2) }

  before(:each) do
    controller.extend(SessionsHelper)
    database_setup
  end

  describe "GET #show" do
    context "when user is logged in" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(current_user)
        session[:session_token] = current_user.session_token
      end
      before do
        allow(User).to receive(:find_by_session_token).and_return(current_user)
        session[:session_token] = current_user.session_token

      end

      it "assigns @item and @seller" do
        allow(Item).to receive(:find_by).with(id: item.id).and_return(item)
        allow(User).to receive(:find).with(item.user_id).and_return(seller)
        get :show, params: { id: item.id }
        expect(assigns(:item)).to eq(item)
        expect(assigns(:seller)).to eq(seller)
      end

      it "renders the show template" do
        get :show, params: { id: item.id }
        expect(response).to render_template(:show)
      end
    end

    context "when user is not logged in" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(nil)
        session[:session_token] = nil
      end

      it "redirects to the login page" do
        get :show, params: { id: item.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to match(/You must be logged in to access this section/)
      end
    end
  end

  describe "POST #purchase" do
    context "when user is logged in" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(current_user)
        session[:session_token] = current_user.session_token
        allow(Item).to receive(:find_by).with(id: item.id).and_return(item)
      end

      it "redirects to the root path with a success notice on successful purchase" do
        allow(current_user).to receive(:purchase_item).with(item, anything, anything).and_return(success: true, message: "Purchase successful")
        post :purchase, params: { id: item.id, address_id: 1, payment_method_id: 1 }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Purchase successful")
      end

      it "redirects to the root path with an alert on failed purchase" do
        allow(current_user).to receive(:purchase_item).with(item, anything, anything).and_return(success: false, message: "Purchase failed")
        post :purchase, params: { id: item.id, address_id: 1, payment_method_id: 1 }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Purchase failed")
      end
    end

    context "when user is not logged in" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(nil)
        session[:session_token] = nil
      end

      it "redirects to the login page" do
        post :purchase, params: { id: item.id, address_id: 1, payment_method_id: 1 }
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to match(/You must be logged in to access this section/)
      end
    end
  end
end



