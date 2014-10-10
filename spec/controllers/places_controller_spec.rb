require 'rails_helper'

RSpec.describe PlacesController, type: :controller do
  let(:user) { create(:user, confirmed_at: Time.now) }

  context 'ユーザーがログインしている場合' do
    before do
      sign_in user
    end

    describe "場所一覧画面" do
      it "場所が一覧で表示されること" do
        place = create(:place, user_id: user.id)
        get :index
        expect(assigns(:places)).to eq([place])
      end
    end

    describe "場所の作成" do
      describe "有効な値を入力した場合" do
        it "新しく場所が登録されること" do
          expect {
            post :create, { place: attributes_for(:place, user_id: user.id), format: :js }
          }.to change(Place, :count).by(1)
        end

        it "対象の内訳が表示されること" do
          post :create, { place: attributes_for(:place, user_id: user.id), format: :js }
          expect(assigns(:place)).to be_a(Place)
          expect(assigns(:place)).to be_persisted
        end

        it "レスポンスのステータスコードが200になること" do
          post :create, { place: attributes_for(:place, user_id: user.id), format: :js }
          expect(response.status).to eq 200
        end
      end

      describe "無効な値が入力された場合" do
        it "内訳が登録されないこと" do
          post :create, { place: attributes_for(:place, name: "", user_id: user.id), format: :js }
          expect(assigns(:place)).to be_a_new(Place)
          expect {
            post :create, { place: attributes_for(:place, name: "", user_id: user.id), format: :js }
          }.to change(Place, :count).by(0)
        end
      end
    end

    after do
      sign_out :user
    end
  end

=begin
  describe "GET show" do
    it "assigns the requested place as @place" do
      place = Place.create! valid_attributes
      get :show, {:id => place.to_param}, valid_session
      expect(assigns(:place)).to eq(place)
    end
  end

  describe "GET new" do
    it "assigns a new place as @place" do
      get :new, {}, valid_session
      expect(assigns(:place)).to be_a_new(Place)
    end
  end

  describe "GET edit" do
    it "assigns the requested place as @place" do
      place = Place.create! valid_attributes
      get :edit, {:id => place.to_param}, valid_session
      expect(assigns(:place)).to eq(place)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Place" do
        expect {
          post :create, {:place => valid_attributes}, valid_session
        }.to change(Place, :count).by(1)
      end

      it "assigns a newly created place as @place" do
        post :create, {:place => valid_attributes}, valid_session
        expect(assigns(:place)).to be_a(Place)
        expect(assigns(:place)).to be_persisted
      end

      it "redirects to the created place" do
        post :create, {:place => valid_attributes}, valid_session
        expect(response).to redirect_to(Place.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved place as @place" do
        post :create, {:place => invalid_attributes}, valid_session
        expect(assigns(:place)).to be_a_new(Place)
      end

      it "re-renders the 'new' template" do
        post :create, {:place => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested place" do
        place = Place.create! valid_attributes
        put :update, {:id => place.to_param, :place => new_attributes}, valid_session
        place.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested place as @place" do
        place = Place.create! valid_attributes
        put :update, {:id => place.to_param, :place => valid_attributes}, valid_session
        expect(assigns(:place)).to eq(place)
      end

      it "redirects to the place" do
        place = Place.create! valid_attributes
        put :update, {:id => place.to_param, :place => valid_attributes}, valid_session
        expect(response).to redirect_to(place)
      end
    end

    describe "with invalid params" do
      it "assigns the place as @place" do
        place = Place.create! valid_attributes
        put :update, {:id => place.to_param, :place => invalid_attributes}, valid_session
        expect(assigns(:place)).to eq(place)
      end

      it "re-renders the 'edit' template" do
        place = Place.create! valid_attributes
        put :update, {:id => place.to_param, :place => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested place" do
      place = Place.create! valid_attributes
      expect {
        delete :destroy, {:id => place.to_param}, valid_session
      }.to change(Place, :count).by(-1)
    end

    it "redirects to the places list" do
      place = Place.create! valid_attributes
      delete :destroy, {:id => place.to_param}, valid_session
      expect(response).to redirect_to(places_url)
    end
  end
=end
end
