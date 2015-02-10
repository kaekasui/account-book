require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :routing do
  describe 'アカウント管理画面への接続について' do
    it 'アカウントの新規登録画面に接続できること' do
      expect(get: '/users/sign_up').to route_to('users/registrations#new')
    end

    it 'アカウントの新規登録処理に接続できること' do
      expect(post: '/users').to route_to('users/registrations#create')
    end

    it 'アカウントの編集画面に接続できること' do
      expect(get: '/users/edit').to route_to('users/registrations#edit')
    end

    it 'アカウントの更新処理に接続できること' do
      expect(put: '/users').to route_to('users/registrations#update')
    end

    it 'アカウントの削除処理に接続できること' do
      expect(delete: '/users').to route_to('users/registrations#destroy')
    end
  end
end
