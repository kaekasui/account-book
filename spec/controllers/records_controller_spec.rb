require 'rails_helper'

RSpec.describe RecordsController, type: :controller do
  let(:user) { create(:user, confirmed_at: Time.now) }
  let(:category) { create(:category, user_id: user.id) }
  let(:breakdown) { create(:breakdown, user_id: user.id, category_id: category.id) }

  context 'ログインしている場合' do
    before do
      sign_in user
    end

    describe "記録一覧画面" do
      it "記録の一覧が表示されること" do
        record = create(:record, category_id: category.id, user_id: user.id, published_at: Date.today)
        get :index
        expect(assigns(:records)).to eq([record])
      end
    end

    describe "記録の詳細画面" do
      it "対象の記録の詳細が表示されること" do
        record = create(:record, category_id: category.id, user_id: user.id)
        get :show, { id: record.id }
        expect(assigns(:record)).to eq(record)
      end
    end

    describe "記録の作成画面" do
      it "記録の作成フォームが表示されること" do
        get :new
        expect(assigns(:record)).to be_a_new(Record)
      end
    end

    describe "記録の編集画面" do
      it "対象の記録の編集フォームが表示されること" do
        record = create(:record, category_id: category.id, user_id: user.id)
        get :edit, { id: record.id }
        expect(assigns(:record)).to eq(record)
      end
    end

    describe "記録の作成" do
      describe "有効な値を入力した場合" do
        it "新しく記録が登録されること" do
          expect {
            post :create, { record: attributes_for(:record, category_id: category.id, user_id: user.id) }
          }.to change(Record, :count).by(1)
        end

        it "新しく登録された記録が登録済みに割り当てられること" do
          post :create, { record: attributes_for(:record, category_id: category.id, user_id: user.id) }
          expect(assigns(:record)).to be_a(Record)
          expect(assigns(:record)).to be_persisted
        end

        it "記録の詳細画面にリダイレクトすること" do
          post :create, { record: attributes_for(:record, category_id: category.id, user_id: user.id) }
          expect(response).to redirect_to(Record.last)
        end
      end

      describe "無効な値を入力した場合" do
        it "新しく記録が登録されないこと" do
          post :create, { record: attributes_for(:record) }
          expect(assigns(:record)).to be_a_new(Record)
        end

        it "記録の入力画面を再表示すること" do
          post :create, { record: attributes_for(:record) }
          expect(response).to render_template("new")
        end
      end
    end

    describe "記録の更新" do
      describe "有効な値を入力した場合" do
        it "記録が更新されないこと" do
          record = create(:record, category_id: category.id, user_id: user.id)
          put :update, { id: record.id, record: attributes_for(:record, charge: 2000, category_id: category.id, user_id: user.id) }
          record.reload
          expect(record.charge).to eq 2000
        end

        it "対象の記録が登録済みになること" do
          record = create(:record, category_id: category.id, user_id: user.id)
          put :update, { id: record.id, record: attributes_for(:record, category_id: category.id, user_id: user.id) }
          expect(assigns(:record)).to eq(record)
        end

        it "対象の記録の詳細画面にリダイレクトすること" do
          record = create(:record, category_id: category.id, user_id: user.id)
          put :update, { id: record.id, record: attributes_for(:record, category_id: category.id, user_id: user.id) }
          expect(response).to redirect_to(record)
        end
      end

      describe "無効な値を入力した場合" do
        it "対象の記録を更新しないこと" do
          record = create(:record, category_id: category.id, user_id: user.id)
          put :update, { id: record.id, record: attributes_for(:record, charge: '') }
          expect(assigns(:record)).to eq(record)
        end

        it "記録の編集画面を再表示すること" do
          record = create(:record, category_id: category.id, user_id: user.id)
          put :update, { id: record.id, record: attributes_for(:record, charge: '') }
          expect(response).to render_template("edit")
        end
      end
    end

    describe "記録の削除" do
      it "対象の記録を削除すること" do
        record = create(:record, category_id: category.id, user_id: user.id)
        expect {
          delete :destroy, { id: record.id }
        }.to change(Record, :count).by(-1)
      end

      it "記録の一覧画面にリダイレクトすること" do
        record = create(:record, category_id: category.id, user_id: user.id)
        delete :destroy, { id: record.id }
        expect(response).to redirect_to(records_url)
      end
    end

    after do
      sign_out :user
    end
  end

  context 'ログインしていない場合' do
    describe "記録の一覧画面" do
      it "ログイン画面にリダイレクトすること" do
        get :index
        expect(response).to redirect_to(user_session_path)
      end
    end

    describe "記録の入力画面" do
      it "ログイン画面にリダイレクトすること" do
        get :new
        expect(response).to redirect_to(user_session_path)
      end
    end

    describe "記録の編集画面" do
      it "ログイン画面にリダイレクトすること" do
        category = create(:category, user_id: user.id)
        get :edit, { id: category.id }
        expect(response).to redirect_to(user_session_path)
      end
    end
  end
end
