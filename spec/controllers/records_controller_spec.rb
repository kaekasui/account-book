require 'rails_helper'

RSpec.describe RecordsController, type: :controller do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:breakdown) { create(:breakdown, user_id: user.id, category_id: category.id) }

  context 'with a logged-in user' do
    before do
      sign_in user
    end

    describe "GET index" do
      it "assigns all records as @records" do
        record = create(:record, breakdown_id: breakdown.id, user_id: user.id)
        get :index
        expect(assigns(:records)).to eq([record])
      end
    end

    describe "GET show" do
      it "assigns the requested record as @record" do
        record = create(:record, breakdown_id: breakdown.id, user_id: user.id)
        get :show, { id: record.id }
        expect(assigns(:record)).to eq(record)
      end
    end

    describe "GET new" do
      it "assigns a new record as @record" do
        get :new
        expect(assigns(:record)).to be_a_new(Record)
      end
    end

    describe "GET edit" do
      it "assigns the requested record as @record" do
        record = create(:record, breakdown_id: breakdown.id, user_id: user.id)
        get :edit, { id: record.id }
        expect(assigns(:record)).to eq(record)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Record" do
          expect {
            post :create, { record: attributes_for(:record, breakdown_id: breakdown.id, user_id: user.id) }
          }.to change(Record, :count).by(1)
        end

        it "assigns a newly created record as @record" do
          post :create, { record: attributes_for(:record, breakdown_id: breakdown.id, user_id: user.id) }
          expect(assigns(:record)).to be_a(Record)
          expect(assigns(:record)).to be_persisted
        end

        it "redirects to the created record" do
          post :create, { record: attributes_for(:record, breakdown_id: breakdown.id, user_id: user.id) }
          expect(response).to redirect_to(Record.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved record as @record" do
          post :create, { record: attributes_for(:record) }
          expect(assigns(:record)).to be_a_new(Record)
        end

        it "re-renders the 'new' template" do
          post :create, { record: attributes_for(:record) }
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested record" do
          record = create(:record, breakdown_id: breakdown.id, user_id: user.id)
          put :update, { id: record.id, record: attributes_for(:record, charge: 2000, breakdown_id: breakdown.id, user_id: user.id) }
          record.reload
          expect(record.charge).to eq 2000
        end

        it "assigns the requested record as @record" do
          record = create(:record, breakdown_id: breakdown.id, user_id: user.id)
          put :update, { id: record.id, record: attributes_for(:record, breakdown_id: breakdown.id, user_id: user.id) }
          expect(assigns(:record)).to eq(record)
        end

        it "redirects to the record" do
          record = create(:record, breakdown_id: breakdown.id, user_id: user.id)
          put :update, { id: record.id, record: attributes_for(:record, breakdown_id: breakdown.id, user_id: user.id) }
          expect(response).to redirect_to(record)
        end
      end

      describe "with invalid params" do
        it "assigns the record as @record" do
          record = create(:record, breakdown_id: breakdown.id, user_id: user.id)
          put :update, { id: record.id, record: attributes_for(:record, charge: '') }
          expect(assigns(:record)).to eq(record)
        end

        it "re-renders the 'edit' template" do
          record = create(:record, breakdown_id: breakdown.id, user_id: user.id)
          put :update, { id: record.id, record: attributes_for(:record, charge: '') }
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested record" do
        record = create(:record, breakdown_id: breakdown.id, user_id: user.id)
        expect {
          delete :destroy, { id: record.id }
        }.to change(Record, :count).by(-1)
      end

      it "redirects to the records list" do
        record = create(:record, breakdown_id: breakdown.id, user_id: user.id)
        delete :destroy, { id: record.id }
        expect(response).to redirect_to(records_url)
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

    describe "GET new" do
      it "redirects to sign in page." do
        get :new
        expect(response).to redirect_to(user_session_path)
      end
    end

    describe "GET edit" do
      it "redirects to sign in page." do
        category = create(:category)
        get :edit, { id: category.id }
        expect(response).to redirect_to(user_session_path)
      end
    end
  end
end
