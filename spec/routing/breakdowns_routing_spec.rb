require "rails_helper"

RSpec.describe BreakdownsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/breakdowns").to route_to("breakdowns#index")
    end

    it "routes to #new" do
      expect(:get => "/breakdowns/new").not_to route_to("breakdowns#new")
    end

    it "routes to #show" do
      expect(:get => "/breakdowns/1").not_to route_to("breakdowns#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/breakdowns/1/edit").to route_to("breakdowns#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/breakdowns").to route_to("breakdowns#create")
    end

    it "routes to #update" do
      expect(:put => "/breakdowns/1").to route_to("breakdowns#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/breakdowns/1").to route_to("breakdowns#destroy", :id => "1")
    end

  end
end
