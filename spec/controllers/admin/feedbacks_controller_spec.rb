require 'rails_helper'

RSpec.describe Admin::FeedbacksController, type: :controller do
  let(:user) { create(:user, confirmed_at: Time.now, admin: true) }

  context 'ユーザーがログインしている場合' do
    before do
      sign_in user
    end

    describe "一覧画面" do
      it "フィードバックの一覧が表示されること" do
        feedback = create(:feedback, user_id: user.id)
        get :index
        expect(assigns(:feedbacks)).to eq([feedback])
      end
    end

    after do
      sign_out :user
    end
  end
end
