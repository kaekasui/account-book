require 'rails_helper'

describe Users::SessionsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  # ログインしていない場合
  context 'with non-logged-in user' do
    describe 'GET #new' do
      # 新しいアカウントを割り当てること
      it 'assigns a new User to @user' do
        get :new, use_route: :users
        expect(assigns(:user)).to be_a_new(User)
      end

      # :new テンプレートを表示すること
      it 'renders the :new template' do
        get :new, use_route: :users
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      # 有効な属性の場合
      context 'with valid attributes' do
        # ログインすること
        it 'logs in' do
          user = create(:user)
          expect(sign_in user).to eq [[user.id], user.encrypted_password[0..28]]
        end

        # root_path にリダイレクトすること
        it 'redirects to root_path' do
          create(:user)
          post :create, { use_route: :users, user: attributes_for(:user) }
          expect(response).to redirect_to root_path 
        end
      end

      # 無効な属性の場合
      context 'with invalid attributes' do
        # ログインしないこと
        it 'dosen\'t log in' do
          user = build(:user, password: nil)
          expect(sign_in user).to eq [nil, ""]
        end

        # :new テンプレートを再表示すること
        it 're-renders the :new template' do
          post :create, { use_route: :users, user: attributes_for(:user, email: "") }
          expect(response).to render_template :new
        end
      end
    end
  end

  # ログインしている場合
  context 'with logged-in user' do
    before do
      user = create(:user)
      sign_in user
    end

    describe 'GET #new' do
      # root_path にリダイレクトすること
      it 'redirects to root_path' do
        get :new, use_route: :users
        expect(response).to redirect_to root_path
      end
    end 

    describe 'POST #create' do
      # 有効な属性の場合
      context 'with valid attributes' do
        # root_path にリダイレクトすること
        it 'redirects to root_path' do
          post :create, { use_route: :users, user: attributes_for(:user) }
          expect(response).to redirect_to root_path
        end
      end

      # 無効な属性の場合
      context 'with invalid attributes' do
        # root_path にリダイレクトすること
        it 'redirects to root_path' do
          post :create, { use_route: :users, user: attributes_for(:user, email: "") }
          expect(response).to redirect_to root_path
        end
      end
    end 

    describe 'DELETE #destroy' do
      # ログアウトすること
      it 'logs out' do
        delete :destroy, use_route: :users
        expect(response).to redirect_to root_path
      end
    end

    after do
      sign_out :user
    end
  end
end
