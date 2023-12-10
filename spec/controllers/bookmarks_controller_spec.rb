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

describe BookmarksController, type: :controller do
  let(:current_user) { instance_double('User', :session_token => "1") }
  let(:item) { instance_double('Item', :id => 1) }

  before(:each) do
    controller.extend(SessionsHelper)
  end

  describe "POST #create" do
    context "when user is logged in" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(current_user)
        session[:session_token] = current_user.session_token
      end

      context "when the item does not add a bookmark" do
        before do
          allow(Item).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
        end

        it "does not bookmark the item" do
          allow(current_user).to receive(:add_bookmark)
          post :create, { :item_id => 0 }
          expect(current_user).not_to receive(:add_bookmark)
        end

        it "the correct json is rendered" do
          allow(current_user).to receive(:add_bookmark).and_raise(ActiveRecord::RecordNotFound)
          post :create, { :item_id => item.id }
          expect(response.content_type).to eq("application/json")
          expect(response).to have_http_status(:not_found)
          json_response = JSON.parse(response.body)
          expect(json_response["status"]).to eq("not_found")
          expect(json_response["message"]).to eq("Item not found!")
        end
      end

      context "when the item exists and is not already bookmarked" do
        before do
          allow(Item).to receive(:find).and_return(item)
          allow(current_user).to receive(:add_bookmark).and_return(item)
        end

        it "the item is bookmarked" do
          expect(current_user).to receive(:add_bookmark).with("1")
          post :create, { :item_id => item.id }
        end

        it "the correct json is rendered" do
          post :create, { :item_id => item.id }
          expect(response.content_type).to eq("application/json")
          expect(response).to have_http_status(:created)
          json_response = JSON.parse(response.body)
          expect(json_response["status"]).to eq("created")
          expect(json_response["message"]).to eq("Item bookmarked!")
        end
      end

      context "when the item exists and is already bookmarked" do
        before do
          allow(Item).to receive(:find).and_return(item)
          allow(current_user).to receive(:add_bookmark).and_return(nil)
        end

        it "the correct json is rendered" do
          post :create, { :item_id => item.id }
          expect(response.content_type).to eq("application/json")
          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response["status"]).to eq("unprocessable_entity")
          expect(json_response["message"]).to eq("Unable to bookmark item!")
        end
      end
    end

    context "when user is logged out" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(nil)
        allow(controller).to receive(:current_user).and_return(nil)
        session[:session_token] = nil
      end

      it "redirects to the home page" do
        post :create
        expect(response).to redirect_to(root_path)
      end

      it "sets a flash message" do
        post :create
        expect(flash[:error]).to match(/You must be logged in to access this section/)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is logged in" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(current_user)
        session[:session_token] = current_user.session_token
      end

      context "when the item does not exist" do
        before do
          allow(Item).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
        end

        it "does not delete the bookmark" do
          allow(current_user).to receive(:remove_bookmark)
          delete :destroy, { :id => item.id, :item_id => item.id }
          expect(current_user).not_to receive(:remove_bookmark)
        end

        it "the correct json is rendered" do
          allow(current_user).to receive(:remove_bookmark).and_raise(ActiveRecord::RecordNotFound)
          delete :destroy, { :id => item.id, :item_id => item.id }
          expect(response.content_type).to eq("application/json")
          expect(response).to have_http_status(:not_found)
          json_response = JSON.parse(response.body)
          expect(json_response["status"]).to eq("not_found")
          expect(json_response["message"]).to eq("Item not found!")
        end
      end

      context "when the item exists and is bookmarked" do
        before do
          allow(Item).to receive(:find).and_return(item)
          allow(current_user).to receive(:remove_bookmark).and_return(true)
        end

        it "the item is bookmarked" do
          allow(current_user).to receive(:remove_bookmark)
          expect(current_user).to receive(:remove_bookmark).with("1")
          delete :destroy, { :id => item.id, :item_id => item.id }
        end

        it "the correct json is rendered" do
          delete :destroy, { :id => item.id, :item_id => item.id }
          expect(response.content_type).to eq("application/json")
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response["status"]).to eq("removed")
          expect(json_response["message"]).to eq("Bookmark Deleted!")
        end
      end

      context "when the item exists and is already bookmarked" do
        before do
          allow(Item).to receive(:find).and_return(item)
          allow(current_user).to receive(:remove_bookmark).and_return(nil)
        end

        it "the correct json is rendered" do
          delete :destroy, { :id => item.id, :item_id => item.id }
          expect(response.content_type).to eq("application/json")
          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response["status"]).to eq("unprocessable_entity")
          expect(json_response["message"]).to eq("Unable to delete bookmark!")
        end
      end
    end

    context "when user is logged out" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(nil)
        allow(controller).to receive(:current_user).and_return(nil)
        session[:session_token] = nil
      end

      it "redirects to the home page" do
        delete :destroy, { :id => item.id, :item_id => item.id }
        expect(response).to redirect_to(root_path)
      end

      it "sets a flash message" do
        delete :destroy, { :id => item.id, :item_id => item.id }
        expect(flash[:error]).to match(/You must be logged in to access this section/)
      end
    end
  end
end



