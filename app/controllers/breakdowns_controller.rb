class BreakdownsController < ApplicationController
  before_action :set_breakdown, only: [:edit, :update, :destroy]
  respond_to :js

  def index
    @breakdowns = current_user.breakdowns.all
    @breakdown = current_user.breakdowns.new
  end

  def edit
  end

  def create
    @breakdown = current_user.breakdowns.new(breakdown_params)
    @breakdown.user_id = current_user.id
    @breakdown.save
    respond_with @breakdown, location: breakdowns_path
  end

  def update
    respond_to do |format|
      @breakdown.update_attributes(breakdown_params)
      @breakdown.user_id = current_user.id
      if @breakdown.save
        format.html { redirect_to breakdowns_path, notice: 'Breakdown was successfully updated.' }
        format.json { render :show, status: :ok, location: breakdowns_path }
      else
        format.html { render :edit }
        format.json { render json: @breakdown.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @breakdown.destroy
    respond_to do |format|
      format.html { redirect_to breakdowns_url, notice: 'Breakdown was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_breakdown
      @breakdown = Breakdown.find(params[:id])
    end

    def breakdown_params
      params.require(:breakdown).permit(:name, :category_id, :user_id, :deleted_at)
    end
end
