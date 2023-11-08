require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:item) { create(:item, user: user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "responds successfully" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "responds successfully" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new item" do
        expect {
          post :create, params: { item: attributes_for(:item) }
        }.to change(Item, :count).by(1)
      end
    end

    context "with invalid attributes" do
      it "does not create a new item" do
        expect {
          post :create, params: { item: attributes_for(:item, invalid_attribute: nil) }
        }.not_to change(Item, :count)
      end
    end
  end

  describe "GET #show" do
    it "responds successfully with an HTTP 200 status code" do
      get :show, params: { id: item.id }
      expect(response).to have_http_status(200)
      expect(assigns(:item)).to eq(item)
      expect(assigns(:related_items)).to eq(item.user.items.where.not(id: item.id).limit(4))
      expect(assigns(:user)).to eq(item.user)
    end
  end

  describe "GET #edit" do
    context "when user is correct" do
      it "responds successfully" do
        get :edit, params: { id: item.id }
        expect(response).to be_successful
      end
    end

    context "when user is not correct" do
      it "redirects to root" do
        wrong_user = create(:user)
        sign_in wrong_user
        get :edit, params: { id: item.id }
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      it "updates the item" do
        put :update, params: { id: item.id, item: { name: "New Item Name" } }
        item.reload
        expect(item.name).to eq("New Item Name")
      end
    end

    context "with invalid attributes" do
      it "does not update the item" do
        put :update, params: { id: item.id, item: { name: nil } }
        item.reload
        expect(item.name).not_to eq(nil)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the item" do
      delete :destroy, params: { id: item.id }
      expect(Item.exists?(item.id)).to be(false)
    end
  end
end
