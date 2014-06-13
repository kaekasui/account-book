require 'rails_helper'

RSpec.describe "Breakdowns", type: :request do
  describe "GET /breakdowns" do
    it "works! (now write some real specs)" do
      get breakdowns_path
      expect(response.status).to be(200)
    end
  end
end
