require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  let(:user) { create(:user, confirmed_at: Time.now) }

  context 'ユーザーがログインしている場合' do
    before do
      sign_in user
    end

    describe "ラベル一覧画面" do
      it "ラベルが一覧で表示されること" do
        tag = create(:tag, user_id: user.id)
        get :index
        expect(assigns(:tags)).to eq([tag])
      end
    end

    describe "ラベルの登録" do
      describe "有効な値を入力した場合" do
        it "新しいラベルを登録すること" do
          expect {
            post :create, { tag: attributes_for(:tag, user_id: user.id), format: :js }
          }.to change(Tag, :count).by(1)
        end

        it "登録したラベルが割り当てられること" do
          post :create, { tag: attributes_for(:tag, user_id: user.id), format: :js }
          expect(assigns(:tag)).to be_a(Tag)
          expect(assigns(:tag)).to be_persisted
        end

	it "レスポンスのステータスコードが200であること" do
          post :create, { tag: attributes_for(:tag, user_id: user.id), format: :js }
          expect(response.status).to eq(200)
        end 
      end

      describe "無効な値を入力した場合" do
        it "ラベルを登録しないこと" do
          expect {
            post :create, { tag: attributes_for(:tag, name: "", user_id: user.id), format: :js }
          }.to change(Tag, :count).by(0)
          expect(assigns(:tag)).to be_a_new(Tag)
        end
      end
    end

    describe "ラベルの更新" do
      describe "有効な値を入力した場合" do
        it "ラベルを更新すること" do
          tag = create(:tag, user_id: user.id)
          put :update, { id: tag.id, tag: attributes_for(:tag, name: "new"), format: :js }
          tag.reload
          expect(tag.name).to eq("new")
        end

        it "対象のラベルが割り当てられること" do
          tag = create(:tag, user_id: user.id)
          put :update, { id: tag.id, tag: attributes_for(:tag, name: "new"), format: :js }
          expect(assigns(:tag)).to eq(tag)
        end
      end

      describe "無効な値を入力した場合" do
        it "ラベルを更新しないこと" do
          tag = create(:tag, user_id: user.id)
          put :update, { id: tag.id, tag: attributes_for(:tag, name: ""), format: :js }
          expect(assigns(:tag)).to eq(tag)
        end
      end
    end
 
    describe "ラベルの削除" do
      it "対象のラベルを削除すること" do
        tag = create(:tag, user_id: user.id)
        expect {
          delete :destroy, { id: tag.id }
        }.to change(Tag, :count).by(-1)
      end

      it "ラベルの一覧画面にリダイレクトすること" do
        tag = create(:tag, user_id: user.id)
        delete :destroy, { id: tag.id }
        expect(response).to redirect_to(tags_url)
      end
    end

    after do
      sign_out :user
    end
  end

  context 'ユーザーがログインしていない場合' do
    describe "ラベル一覧画面" do
      it "ログイン画面にリダイレクトすること" do
        get :index
        expect(response).to redirect_to(user_session_path)
      end
    end
  end
end
