class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]
  respond_to :js

  def index
    @place = Place.new
    @places = current_user.places.order(:updated_at).reverse_order
  end

  def show
    respond_with(@place)
  end

  def new
    @place = current_user.places.new
    respond_with(@place)
  end

  def edit
  end

  def create
    @place = current_user.places.new(place_params)
    @place.save
    respond_with @place, location: places_path
  end

  def update
    @place.update_attributes(place_params)
    respond_to do |format|
      if @place.save
        format.html { redirect_to places_path }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    Place.transaction do
      @place.destroy!
    end
    rescue => ex
    puts ex.message
    flash[:alert] = I18n.t('messages.places.destroy_failure')
    ensure
    redirect_to places_path
  end

  private
    def set_place
      @place = Place.find(params[:id])
    end

    def place_params
      params.require(:place).permit(:name)
    end
end
