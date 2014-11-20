require "rails_helper"

RSpec.describe Admin::AnswersController, type: :routing do
  describe "フィードバックへの回答画面（管理）への接続について" do

    it "フィードバックへの回答一覧へ接続できないこと" do
      expect(get: "/admin/feedbacks/1/answers").not_to route_to("admin/answers#index")
    end

    it "フィードバックへの回答一覧の作成画面へ接続できること" do
      expect(get: "/admin/feedbacks/1/answers/new").to route_to("admin/answers#new", feedback_id: "1")
    end

    it "フィードバックへの回答詳細画面へ接続できないこと" do
      expect(get: "/admin/feedbacks/1/answers/1").not_to route_to("admin/answers#show", id: "1", feedback_id: "1")
    end

    it "フィードバックへの回答編集画面へ接続できること" do
      expect(get: "/admin/feedbacks/1/answers/1/edit").to route_to("admin/answers#edit", feedback_id: "1", id: "1")
    end

    it "フィードバックへの回答作成の処理へ接続できること" do
      expect(post: "/admin/feedbacks/1/answers").to route_to("admin/answers#create", feedback_id: "1")
    end

    it "フィードバックへの回答更新の処理へ接続できること" do
      expect(put: "/admin/feedbacks/1/answers/1").to route_to("admin/answers#update", feedback_id: "1", id: "1")
    end

    it "フィードバックへの回答削除の処理へ接続できること" do
      expect(delete: "/admin/feedbacks/1/answers/1").to route_to("admin/answers#destroy", feedback_id: "1", id: "1")
    end

  end
end
