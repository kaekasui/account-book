require "rails_helper"

RSpec.describe HomeController, type: :routing do
  describe "トップ画面への接続について" do

    it "トップ画面に接続できること" do
      expect(get: "/").to route_to("home#index")
    end
  end
end

