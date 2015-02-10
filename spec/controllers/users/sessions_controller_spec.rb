require 'rails_helper'

describe Users::SessionsController do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  context 'ログインしていない場合' do
    describe 'ログイン画面' do
      it 'ログインフォームが表示されること' do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end

      it 'ログイン画面が表示されること' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'ログイン' do
      context '有効な値を入力した場合' do
        it 'ログインすること' do
          user = create(:user, confirmed_at: Time.now)
          expect(sign_in user).to eq [[user.id], user.encrypted_password[0..28]]
        end

        it 'トップ画面にリダイレクトすること' do
          create(:user, confirmed_at: Time.now)
          post :create, user: attributes_for(:user)
          expect(response).to redirect_to root_path
        end
      end

      context '無効な値を入力した場合' do
        it 'ログインしないこと' do
          user = build(:user, password: nil)
          expect(sign_in user).to eq [nil, '']
        end

        it 'ログイン画面を表示すること' do
          post :create, user: attributes_for(:user, email: '')
          expect(response).to render_template :new
        end
      end
    end
  end

  context 'ログインしている場合' do
    before do
      user = create(:user, confirmed_at: Time.now)
      sign_in user
    end

    describe 'ログイン画面' do
      it 'トップ画面にリダイレクトすること' do
        get :new
        expect(response).to redirect_to root_path
      end
    end

    describe 'ログアウト' do
      it 'ログアウトすること' do
        delete :destroy
        expect(response).to redirect_to root_path
      end
    end

    after do
      sign_out :user
    end
  end
end
