require 'rails_helper'

describe Users::RegistrationsController do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  context 'ログインしていない場合' do
    describe '新規登録画面' do
      it '新規登録フォームを表示すること' do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end

      it '新規登録画面を表示すること' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe '新規登録' do
      context '有効な値を入力した場合' do
        it 'ユーザーを追加すること' do
          expect { post :create, user: attributes_for(:user)  }.to change(User, :count).by(1)
        end

        it 'トップ画面にリダイレクトすること' do
          post :create, user: attributes_for(:user)
          expect(response).to redirect_to root_path
        end
      end

      context '無効な値を入力した場合' do
        it 'ユーザーを追加しないこと' do
          expect { post :create, user: attributes_for(:user, email: '') }.to change(User, :count).by(0)
        end

        it '新規登録画面を再表示すること' do
          post :create, user: attributes_for(:user, email: '')
          expect(response).to render_template :new
        end
      end
    end

    describe 'ユーザー情報の編集画面' do
      it 'ログイン画面が表示されること' do
        user = create(:user, confirmed_at: Time.now)
        get :edit, id: user.id
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
        get :new
        expect(response).to redirect_to root_path
      end
    end

    describe 'ユーザー情報の編集画面' do
      it '登録されたユーザー情報を表示すること' do
        get :edit
        expect(assigns(:user)).to eq @user
      end

      it '編集画面を表示すること' do
        get :edit
        expect(response).to render_template :edit
      end
    end

    describe 'ユーザー情報の編集' do
      context '有効な値を入力した場合' do
        it 'ユーザー情報を更新すること' do
          patch :update, user: attributes_for(:edit_user), id: @user.id
          expect(@user.password).to eq 'password'
        end

        it 'マイページにリダイレクトすること' do
          patch :update, user: attributes_for(:edit_user), id: @user.id
          expect(response).to redirect_to users_mypage_path
        end
      end

      context '無効な値を入力した場合' do
        it 'ユーザー情報を更新しないこと' do
          patch :update, user: attributes_for(:edit_user, current_password: 'invalid_password')
          expect(@user.reload.password).to eq 'password'
        end

        it 'ユーザー情報の編集画面を再表示すること' do
          patch :update, user: attributes_for(:edit_user, current_password: 'invalid_password')
          expect(response).to render_template :edit
        end
      end
    end

    describe '退会' do
      it 'ステータスが退会ステータスになっていること' do
        delete :destroy, cancel: attributes_for(:cancel)
        expect(@user.reload.status).to eq 3
      end

      it '退会情報が登録されていること' do
        delete :destroy, cancel: attributes_for(:cancel)
        expect(@user.cancels.blank?).to eq false
      end
    end

    after do
      sign_out :user
    end
  end
end
