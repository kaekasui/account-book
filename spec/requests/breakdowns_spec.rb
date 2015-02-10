require 'rails_helper'

RSpec.describe 'Breakdowns', type: :request do
  describe 'GET /breakdowns' do
    it 'works! (now write some real specs)' do
      user = create(:user, confirmed_at: Time.now)
      post user_session_path, user: { email: user.email, password: user.password, password_confirmation: user.password }
      # page.driver.post user_session_path, user: { email: user.email, password: user.password, password_confirmation: user.password }

      get breakdowns_path
      expect(response.status).to be(200)
    end
  end
end
