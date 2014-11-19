require "rails_helper"

RSpec.describe Admin::FeedbacksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "/admin/feedbacks").to route_to("admin/feedbacks#index")
    end

    it "routes to #new" do
      expect(get: "/admin/feedbacks/new").not_to route_to("admin/feedbacks#new")
    end

    it "routes to #show" do
      expect(get: "/admin/feedbacks/1").not_to route_to("admin/feedbacks#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/admin/feedbacks/1/edit").to route_to("admin/feedbacks#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/admin/feedbacks").not_to route_to("admin/feedbacks#create")
    end

    it "routes to #update" do
      expect(put: "/admin/feedbacks/1").to route_to("admin/feedbacks#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/feedbacks/1").to route_to("admin/feedbacks#destroy", id: "1")
    end

  end
end
