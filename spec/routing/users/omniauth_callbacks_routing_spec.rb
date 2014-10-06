require "rails_helper"

RSpec.describe Users::SessionsController, type: :routing do
  describe "Twitter連携について" do
    it "Twitter認証画面に接続できること" do
      expect(get: "/users/auth/twitter").to route_to("users/omniauth_callbacks#passthru", provider: 'twitter')
    end

    it "認証完了後の画面に接続できること" do
      expect(get: "/users/auth/twitter/callback").to route_to("users/omniauth_callbacks#twitter")
    end
  end
end
