# Tests for the home controller and the associated view

require 'spec_helper'

describe HomeController do

  describe "Viewing the home screen" do
    it "should display the home screen" do
      get :index
      response.should render_template("index")
    end
    it "should display the home screen with a list of categories" do
      get :index
      assigns(:categories).should_not be_nil
    end
    it "should display the home screen with a list of suggested items" do
      get :index
      assigns(:suggested_items).should_not be_nil
    end
    it "should have a search bar for searching items" do
      get :index
      response.should have_selector("form#search")
    end
  end

end
