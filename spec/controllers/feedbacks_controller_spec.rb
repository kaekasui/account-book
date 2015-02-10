require 'rails_helper'

RSpec.describe FeedbacksController, type: :controller do
  let(:user) { create(:user, confirmed_at: Time.now) }

  context 'ユーザーがログインしている場合' do
    before do
      sign_in user
    end

    describe 'フィードバックの送信' do
      describe '有効な値を入力した場合' do
        it '新しいフィードバックを登録すること' do
          expect do
            post :create, feedback: attributes_for(:feedback, user_id: user.id), format: :js
          end.to change(Feedback, :count).by(1)
        end

        it 'レスポンスのステータスコードが200であること' do
          post :create, feedback: attributes_for(:feedback, user_id: user.id), format: :js
          expect(response.status).to eq(200)
        end
      end

      describe '無効な値を登録した場合' do
        it 'フィードバックを登録しないこと' do
          expect do
            post :create, feedback: attributes_for(:feedback, content: '', user_id: user.id), format: :js
          end.to change(Feedback, :count).by(0)
          expect(assigns(:feedback)).to be_a_new(Feedback)
        end
      end
    end

    after do
      sign_out :user
    end
  end
end
