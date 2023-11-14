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
    it "destroys the requested bookmark" do
      Bookmark.create!(user: current_user, item: item)
      expect {
        delete :destroy, params: { item_id: item.id }
      }.to change(current_user, :count).by(-1)
    end
  end

  describe "GET #show" do
    it "should show the bookmarks" do
      get :show
      expect(response).to render_template(:show)
    end
  end

end
