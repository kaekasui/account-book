require 'rails_helper'

describe Users::RegistrationsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context 'ログインしていない場合' do
    describe '新規登録画面' do
      it '新規登録フォームを表示すること' do
        get :new, use_route: :users
        expect(assigns(:user)).to be_a_new(User)
      end

      it '新規登録画面を表示すること' do
        get :new, use_route: :users
        expect(response).to render_template :new
      end
    end

    describe '新規登録' do
      context '有効な値を入力した場合' do
        it 'ユーザーを追加すること' do
          expect { post :create, { use_route: :users, user: attributes_for(:user) } }.to change(User, :count).by(1)
        end

        it 'トップ画面にリダイレクトすること' do
          post :create, { use_route: :users, user: attributes_for(:user) }
          expect(response).to redirect_to root_path
        end
      end

      context '無効な値を入力した場合' do
        it 'ユーザーを追加しないこと' do
          expect { post :create, { use_route: :users, user: attributes_for(:user, email: "") }}.to change(User, :count).by(0)
        end

        it '新規登録画面を再表示すること' do
          post :create, { use_route: :users, user: attributes_for(:user, email: "") }
          expect(response).to render_template :new
        end
      end
    end

    describe 'ユーザー情報の編集画面' do
      it 'ログイン画面が表示されること' do
        user = create(:user, confirmed_at: Time.now)
        get :edit, use_route: :users, id: user.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context 'ログインしている場合' do
    before do
      @user = create(:user, confirmed_at: Time.now)
      sign_in @user
    end

    describe '新規登録画面' do
      it 'トップ画面にリダイレクトすること' do
        get :new, use_route: :users
        expect(response).to redirect_to root_path
      end
    end 

    describe 'ユーザー情報の編集画面' do
      it '登録されたユーザー情報を表示すること' do
        get :edit, use_route: :users
        expect(assigns(:user)).to eq @user
      end

      it '編集画面を表示すること' do
        get :edit, use_route: :users
        expect(response).to render_template :edit
      end
    end

    describe 'ユーザー情報の編集' do
      context '有効な値を入力した場合' do
        it 'ユーザー情報を更新すること' do
          pending
          patch :update, user: attributes_for(:edit_user, email: "edit_user@example.com", current_password: @user.password)
          expect(@user.reload.email).to eq "edit_user@example.com"
        end

        it 'マイページにリダイレクトすること' do
          patch :update, { id: @user.id, use_route: :users, user: attributes_for(:edit_user), id: @user.id}
          expect(response).to redirect_to users_mypage_path
        end
      end

      context '無効な値を入力した場合' do
        it 'ユーザー情報を更新しないこと' do
          patch :update, { use_route: :users, user: attributes_for(:edit_user, current_password: "invalid_password")}
          expect(@user.reload.password).to eq "password"
        end

        it 'ユーザー情報の編集画面を再表示すること' do
          patch :update, { use_route: :users, user: attributes_for(:edit_user, current_password: "invalid_password")}
          expect(response).to render_template :edit
        end
      end
    end

    describe 'アカウントを削除すること' do
      it 'アカウントを論理削除し削除時刻を更新すること' do
        delete :destroy, use_route: :users
        expect(@user.reload.deleted_at).to_not be_nil
      end
    end

    after do
      sign_out :user
    end
  end
end
