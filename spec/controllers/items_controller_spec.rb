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
      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context "when user is logged out" do
      it "redirects to the login page" do
        get :new
        expect(response).to redirect_to(login_path)
      end

      it "sets a flash message" do
        get :show
        expect(flash[:error]).to match(/You must be logged in to access this section/)
      end
    end
  end

  describe "POST #create" do
    context "when user is logged out" do
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
    let(:user) {
      User.create!(
        username: 'test_user',
        password: 'test_password',
        password_confirmation: 'test_password',
        email: 'test_email@test.com',
        phone_number: '1234567890'
      )
    }

    let(:search_item) {
      user.items.create!(title: "Item 1", description: "Description for item 1", price: 1.00)
    }

    let(:other_items) {
      [
        user.items.create!(title: "Item 2", description: "Description for item 2", price: 2.00),
        user.items.create!(title: "Item 3", description: "Description for item 3", price: 3.00),
        user.items.create!(title: "Item 4", description: "Description for item 4", price: 4.00),
      ]
    }
    context "when user is logged in" do
      before do
        controller.log_in(current_user)
        allow(Item).to receive(:find).and_return(search_item)
        allow(search_item).to receive(:find_related_items).and_return(other_items)
        allow(User).to receive(:find).and_return(user)
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
    end

    context "when user is logged out" do
      it "redirects to the login page" do
        get :show
        expect(response).to redirect_to(login_path)
      end

      it "sets a flash message" do
        get :show
        expect(flash[:error]).to match(/You must be logged in to access this section/)
      end

      it 'does not assign @item' do
        get :show, { :id => search_item.id }
        expect(assigns(:item)).to be_nil
      end

      it 'does not assign @related_items' do
        get :show, { :id => search_item.id }
        expect(assigns(:related_items)).to be_nil
      end

      it 'does not assign @user' do
        get :show, { :id => search_item.id }
        expect(assigns(:user)).to be_nil
      end
    end
  end

  describe "GET #edit" do
    let(:other_user) {
      User.create!(
        username: 'test_user',
        password: 'test_password',
        password_confirmation: 'test_password',
        email: 'test_email@test.com',
        phone_number: '1234567890'
      )
    }

    let(:current_user_item) {
      current_user.items.create!(title: "Item 1", description: "Description for item 1", price: 1.00)
    }

    let(:other_user_item) {
      other_user.items.create!(title: "Item 4", description: "Description for item 4", price: 4.00)
    }
    context "when user is logged in" do
      before do
        controller.log_in(current_user)
      end

      context "when the user owns the item" do
        it "renders the show template" do
          get :edit, { :id => current_user_item.id }
          expect(response).to render_template(:edit)
        end
      end

      context "when the user does not own the item" do
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

  describe "get #update" do
    let(:other_user) {
      User.create!(
        username: 'test_user',
        password: 'test_password',
        password_confirmation: 'test_password',
        email: 'test_email@test.com',
        phone_number: '1234567890'
      )
    }

    let(:current_user_item) {
      current_user.items.create!(title: "Item 1", description: "Description for item 1", price: 1.00)
    }

    let(:other_user_item) {
      other_user.items.create!(title: "Item 4", description: "Description for item 4", price: 4.00)
    }
    context "when user is logged in" do
      before do
        controller.log_in(current_user)
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
end
