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

describe ReviewsController, type: :controller do
  let(:current_user) { instance_double('User', :session_token => "1",  :id => 1) }
  let(:item) { instance_double('Item', :id => 1, :user_id => 1) }
  let(:purchase) { instance_double('Purchase', item: item, user: current_user, reviewed?: false) }
  let(:review_params) do
    {
      title: 'Great product',
      rating: 5,
      content: 'Loved it!',
      reviewer_id: current_user.id,
      seller_id: 2,  # Assuming seller is a different user
      item_id: item.id
    }
  end
  let(:review){ instance_double('Review', :id => 1, :item_id => 1, :purchase => purchase) }




  before(:each) do
    controller.extend(SessionsHelper)
    allow(controller).to receive(:correct_user_for_purchase).and_return(true)
  end

  describe 'POST #create' do
    context 'when a valid review is created' do
      before do
        allow(controller).to receive(:correct_purchase_create).and_return(true)
        allow(User).to receive(:find_by_session_token).and_return(current_user)
        session[:session_token] = current_user.session_token
        allow(controller).to receive(:current_user).and_return(current_user)
        allow_any_instance_of(Review).to receive(:purchase=).and_return(true)

      end

      it 'creates a new review and redirects to item page with a success message' do
        allow(controller).to receive(:correct_purchase_create).and_return(true)
        allow(controller).to receive(:correct_user).and_return(true)
        allow(Purchase).to receive(:find_by).with(item_id: "1", user: current_user).and_return(purchase)
        post :create,  :review => review_params
        expect(response).to redirect_to(item_path(item.id))
        expect(flash[:notice]).to match(/Review was saved/)
      end



    end

    context 'when user has already reviewed the item' do
      before do
        allow(purchase).to receive(:reviewed?).and_return(true)
        allow(Purchase).to receive(:find_by).with(item_id: item.id, user: current_user).and_return(purchase)
        allow(User).to receive(:find_by_session_token).and_return(current_user)
        session[:session_token] = current_user.session_token
        allow(controller).to receive(:current_user).and_return(current_user)
        allow_any_instance_of(Review).to receive(:purchase=).and_return(true)
      end

      it 'Does not create a new review when it has already been reviewed' do
        allow(controller).to receive(:correct_purchase_create).and_return(false)
        allow(controller).to receive(:correct_user).and_return(true)
        allow(Purchase).to receive(:find_by).with(item_id: "1", user: current_user).and_return(purchase)
        allow(purchase).to receive(:reviewed?).and_return(true)
        post :create, { review: review_params }
        expect(response).to redirect_to(item_path(item.id))
        expect(flash[:alert]).to match(/You have already reviewed this item or the purchase does not exist/)
      end
    end

    context "the review is not successfully saved" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(current_user)
        session[:session_token] = current_user.session_token
        allow(controller).to receive(:current_user).and_return(current_user)
        allow_any_instance_of(Review).to receive(:purchase=).and_return(true)
      end

      it 'creates a new review and redirects to item page with a success message' do
        allow(controller).to receive(:correct_purchase_create).and_return(true)
        allow(controller).to receive(:correct_user).and_return(true)
        allow(Purchase).to receive(:find_by).with(item_id: "1", user: current_user).and_return(purchase)
        allow_any_instance_of(Review).to receive(:save).and_return(false)
        post :create,  :review => review_params
        expect(response).to redirect_to(item_path(item.id))
        expect(flash[:error]).to match(/Review could not be saved/)

      end

    end

  end

  describe 'DELETE #destroy' do
    before do
      allow(controller).to receive(:correct_purchase_destroy).and_return(true)
      allow(User).to receive(:find_by_session_token).and_return(current_user)
      session[:session_token] = current_user.session_token
      allow(controller).to receive(:current_user).and_return(current_user)
    end

    context 'when the review is successfully deleted' do
      before do
        allow(controller).to receive(:correct_purchase_destroy).and_return(true)
        allow(controller).to receive(:correct_user).and_return(true)
      end

      it 'deletes the review and redirects to user page with a success message' do
        #allow(controller).to receive(:find_review).and_return(review)
        expect(Review).to receive(:find).with("1")
        allow(Review).to receive(:find).with("1").and_return(review)
        allow(review).to receive(:destroy).and_return(true)

        allow(review).to receive(:purchase).and_return(purchase)
        allow(purchase).to receive(:update).and_return(true)


        allow(review).to receive(:destroy).and_return(true)
        delete :destroy, :id => 1, :item_id => 1

        expect(response).to redirect_to(user_path(current_user))
        expect(flash[:notice]).to match(/Review deleted successfully/)
      end
    end

    context 'when the review is not successfully deleted' do
      before do
        allow(controller).to receive(:correct_purchase_destroy).and_return(true)
        allow(controller).to receive(:correct_user).and_return(true)
      end

      it 'deletes the review and redirects to user page with a success message' do
        #allow(controller).to receive(:find_review).and_return(review)
        expect(Review).to receive(:find).with("1")
        allow(Review).to receive(:find).with("1").and_return(review)
        allow(review).to receive(:destroy).and_return(false)

        delete :destroy, :id => 1, :item_id => 1

        expect(response).to redirect_to(user_path(current_user))
        expect(flash[:error]).to match(/Review could not be deleted/)
      end
    end


  end

  describe 'find_review' do
    before do
      allow(controller).to receive(:correct_purchase_destroy).and_return(true)
      allow(controller).to receive(:correct_user).and_return(true)
      allow(User).to receive(:find_by_session_token).and_return(current_user)
      session[:session_token] = current_user.session_token
      allow(controller).to receive(:current_user).and_return(current_user)
    end

    it 'deletes the review and redirects to user page with a success message' do
      #allow(controller).to receive(:find_review).and_return(review)
      allow(Review).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
      allow(review).to receive(:destroy).and_return(false)

      delete :destroy, :id => 1, :item_id => 1

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match("Review not found")
    end

    it 'redirects to root path if review is not found' do
      allow(Review).to receive(:find).and_return(nil)
      delete :destroy, :id => 1, :item_id => 1
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match("Review not found")
    end

    it 'redirects to root path if the review is not the users' do
      allow(Review).to receive(:find).and_return(review)
      allow(review).to receive(:purchase).and_return(purchase)
      allow(purchase).to receive(:user).and_return(instance_double('User', :id => 2))
      delete :destroy, :id => 1, :item_id => 1
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match("You do not have permission to edit or delete this item.")
    end
  end

  describe 'correct_purchase_create' do
    before do
      allow(controller).to receive(:correct_purchase_destroy).and_return(true)
      allow(controller).to receive(:correct_user).and_return(true)
      allow(User).to receive(:find_by_session_token).and_return(current_user)
      session[:session_token] = current_user.session_token
      allow(controller).to receive(:current_user).and_return(current_user)
    end

    it 'catches ActiveRecord::RecordNotFound and redirects to root path' do
      allow(Purchase).to receive(:find_by).and_raise(ActiveRecord::RecordNotFound)
      post :create, :review => review_params
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match("You do not have permission to review this item")
    end

    it 'redirects to root path if purchase is not found' do
      allow(Purchase).to receive(:find_by).and_return(nil)
      post :create, :review => review_params
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match("You do not have permission to review this item")
    end

    it 'redirects to root path if purchase is already reviewed' do
      allow(Purchase).to receive(:find_by).and_return(purchase)
      allow(purchase).to receive(:reviewed?).and_return(true)
      post :create, :review => review_params
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match("You have already reviewed this item.")
    end
  end

  describe 'correct_purchase_destroy' do
    before do
      allow(controller).to receive(:correct_purchase_create).and_return(true)
      allow(controller).to receive(:correct_user).and_return(true)
      allow(User).to receive(:find_by_session_token).and_return(current_user)
      session[:session_token] = current_user.session_token
      allow(controller).to receive(:current_user).and_return(current_user)
    end

    it 'catches ActiveRecord::RecordNotFound and redirects to root path' do
      allow(Purchase).to receive(:find_by).and_raise(ActiveRecord::RecordNotFound)
      delete :destroy, :id => 1, :item_id => 1
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match("You do not have permission to review this item.")
    end

    it 'redirects to root path if purchase is not found' do
      allow(Purchase).to receive(:find_by).and_return(nil)
      delete :destroy, :id => 1, :item_id => 1
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match("You do not have permission to review this item.")
    end

    it 'redirects to root path if purchase is not reviewed' do
      allow(Purchase).to receive(:find_by).and_return(purchase)
      allow(purchase).to receive(:reviewed?).and_return(false)
      delete :destroy, :id => 1, :item_id => 1
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match("You have not yet reviewed this item.")
    end
  end

end
