require "rails_helper"

RSpec.describe DashboardsController, type: :routing do
  describe "ダッシュボードへの接続について" do

    it "ダッシュボードに接続できること" do
      expect(get: "/dashboard").to route_to("dashboards#show")
    end
  end
end

