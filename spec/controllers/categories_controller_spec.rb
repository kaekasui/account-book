require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:user) { create(:user, confirmed_at: Time.now) }

  context 'ユーザーがログインしている場合' do
    before do
      sign_in user
    end

    describe "カテゴリ一覧画面" do
      it "支出のカテゴリが表示されること" do
        category = create(:category, barance_of_payments: 1)
        get :index
        expect(assigns(:categories)).to eq([category])
      end
    end

    describe "カテゴリ編集画面" do
      it "対象のカテゴリを表示すること" do
        category = create(:category)
        get :edit, { id: category.id }
        expect(assigns(:category)).to eq(category)
      end
    end

    describe "カテゴリの登録" do
      describe "有効な値を入力した場合" do
        it "新しいカテゴリを登録すること" do
          expect {
            post :create, { category: attributes_for(:category), format: :js }
          }.to change(Category, :count).by(1)
        end

        it "登録したカテゴリが割り当てられること" do
          post :create, { category: attributes_for(:category), format: :js }
          expect(assigns(:category)).to be_a(Category)
          expect(assigns(:category)).to be_persisted
        end

	it "レスポンスのステータスコードが200であること" do
          post :create, { category: attributes_for(:category), format: :js }
          expect(response.status).to eq(200)
        end 
      end

      describe "無効な値を入力した場合" do
        it "カテゴリを登録しないこと" do
          expect {
            post :create, { category: attributes_for(:category, name: ""), format: :js }
          }.to change(Category, :count).by(0)
          expect(assigns(:category)).to be_a_new(Category)
        end
      end
    end

    describe "カテゴリの更新" do
      describe "有効な値を入力した場合" do
        it "カテゴリを更新すること" do
          category = create(:category)
          put :update, { id: category.id, category: attributes_for(:category, name: "new") }
          category.reload
          expect(category.name).to eq("new")
        end

        it "対象のカテゴリが割り当てられること" do
          category = create(:category)
          put :update, { id: category.id, category: attributes_for(:category, name: "new") }
          expect(assigns(:category)).to eq(category)
        end

        it "カテゴリの一覧画面にリダイレクトすること" do
          category = create(:category)
          put :update, { id: category.id, category: attributes_for(:category, name: "new") }
          expect(response).to redirect_to(categories_path)
        end
      end

      describe "無効な値を入力した場合" do
        it "カテゴリを更新しないこと" do
          category = create(:category)
          put :update, { id: category.id, category: attributes_for(:category, name: "") }
          expect(assigns(:category)).to eq(category)
        end

        it "カテゴリの編集画面を再表示すること" do
          category = create(:category)
          put :update, { id: category.id, category: attributes_for(:category, name: "") }
          expect(response).to render_template("edit")
        end
      end
    end

    describe "カテゴリの削除" do
      it "対象のカテゴリを削除すること" do
        category = create(:category)
        expect {
          delete :destroy, { id: category.id }
        }.to change(Category, :count).by(-1)
      end

      it "カテゴリの一覧画面にリダイレクトすること" do
        category = create(:category)
        delete :destroy, { id: category.id }
        expect(response).to redirect_to(categories_url)
      end
    end

    after do
      sign_out :user
    end
  end

  context 'ログインしていない場合' do
    describe "カテゴリの一覧画面" do
      it "ログイン画面にリダイレクトすること" do
        get :index
        expect(response).to redirect_to(user_session_path)
      end
    end

    describe "カテゴリの編集画面" do
      it "ログイン画面にリダイレクトすること" do
        category = create(:category)
        get :edit, { id: category.id }
        expect(response).to redirect_to(user_session_path)
      end
    end
  end
end
