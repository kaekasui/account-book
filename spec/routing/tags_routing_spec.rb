require "rails_helper"

RSpec.describe TagsController, type: :routing do
  describe "routing" do

    it "ラベルの一覧画面に接続できること" do
      expect(get: "/tags").to route_to("tags#index")
    end

    it "ラベルの新規作成画面に接続できないこと" do
      expect(get: "/tags/new").not_to route_to("tags#new")
    end

    it "ラベルの詳細画面に接続できないこと" do
      expect(get: "/tags/1").not_to route_to("tags#show", id: "1")
    end

    it "ラベルの編集画面に接続できなこと" do
      expect(get: "/tags/1/edit").not_to route_to("tags#edit", id: "1")
    end

    it "ラベルの新規登録処理に接続できること" do
      expect(post: "/tags").to route_to("tags#create")
    end

    it "ラベルの更新処理に接続できること" do
      expect(put: "/tags/1").to route_to("tags#update", id: "1")
    end

    it "ラベルの削除処理に接続できること" do
      expect(delete: "/tags/1").to route_to("tags#destroy", id: "1")
    end

    it "カラーコードのテキストボックス設置処理に接続できること" do
      expect(post: "/tags/set_color_code_text_field").to route_to("tags#set_color_code_text_field")
    end

    it "ラベル名のテキストボックス設置処理に接続できること" do
      expect(post: "/tags/set_name_text_field").to route_to("tags#set_name_text_field")
    end
  end
end
