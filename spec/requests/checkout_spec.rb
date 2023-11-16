require 'rails_helper'

RSpec.describe "Checkouts", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/checkout/show"
      expect(response).to have_http_status(:success)
    end
  end

end
