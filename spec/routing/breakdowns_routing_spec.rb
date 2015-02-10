require 'rails_helper'

RSpec.describe BreakdownsController, type: :routing do
  describe '内訳を管理している画面への接続について' do
    it '内訳の一覧画面に接続できること' do
      expect(get: '/breakdowns').to route_to('breakdowns#index')
    end

    it '内訳の作成画面に接続できないこと' do
      expect(get: '/breakdowns/new').not_to route_to('breakdowns#new')
    end

    it '内訳の詳細画面に接続できないこと' do
      expect(get: '/breakdowns/1').not_to route_to('breakdowns#show', id: '1')
    end

    it '内訳の編集画面に接続できること' do
      expect(get: '/breakdowns/1/edit').to route_to('breakdowns#edit', id: '1')
    end

    it '内訳の作成処理に接続できること' do
      expect(post: '/breakdowns').to route_to('breakdowns#create')
    end

    it '内訳の更新処理に接続できること' do
      expect(put: '/breakdowns/1').to route_to('breakdowns#update', id: '1')
    end

    it '内訳の削除処理に接続できること' do
      expect(delete: '/breakdowns/1').to route_to('breakdowns#destroy', id: '1')
    end
  end
end
