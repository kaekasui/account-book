require 'rails_helper'

RSpec.describe NoticeController, type: :controller do
  let(:user) { create(:user, confirmed_at: Time.now) }

  context 'ユーザーがログインしている場合' do
    before do
      sign_in user
    end

    it "ご利用規約が表示できること" do
      get :terms
      expect(response.status).to eq 200
    end

    after do
      sign_out :user
    end
  end

  context 'ユーザーがログインしていない場合' do
    it "ご利用規約が表示できること" do
      get :terms
      expect(response.status).to eq 200
    end
  end
end
