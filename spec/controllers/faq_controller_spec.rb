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

describe FaqController, type: :controller do
  let(:current_user) { instance_double('User', :session_token => "1") }
  let(:item) { instance_double('Item', :id=> 1, :user_id => 2) }
  let(:seller) { instance_double('User2', :id => 2) }
  let(:questions_mock) {  [
                         {question: "How do I sign up?", answer: "No"},
                         {question: "Can I sell items on Deal Docks?", answer: "Yes"}] }
  let(:faqs) { instance_double('Faq', :faqs => questions_mock ) }

  before(:each) do
    controller.extend(SessionsHelper)
  end

  describe "GET #show" do
    context "when user is logged in and item isn't nil" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(current_user)
        allow(Faq).to receive(:questions).and_return(questions_mock)
        session[:session_token] = current_user.session_token
      end

      it "redirects to checkout page" do
        allow(User).to receive(:find).and_return(seller)
        get :show
        expect(response).to render_template(:show)
      end

      it "assigns @faq_questions" do
        allow(User).to receive(:find).and_return(seller)
        get :show
        expect(assigns(:faq_questions)).to eq(questions_mock)
      end
    end

    context "when user is not logged in" do
      before do
        allow(User).to receive(:find_by_session_token).and_return(nil)
        session[:session_token] = nil
      end

      it "redirects to the login page" do
        get :show
        expect(response).to render_template(:show)
      end
    end

  end
end



