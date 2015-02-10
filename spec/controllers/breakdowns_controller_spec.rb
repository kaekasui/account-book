require 'rails_helper'

RSpec.describe BreakdownsController, type: :controller do
  let(:user) { create(:user, confirmed_at: Time.now) }
  let(:category) { create(:category, user_id: user.id) }

  context 'ログインしてる場合' do
    before do
      sign_in user
    end

    describe '内訳の一覧画面' do
      it '内訳が一覧で表示されること' do
        breakdown = create(:breakdown, user_id: user.id, category_id: category.id)
        get :index
        expect(assigns(:breakdowns)).to eq([breakdown])
      end
    end

    describe '内訳の編集画面' do
      it '対象の内訳が表示されること' do
        breakdown = create(:breakdown, user_id: user.id, category_id: category.id)
        get :edit, id: breakdown.id
        expect(assigns(:breakdown)).to eq(breakdown)
      end
    end

    describe '内訳の作成' do
      describe '有効な値を入力した場合' do
        it '新しく内訳が登録されること' do
          expect do
            post :create, breakdown: attributes_for(:breakdown, category_id: category.id), format: :js
          end.to change(Breakdown, :count).by(1)
        end

        it '対象の内訳が表示されること' do
          post :create, breakdown: attributes_for(:breakdown, category_id: category.id), format: :js
          expect(assigns(:breakdown)).to be_a(Breakdown)
          expect(assigns(:breakdown)).to be_persisted
        end

        it 'レスポンスのステータスコードが200になること' do
          post :create, breakdown: attributes_for(:breakdown, category_id: category.id), format: :js
          expect(response.status).to eq 200
        end
      end

      describe '無効な値が入力された場合' do
        it '内訳が登録されないこと' do
          post :create, breakdown: attributes_for(:breakdown, name: '', user_id: user.id, category_id: category.id), format: :js
          expect(assigns(:breakdown)).to be_a_new(Breakdown)
          expect do
            post :create, breakdown: attributes_for(:breakdown, name: '', category_id: category.id), format: :js
          end.to change(Breakdown, :count).by(0)
        end
      end
    end

    describe '内訳の更新' do
      describe '有効な値が入力された場合' do
        it '対象の内訳が更新されること' do
          breakdown = create(:breakdown, user_id: user.id, category_id: category.id)
          put :update, id: breakdown.id, breakdown: attributes_for(:breakdown, name: 'new', category_id: category.id)
          breakdown.reload
          expect(breakdown.name).to eq 'new'
        end

        it '対象の内訳が表示されること' do
          breakdown = create(:breakdown, user_id: user.id, category_id: category.id)
          put :update, id: breakdown.id, breakdown: attributes_for(:breakdown, name: 'new', category_id: category.id)
          expect(assigns(:breakdown)).to eq(breakdown)
        end

        it '内訳の一覧画面にリダイレクトすること' do
          breakdown = create(:breakdown, user_id: user.id, category_id: category.id)
          put :update, id: breakdown.id, breakdown: attributes_for(:breakdown, name: 'new', category_id: category.id)
          expect(response).to redirect_to(breakdowns_path)
        end
      end

      describe '無効な値を入力した場合' do
        it '対象の内訳が割り当てられたままであること' do
          breakdown = create(:breakdown, user_id: user.id, category_id: category.id)
          put :update, id: breakdown.id, breakdown: attributes_for(:breakdown, name: '', user_id: user.id, category_id: category.id)
          expect(assigns(:breakdown)).to eq(breakdown)
        end

        it '内訳の編集画面を再表示すること' do
          breakdown = create(:breakdown, user_id: user.id, category_id: category.id)
          put :update, id: breakdown.id, breakdown: attributes_for(:breakdown, name: '', user_id: user.id, category_id: category.id)
          expect(response).to render_template('edit')
        end
      end
    end

    describe '内訳の削除' do
      it '対象の内訳が削除されること' do
        breakdown = create(:breakdown, user_id: user.id, category_id: category.id)
        expect do
          delete :destroy, id: breakdown.id
        end.to change(Breakdown, :count).by(-1)
      end

      it '内訳の一覧画面にリダイレクトすること' do
        breakdown = create(:breakdown, user_id: user.id, category_id: category.id)
        delete :destroy, id: breakdown.id
        expect(response).to redirect_to(breakdowns_url)
      end
    end

    after do
      sign_out :user
    end
  end

  context 'ログインしていない場合' do
    describe '内訳の一覧画面' do
      it 'ログイン画面にリダイレクトすること' do
        get :index
        expect(response).to redirect_to(user_session_path)
      end
    end

    describe '内訳の編集画面' do
      it 'ログイン画面にリダイレクトすること' do
        category = create(:category, user_id: user.id)
        get :edit, id: category.id
        expect(response).to redirect_to(user_session_path)
      end
    end
  end
end
