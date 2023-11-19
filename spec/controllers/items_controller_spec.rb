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
  let(:current_user) { instance_double('User', :session_token => "1") }
  let(:other_user) { instance_double('User', :session_token => "2") }
  let(:current_user_item) { instance_double('Item', :id => 1, :user => current_user) }
  let(:other_user_item) { instance_double('Item', :id => 2, :user => other_user) }
  let(:item) { instance_double('Item', :id => 1, :user_id => 1) }

  before(:each) do
    controller.extend(SessionsHelper)
    database_setup
  end

  describe "GET #new" do
    context "when user is logged in" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(current_user)
        session[:session_token] = current_user.session_token
      end

      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context "when user is logged out" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(nil)
        allow(controller).to receive(:current_user).and_return(nil)
        session[:session_token] = nil
      end

      it "redirects to the login page" do
        get :new
        expect(response).to redirect_to(login_path)
      end

      it "sets a flash message" do
        get :new
        expect(flash[:error]).to match(/You must be logged in to access this section/)
      end
    end
  end

  describe "POST #create" do
    context "when user is logged in" do
      let(:params) do
        {
          item: {
            title: 'Test Item',
            description: 'Test Description',
            price: '9.99',
            category_ids: ['1', '2'],
            images: ['image1.png', 'image2.png']
          }
        }
      end

      before do
        allow(User).to receive(:find_by_session_token).and_return(current_user)
        session[:session_token] = current_user.session_token
        allow(controller).to receive(:current_user).and_return(current_user)
        allow(Item).to receive(:insert_item).with(
          current_user,
          params[:item][:title],
          params[:item][:description],
          params[:item][:price],
          params[:item][:category_ids],
          params[:item][:images]
        ).and_return(item)
      end

      it "assigns @current_user" do
        post :create, { :item => params[:item] }
        expect(assigns(:current_user)).to eq(current_user)
      end

      it "redirects to the item#show page" do
        post :create, { :item => params[:item] }
        expect(response).to redirect_to(item_path(item))
      end
    end

    context "when user is logged out" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(nil)
        allow(controller).to receive(:current_user).and_return(nil)
        session[:session_token] = nil
      end

      it "redirects to the login page" do
        post :create
        expect(response).to redirect_to(login_path)
      end

      it "sets a flash message" do
        post :create
        expect(flash[:error]).to match(/You must be logged in to access this section/)
      end
    end
  end

  describe "GET #show" do
    let(:user) { instance_double('User', :session_token => "2") }
    let(:search_item) { instance_double('Item', id: 1, 'user_id': 2) }
    let(:other_items) {
      [
        instance_double('Item', id: 2),
        instance_double('Item', id: 3),
        instance_double('Item', id: 4)
      ]
    }
    let(:bookmarked_items) { [instance_double('Item', id: 5)] }

    before do
      allow(Item).to receive(:find).and_return(search_item)
      allow(search_item).to receive(:find_related_items).and_return(other_items)
      allow(User).to receive(:find).and_return(user)
      allow(bookmarked_items).to receive(:include?).and_return(true)
    end
    context "when user is logged in" do
      before do
        session[:session_token] = current_user.session_token
        allow(controller).to receive(:current_user).and_return(current_user)
        allow(current_user).to receive(:bookmarked_items).and_return(bookmarked_items)
      end

      it "renders the show template" do
        get :show, { :id => search_item.id }
        expect(response).to render_template(:show)
      end

      it 'assigns @item' do
        get :show, { :id => search_item.id }
        expect(assigns(:item)).to eq(search_item)
      end

      it 'assigns @related_items' do
        get :show, { :id => search_item.id }
        expect(assigns(:related_items)).to eq(other_items)
      end

      it 'assigns @user' do
        get :show, { :id => search_item.id }
        expect(assigns(:user)).to eq(user)
      end

      it 'assigns @bookmarked' do
        get :show, { :id => search_item.id }
        expect(assigns(:bookmarked)).to eq(true)
      end
    end

    context "when user is logged out" do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
        session[:session_token] = nil
      end
      it "renders the show template" do
        get :show, { :id => search_item.id }
        expect(response).to render_template(:show)
      end

      it 'assigns @item' do
        get :show, { :id => search_item.id }
        expect(assigns(:item)).to eq(search_item)
      end

      it 'assigns @related_items' do
        get :show, { :id => search_item.id }
        expect(assigns(:related_items)).to eq(other_items)
      end

      it 'assigns @user' do
        get :show, { :id => search_item.id }
        expect(assigns(:user)).to eq(user)
      end

      it 'does not assign @bookmarked' do
        get :show, { :id => search_item.id }
        expect(assigns(:bookmarked)).to eq(nil)
      end
    end
  end

  describe "GET #edit" do
    context "when user is logged in" do
      before do
        allow(controller).to receive(:set_current_user).and_return(true)
        allow(controller).to receive(:current_user).and_return(current_user)
        session[:session_token] = current_user.session_token
      end

      context "when the user owns the item" do
        before do
          allow(Item).to receive(:find).and_return(current_user_item)
        end
        it "renders the show template" do
          get :edit, { :id => current_user_item.id }
          expect(response).to render_template(:edit)
        end
      end

      context "when the user does not own the item" do
        before do
          allow(Item).to receive(:find).and_return(other_user_item)
        end
        it "redirects to the home page" do
          get :edit, { :id => other_user_item.id }
          expect(response).to redirect_to(root_path)
        end

        it "sets a flash message" do
          get :edit, { :id => other_user_item.id }
          expect(flash[:error]).to match(/You do not have permission to edit or delete this item/)
        end
      end
    end

    context "when user is logged out" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(nil)
        allow(controller).to receive(:current_user).and_return(nil)
        session[:session_token] = nil
      end
      it "redirects to the login page" do
        get :edit, { :id => current_user_item.id }
        expect(response).to redirect_to(login_path)
      end

      it "sets a flash message" do
        get :edit, { :id => current_user_item.id }
        expect(flash[:error]).to match(/You must be logged in to access this section/)
      end
    end
  end

  describe "GET #update" do
    context "when user is logged in" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(current_user)
        allow(controller).to receive(:current_user).and_return(current_user)
        session[:session_token] = current_user.session_token
        allow(Item).to receive(:find).and_return(other_user_item)
      end

      context "when the user does not own the item" do
        it "redirects to the home page" do
          get :update, { :id => other_user_item.id }
          expect(response).to redirect_to(root_path)
        end

        it "sets a flash message" do
          get :update, { :id => other_user_item.id }
          expect(flash[:error]).to match(/You do not have permission to edit or delete this item/)
        end
      end
    end

    context "when user is logged out" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(nil)
        allow(controller).to receive(:current_user).and_return(nil)
        session[:session_token] = nil
      end
      it "redirects to the login page" do
        get :update, { :id => current_user_item.id }
        expect(response).to redirect_to(login_path)
      end

      it "sets a flash message" do
        get :update, { :id => current_user_item.id }
        expect(flash[:error]).to match(/You must be logged in to access this section/)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is logged in" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(current_user)
        allow(controller).to receive(:current_user).and_return(current_user)
        session[:session_token] = current_user.session_token
      end

      context "when the user does not own the item" do
        it "redirects to the home page" do
          delete :destroy, { :id => other_user_item.id }
          expect(response).to redirect_to(root_path)
        end

        it "sets a flash message" do
          delete :destroy, { :id => other_user_item.id }
          expect(flash[:error]).to match(/You do not have permission to edit or delete this item/)
        end
      end
    end

    context "when user is logged out" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(nil)
        allow(controller).to receive(:current_user).and_return(nil)
        session[:session_token] = nil
      end
      it "redirects to the login page" do
        delete :destroy, { :id => current_user_item.id }
        expect(response).to redirect_to(login_path)
      end

      it "sets a flash message" do
        delete :destroy, { :id => current_user_item.id }
        expect(flash[:error]).to match(/You must be logged in to access this section/)
      end
    end
  end

  describe "#related_items_for" do
    let(:related_items) { [instance_double('Item', :id => 2), instance_double('Item', :id => 3)] }

    before do
      allow(Item).to receive(:where).and_return(related_items)
      allow(related_items).to receive(:where).and_return(related_items)
      allow(related_items).to receive(:not).and_return(related_items)
      allow(related_items).to receive(:limit).and_return(related_items)
      allow(Item).to receive(:find).and_return(item)
    end

    it "returns a list of related items" do
      expect(controller.send(:related_items_for, item)).to eq(related_items)
    end
  end
end
