require 'rails_helper'

describe Users::RegistrationsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  # ログインしていない場合
  context 'with non-logged-in user' do
    describe 'GET #new' do
      # 新しいアカウントを割り当てること
      it 'assigns a new User to @user.' do
        get :new, use_route: :users
        expect(assigns(:user)).to be_a_new(User)
      end

      # :new テンプレートを表示すること
      it 'renders the :new template.' do
        get :new, use_route: :users
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      # 有効な属性の場合
      context 'with valid attributes' do
        # ユーザーを追加すること
        it 'creates a user.' do
          expect { post :create, { use_route: :users, user: attributes_for(:user) } }.to change(User, :count).by(1)
        end

        # root_path にリダイレクトすること
        it 'redirects to root_path.' do
          post :create, { use_route: :users, user: attributes_for(:user) }
          expect(response).to redirect_to root_path
        end
      end

      # 無効な属性の場合
      context 'with invalid attributes' do
        # ユーザーを追加しないこと
        it 'doesn\'t create a user.' do
          expect { post :create, { use_route: :users, user: attributes_for(:user, email: "") }}.to change(User, :count).by(0)
        end

        # :new テンプレートを再表示すること
        it 're-renders the :new template.' do
          post :create, { use_route: :users, user: attributes_for(:user, email: "") }
          expect(response).to render_template :new
        end
      end
    end

    describe 'GET #edit' do
      # root_pathにリダイレクトすること
      it 'redirects to root_path.' do
        user = create(:user)
        get :edit, use_route: :users, id: user.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  # ログインしている場合
  context 'with logged-in user' do
    before do
      @user = create(:user)
      sign_in @user
    end

    describe 'GET #new' do
      # root_path にリダイレクトすること
      it 'redirects to root_path.' do
        get :new, use_route: :users
        expect(response).to redirect_to root_path
      end
    end 

    describe 'POST #create' do
      # 有効な属性の場合
      context 'with valid attributes' do
        # root_path にリダイレクトすること
        it 'redirects to root_path.' do
          post :create, { use_route: :users, user: attributes_for(:user) }
          expect(response).to redirect_to root_path
        end
      end

      # 無効な属性の場合
      context 'with invalid attributes' do
        # root_path にリダイレクトすること
        it 'redirects to root_path.' do
          post :create, { use_route: :users, user: attributes_for(:user, email: "") }
          expect(response).to redirect_to root_path
        end
      end
    end 

    describe 'GET #edit' do
      # @user に要求されたアカウントを割り当てること
      it 'assigns the requested user to @user.' do
        get :edit, use_route: :users
        expect(assigns(:user)).to eq @user
      end

      # :edit テンプレートを表示すること
      it 'renders the :edit template.' do
        get :edit, use_route: :users
        expect(response).to render_template :edit
      end
    end

    describe 'PATCH #update' do
      # 有効な属性の場合
      context 'with valid attributes' do
        # ユーザーを更新すること
        it 'updates a user.' do
          pending
          patch :update, user: attributes_for(:edit_user)
          expect(@user.reload.email).to eq "edit_user@example.com"
        end

        # root_path にリダイレクトする
        it 'redirects to root_path' do
          pending
          patch :update, user: attributes_for(:edit_user)
          expect(response).to redirect_to root_path
        end
      end

      # 無効な属性の場合
      context 'with invalid attributes' do
        # ユーザーを更新しないこと
        it 'doesn\'t update a user.' do
          pending
          patch :update, user: attributes_for(:edit_user, current_password: "")
          expect(@user.reload.email).to eq "user@example.com"
        end

        # :edit テンプレートを再表示する
        it 're-renders the :edit template.' do
          pending
          patch :update, user: attributes_for(:edit_user, current_password: "")
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      # ユーザーを論理削除すること
      it 'delete a user.' do
        delete :destroy, use_route: :users
        expect(@user.reload.deleted_at).to_not be_nil
      end
    end

    after do
      sign_out :user
    end
  end
end
