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

RSpec.describe BookmarksController, type: :controller do

  let(:current_user) {
    User.create!(
      username: 'current_user',
      password: 'current_user_password',
      password_confirmation: 'current_user_password',
      email: 'current_user_email@test.com',
      phone_number: '1234567890'
    )
  }
  let(:item) {
    Item.create!(
      title: 'Test Item',
      description: 'Test Description',
      price: 10.00,
      user_id: current_user.id
    )
  }
  before(:each) do
    controller.extend(SessionsHelper)
    controller.log_in current_user
  end

  describe "Add a bookmark" do
    it "should add a bookmark" do
      current_user.bookmarked_items << item
      expect(current_user.bookmarked_items).to include(item)
    end
  end

  describe "POST #create" do
    it "creates a new bookmark" do
      expect {
        post :create, item_id: item.id
      }.to change(current_user.bookmarked_items, :count).by(1)
    end
  end

  describe "DELETE #destroy" do
    before { current_user.bookmarked_items << item }
    it "destroys the requested bookmark" do
      expect {
        delete :destroy, id: item.id, item_id: item.id
      }.to change(current_user.bookmarked_items, :count).by(-1)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new bookmark and returns a success response" do
        expect {
          post :create, item_id: item.id, xhr: true
        }.to change(current_user.bookmarked_items, :count).by(1)

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Item bookmarked!")
      end
    end

    context "with invalid params" do
      it "does not create a bookmark and returns an error response" do
        # Assuming `item_id` is invalid, adjust this as per your application's logic
        expect {
          post :create, item_id: nil , xhr: true
        }.not_to change(Bookmark, :count)

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Item not found!")
      end
    end
  end

  describe "DELETE #destroy" do
    context "when the bookmark exists" do
      before { current_user.bookmarked_items << item }

      it "destroys the requested bookmark" do
        expect {
          delete :destroy, id: item.id, item_id: item.id
        }.to change(current_user.bookmarked_items, :count).by(-1)

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Bookmark Deleted!")
      end
    end

    context "when the bookmark does not exist" do
      it "does not destroy a bookmark and returns an error response" do
        expect {
          delete :destroy, id: item.id, item_id: item.id
        }.not_to change(Bookmark, :count)

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Unable to delete bookmark!")
      end
    end
  end

  describe "Error handling when adding and deleting bookmarks" do
    context "when the item does not exist" do
      it "does not create a bookmark and returns an error response" do
        expect {
          post :create, item_id: 0, xhr: true
        }.not_to change(Bookmark, :count)

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Item not found!")
      end

      it "does not destroy a bookmark and returns an error response" do
        expect {
          delete :destroy, id: 0, item_id: 0
        }.not_to change(Bookmark, :count)

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Item not found!")
      end
    end
    context "when the model methods do not work" do
      it "does not create a bookmark and returns an error response" do
        allow_any_instance_of(User).to receive(:add_bookmark).and_return(false)
        expect {
          post :create, item_id: item.id, xhr: true
        }.not_to change(Bookmark, :count)

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Unable to bookmark item!")
      end
      it "does not destroy a bookmark and returns an error response" do
        allow_any_instance_of(User).to receive(:remove_bookmark).and_return(false)
        expect {
          delete :destroy, id: item.id, item_id: item.id
        }.not_to change(Bookmark, :count)

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Unable to delete bookmark!")
      end
    end

  end
end



