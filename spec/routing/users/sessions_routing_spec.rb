require 'rails_helper'

RSpec.describe Users::SessionsController, type: :routing do
  describe 'ログイン画面への接続について' do
    it 'ログイン画面に接続できること' do
      expect(get: '/users/sign_in').to route_to('users/sessions#new')
    end

    it 'ログイン処理に接続できること' do
      expect(post: '/users/sign_in').to route_to('users/sessions#create')
    end

    it 'ログアウト処理に接続できること' do
      expect(delete: '/users/sign_out').to route_to('users/sessions#destroy')
    end
  end
end
