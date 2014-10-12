require 'rails_helper'

RSpec.describe "Admin::Feedbacks", type: :request do
  describe "GET /admin_feedbacks" do
    it "works! (now write some real specs)" do
      user = create(:user, confirmed_at: Time.now)
      post user_session_path, user: { email: user.email, password: user.password, password_confirmation: user.password }
      user.admin = true
      user.save
 
      get admin_feedbacks_path
      expect(response).to have_http_status(200)
    end
  end
end
