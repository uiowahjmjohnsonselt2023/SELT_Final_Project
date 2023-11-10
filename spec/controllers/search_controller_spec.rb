require 'spec_helper'
require 'rails_helper'
if RUBY_VERSION>='2.6.0'
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

RSpec.describe SearchController, type: :controller do
  before(:each) do
    controller.extend(SessionsHelper)
  end

  describe "Get #index" do
    let(:user){
      User.create!(
        username: 'testuser',
        password: 'password',
        password_confirmation: 'password',
        email: 'test_email@test.com',
        phone_number: '1234567890'
      )
    }
    before do
      controller.log_in(user)
    end

    let(:items){
      [

        user.items.create!(title: "Item 1", price: 1, description: "Description for item 1"),
        user.items.create!(title: "Item 2", price: 2, description: "Description for item 2")
      ]
    }
    context "when user is logged in" do


      it "responds successfully" do
        get :index
        expect(response).to be_successful
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end

      it 'assigns @results' do
        get :index
        expect(assigns(:results)).not_to be_nil
      end

      # Calls Item.search method
      it 'calls Item.search method' do
        expect(Item).to receive(:search)
        get :index
      end

      # Calls Item.search method with search_term and categories
      it 'calls Item.search method with search_term and categories' do
        params = { search_term: 'test', categories: ['1', '2'] }
        expect(Item).to receive(:search).with(params[:search_term], params[:categories])
        get :index, :search_term => 'test', :categories => ['1', '2']
      end

      # To not throw error when no search_term is provided
      it 'does not throw error when no search_term is provided' do
        get :index
        allow(Item).to receive(:search).and_return(items)
        expect(assigns(:results).to_a).to match_array(items)
      end

      # To not throw error when no categories are provided
      it 'does not throw error when no categories are provided' do
        params = { search_term: 'test', categories: [] }
        # Expect to receive search method with search_term and categories and not throw error
        expect(Item).to receive(:search).with(params[:search_term], params[:categories])

        get :index, :search_term => 'test', :categories => []
      end
    end



    end



end



