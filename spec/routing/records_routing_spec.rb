require 'rails_helper'

RSpec.describe RecordsController, type: :routing do
  describe '記録を管理している画面への接続について' do
    it '記録の一覧画面に接続できること' do
      expect(get: '/records').to route_to('records#index')
    end

    it '記録の作成画面に接続できること' do
      expect(get: '/records/new').to route_to('records#new')
    end

    it '記録の詳細画面に接続できること' do
      expect(get: '/records/1').to route_to('records#show', id: '1')
    end

    it '記録の編集画面に接続できること' do
      expect(get: '/records/1/edit').to route_to('records#edit', id: '1')
    end

    it '内訳の作成処理に接続できること' do
      expect(post: '/records').to route_to('records#create')
    end

    it '内訳の更新処理に接続できること' do
      expect(put: '/records/1').to route_to('records#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/records/1').to route_to('records#destroy', id: '1')
    end
  end
end
