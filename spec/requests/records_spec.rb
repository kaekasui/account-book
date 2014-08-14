require 'rails_helper'

RSpec.describe "Records", type: :request do
  describe "GET /records" do
    it "works! (now write some real specs)" do
      user = create(:user, confirmed_at: Time.now)
      post user_session_path, user: { email: user.email, password: user.password, password_confirmation: user.password }
      get records_path
      expect(response.status).to be(200)
    end
  end
end
