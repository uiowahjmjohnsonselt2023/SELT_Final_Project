# Tests for the home controller and the associated view

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

describe HomeController, type: :controller do
  render_views # Add this if you want to render views in controller specs

  describe "Viewing the home screen" do
    before do
      get :index
    end

    it "displays the home screen" do
      expect(response).to render_template("index")
    end

    it "displays the home screen with a list of categories" do
      expect(assigns(:categories)).not_to be_nil
    end

    it "displays the home screen with a list of suggested items" do
      expect(assigns(:suggested_items)).not_to be_nil
    end

    # If you want to test the presence of a search bar or navigation bar, you would typically use a feature spec with Capybara.
    # However, if you must test it here, you need to check the response.body contains the expected HTML.
    it "has a search bar for searching items" do
      expect(response.body).to match(/form.*search/)
    end

    it "has a navigation bar" do
      expect(response.body).to match(/div.*navbar/)
    end
  end
end
