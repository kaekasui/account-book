require 'rails_helper'

RSpec.describe CsvController, type: :routing do
  describe 'CSVの管理画面への接続について' do
    it 'CSVのインポート画面に接続できること' do
      expect(get: '/csv/new').to route_to('csv#new')
    end

    it 'CSVのインポート処理に接続できること' do
      expect(post: 'csv/import').to route_to('csv#import')
    end
  end
end
