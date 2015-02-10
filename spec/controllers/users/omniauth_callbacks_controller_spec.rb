require 'rails_helper'

describe Users::OmniauthCallbacksController do
  describe 'Twitter連携で' do
    before do
      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
    end

    it 'トップページを表示すること' do
      get :twitter
      expect(response).to redirect_to root_path
    end
  end
end
