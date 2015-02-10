require 'rails_helper'

RSpec.describe CategoriesController, type: :routing do
  describe 'カテゴリを管理している画面への接続について' do
    it 'カテゴリの一覧画面に接続できること' do
      expect(get: '/categories').to route_to('categories#index')
    end

    it 'カテゴリの作成画面に接続できないこと' do
      expect(get: '/categories/new').not_to route_to('categories#new')
    end

    it 'カテゴリの詳細画面に接続できること' do
      expect(get: '/categories/1').to route_to('categories#show', id: '1')
    end

    it 'カテゴリの編集画面に接続できること' do
      expect(get: '/categories/1/edit').to route_to('categories#edit', id: '1')
    end

    it 'カテゴリの作成処理に接続できること' do
      expect(post: '/categories').to route_to('categories#create')
    end

    it 'カテゴリの更新処理に接続できること' do
      expect(put: '/categories/1').to route_to('categories#update', id: '1')
    end

    it 'カテゴリの削除処理に接続できること' do
      expect(delete: '/categories/1').to route_to('categories#destroy', id: '1')
    end
  end
end
