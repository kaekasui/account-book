require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }
  let(:user) { create(:user) }

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
    it "assigns the requested category as @category" do
      category = Category.create! valid_attributes
      get :edit, {:id => category.to_param}, valid_session
      expect(assigns(:category)).to eq(category)
    end

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

      it "re-renders the 'new' template" do
        post :create, {:category => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested category" do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :category => new_attributes}, valid_session
        category.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested category as @category" do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :category => valid_attributes}, valid_session
        expect(assigns(:category)).to eq(category)
      end

      it "redirects to the category" do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :category => valid_attributes}, valid_session
        expect(response).to redirect_to(category)
      end
    end

    describe "with invalid params" do
      it "assigns the category as @category" do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :category => invalid_attributes}, valid_session
        expect(assigns(:category)).to eq(category)
      end

      it "re-renders the 'edit' template" do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :category => invalid_attributes}, valid_session
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
