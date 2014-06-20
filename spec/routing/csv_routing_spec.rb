require "rails_helper"

RSpec.describe CsvController, type: :routing do
  describe "routing" do

    it "routes to #new" do
      expect(:get => "/csv/new").to route_to("csv#new")
    end

    it "routes to #import" do
      expect(:post => "csv/import").to route_to("csv#import")
    end
  end
end

