require 'rails_helper'

RSpec.describe Admin::AnswersController, type: :controller do
  let(:user) { create(:user, confirmed_at: Time.now, admin: true) }
  let(:feedback) { create(:feedback, user_id: user.id) }

  context 'ユーザーがログインしている場合' do
    before do
      sign_in user
    end

    describe "フィードバックの返信画面" do
      it "フィードバックの返信フォームが表示されること" do
        get :new, { feedback_id: feedback.id }
        expect(assigns(:answer)).to be_a_new(Answer)
      end
    end

    describe 'フィードバックの返信' do
      context '有効な値が登録された場合' do
        it 'フィードバックの返信が登録されること' do
          expect { post :create, { answer: attributes_for(:answer, feedback_id: feedback.id, user_id: user.id), feedback_id: feedback.id }}.to change(Answer, :count).by(1)
        end

        it 'フィードバックの詳細画面が表示されること' do
          post :create, { answer: attributes_for(:answer, feedback_id: feedback.id, user_id: user.id), feedback_id: feedback.id }
          expect(response).to redirect_to admin_feedback_path(id: feedback.id)
        end
      end

      context '無効な値が登録された場合' do
        it 'フィードバックの返信が登録されないこと' do
          expect { post :create, { answer: attributes_for(:answer, feedback_id: feedback.id, user_id: user.id, content: ""), feedback_id: feedback.id }}.to change(Answer, :count).by(0)
        end

        it 'フィードバックの返信画面が再表示されること' do
          post :create, { answer: attributes_for(:answer, feedback_id: feedback.id, user_id: user.id, content: ""), feedback_id: feedback.id }
          expect(response).to render_template :new
        end
      end
    end

    describe 'フィードバックの返信編集画面' do
      it 'フィードバックの返信フォームが表示されること' do
        answer = create(:answer, feedback_id: feedback.id, user_id: user.id)
        get :edit, { feedback_id: feedback.id, id: answer.id }
        expect(assigns(:answer)).to eq answer
      end
    end

    describe 'フィードバックの返信編集' do
      context '有効な値が登録された場合' do
        it 'フィードバックの返信が変更されること' do
          answer = create(:answer, feedback_id: feedback.id, user_id: user.id, content: "Content1")
          post :update, { answer: attributes_for(:answer, feedback_id: feedback.id, user_id: user.id, content: "Content2"), feedback_id: feedback.id, id: answer.id }
          expect(Answer.last.content).to eq "Content2"
        end

        it 'フィードバックの詳細画面が表示されること' do
          answer = create(:answer, feedback_id: feedback.id, user_id: user.id)
          post :update, { answer: attributes_for(:answer, feedback_id: feedback.id, user_id: user.id), feedback_id: feedback.id, id: answer.id }
          expect(response).to redirect_to admin_feedback_path(id: feedback.id)
        end
      end

      context '無効な値が登録された場合' do
        it 'フィードバックの返信が変更されないこと' do
          answer = create(:answer, feedback_id: feedback.id, user_id: user.id, content: "Content1")
          post :update, { answer: attributes_for(:answer, feedback_id: feedback.id, user_id: user.id, content: ""), feedback_id: feedback.id, id: answer.id }
          expect(Answer.last.content).to eq "Content1"
        end

        it 'フィードバックの返信編集画面が再表示されること' do
          answer = create(:answer, feedback_id: feedback.id, user_id: user.id)
          post :update, { answer: attributes_for(:answer, feedback_id: feedback.id, user_id: user.id, content: ""), feedback_id: feedback.id, id: answer.id }
          expect(response).to render_template :new #TODO change to :edit.
        end
      end

      describe 'フィードバックの返信削除' do
        it 'フィードバックの返信が削除されること' do
          answer = create(:answer, feedback_id: feedback.id, user_id: user.id)
          delete :destroy, { feedback_id: feedback.id, id: answer.id }
          expect(response).to redirect_to admin_feedback_path(id: feedback.id)
        end
      end
    end

    after do 
      sign_out :user
    end
  end

  context 'ユーザーがログインしていない場合' do
    describe 'フィードバックの返信画面' do
      it 'ログイン画面が表示されること' do
        get :new, { feedback_id: feedback.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'フィードバックの返信編集画面' do
      it 'ログイン画面が表示されること' do
        answer = create(:answer, feedback_id: feedback.id, user_id: user.id)
        get :edit, { feedback_id: feedback.id, id: answer.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
