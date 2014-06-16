require 'rails_helper'

RSpec.describe BreakdownsController, type: :controller do
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  context 'with a logged-in user' do
    before do
      sign_in user
    end

    describe "GET index" do
      it "assigns all breakdowns as @breakdowns" do
        breakdown = create(:breakdown, user_id: user.id, category_id: category.id)
        get :index
        expect(assigns(:breakdowns)).to eq([breakdown])
      end
    end

    describe "GET edit" do
      it "assigns the requested breakdown as @breakdown" do
        breakdown = create(:breakdown, user_id: user.id, category_id: category.id)
        get :edit, { id: breakdown.id }
        expect(assigns(:breakdown)).to eq(breakdown)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Breakdown" do
          expect {
            post :create, { breakdown: attributes_for(:breakdown, category_id: category.id), format: :js }
          }.to change(Breakdown, :count).by(1)
        end

        it "assigns a newly created breakdown as @breakdown" do
          post :create, { breakdown: attributes_for(:breakdown, category_id: category.id), format: :js }
          expect(assigns(:breakdown)).to be_a(Breakdown)
          expect(assigns(:breakdown)).to be_persisted
        end

        # レスポンスのステータスが200になること
        it "has response status code, 200" do
          post :create, { breakdown: attributes_for(:breakdown, category_id: category.id), format: :js }
          expect(response.status).to eq 200
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved breakdown as @breakdown" do
          post :create, { breakdown: attributes_for(:breakdown, name: "", user_id: user.id, category_id: category.id), format: :js }
          expect(assigns(:breakdown)).to be_a_new(Breakdown)
        end

        it "re-renders the 'new' template"
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested breakdown" do
          breakdown = create(:breakdown, user_id: user.id, category_id: category.id)
          put :update, { id: breakdown.id, breakdown: attributes_for(:breakdown, name: "new", category_id: category.id) }
          breakdown.reload
          expect(breakdown.name).to eq "new"
        end

        it "assigns the requested breakdown as @breakdown" do
          breakdown = create(:breakdown, user_id: user.id, category_id: category.id)
          put :update, { id: breakdown.id, breakdown: attributes_for(:breakdown, name: "new", category_id: category.id) }
          expect(assigns(:breakdown)).to eq(breakdown)
        end

        it "redirects to the breakdowns list" do
          breakdown = create(:breakdown, user_id: user.id, category_id: category.id)
          put :update, { id: breakdown.id, breakdown: attributes_for(:breakdown, name: "new", category_id: category.id) }
          expect(response).to redirect_to(breakdowns_path)
        end
      end

      describe "with invalid params" do
        it "assigns the breakdown as @breakdown" do
          breakdown = create(:breakdown,  user_id: user.id, category_id: category.id)
          put :update, { id: breakdown.id, breakdown: attributes_for(:breakdown, name: "", user_id: user.id, category_id: category.id) }
          expect(assigns(:breakdown)).to eq(breakdown)
        end

        it "re-renders the 'edit' template" do
          breakdown = create(:breakdown,  user_id: user.id, category_id: category.id)
          put :update, { id: breakdown.id, breakdown: attributes_for(:breakdown, name: "", user_id: user.id, category_id: category.id) }
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested breakdown" do
        breakdown = create(:breakdown,  user_id: user.id, category_id: category.id)
        expect {
          delete :destroy, { id: breakdown.id }
        }.to change(Breakdown, :count).by(-1)
      end

      it "redirects to the breakdowns list" do
        breakdown = create(:breakdown,  user_id: user.id, category_id: category.id)
        delete :destroy, { id: breakdown.id }
        expect(response).to redirect_to(breakdowns_url)
      end
    end

    after do
      sign_out :user
    end
  end

  context 'with a non-logged-in user' do
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
