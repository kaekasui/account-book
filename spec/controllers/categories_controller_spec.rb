require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:user) { create(:user) }

  context 'with a logged-in users' do
    before do
      sign_in user
    end

    describe "GET index" do
      it "assigns all categories as @categories" do
        category = create(:category)
        get :index
        expect(assigns(:categories)).to eq([category])
      end
    end

    describe "GET edit" do
      it "assings the requested category as @category" do
        category = create(:category)
        get :edit, { id: category.id }
        expect(assigns(:category)).to eq(category)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Category" do
          expect {
            post :create, { category: attributes_for(:category), format: :js }
          }.to change(Category, :count).by(1)
        end

        it "assigns a newly created category as @category" do
          post :create, { category: attributes_for(:category), format: :js }
          expect(assigns(:category)).to be_a(Category)
          expect(assigns(:category)).to be_persisted
        end

        # レスポンスステータスが200であること
	it "has response status code, 200" do
          post :create, { category: attributes_for(:category), format: :js }
          expect(response.status).to eq(200)
        end 
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved category as @category" do
          post :create, { category: attributes_for(:category, name: ""), format: :js }
          expect(assigns(:category)).to be_a_new(Category)
        end

        it "re-renders the 'new' template"
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested category" do
          category = create(:category)
          put :update, { id: category.id, category: attributes_for(:category, name: "new") }
          category.reload
          expect(category.name).to eq("new")
        end

        it "assigns the requested category as @category" do
          category = create(:category)
          put :update, { id: category.id, category: attributes_for(:category, name: "new") }
          expect(assigns(:category)).to eq(category)
        end

        it "redirects to the categories list" do
          category = create(:category)
          put :update, { id: category.id, category: attributes_for(:category, name: "new") }
          expect(response).to redirect_to(categories_path)
        end
      end

      describe "with invalid params" do
        it "assigns the category as @category" do
          category = create(:category)
          put :update, { id: category.id, category: attributes_for(:category, name: "") }
          expect(assigns(:category)).to eq(category)
        end

        it "re-renders the 'edit' template" do
          category = create(:category)
          put :update, { id: category.id, category: attributes_for(:category, name: "") }
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested category" do
        category = create(:category)
        expect {
          delete :destroy, { id: category.id }
        }.to change(Category, :count).by(-1)
      end

      it "redirects to the categories list" do
        category = create(:category)
        delete :destroy, { id: category.id }
        expect(response).to redirect_to(categories_url)
      end
    end

    after do
      sign_out :user
    end
  end

  context 'with a non-logged-in users' do
    describe "GET index" do
      it "redirects to sign in page." do
        get :index
        expect(response).to redirect_to(user_session_path)
      end
    end

    describe "GET edit" do
      it "assings the requested category as @category" do
        category = create(:category)
        get :edit, { id: category.id }
        expect(response).to redirect_to(user_session_path)
      end
    end
  end
end
