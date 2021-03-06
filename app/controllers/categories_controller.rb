# User manages some categories.
class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  respond_to :js

  def index
    @category = current_user.categories.new
    @category.barance_of_payments = true
    @categories = current_user.categories.where(barance_of_payments: false).order(:created_at).reverse_order
  end

  def show
    @breakdowns = @category.breakdowns
    @records = @category.records
  end

  def edit
  end

  def create
    @category = current_user.categories.new(category_params)
    @category.barance_of_payments = 0 if category_params[:barance_of_payments].nil?
    respond_to do |format|
      if @category.save
        if @category.submit_type == 'modal'
          format.js { render text: @category.id }
        else
          format.js
        end
      else
        format.js { render 'categories/failure_create' }
      end
    end
  end

  def update
    respond_to do |format|
      @category.update_attributes(category_params)
      @category.barance_of_payments = 0 if category_params[:barance_of_payments].nil?
      if @category.save
        format.html { redirect_to categories_path, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: categories_path }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def set_categories_list
    @categories = current_user.categories.where(barance_of_payments: params[:barance_of_payments]).order(:updated_at).reverse_order
  end

  def set_categories_box
    @categories = current_user.categories.where(id: nil)
    user_categories = current_user.categories.where(barance_of_payments: params[:barance_of_payments])
    keys = user_categories.joins(:records).group('records.category_id').order('count_all desc').count.keys
    category_ids = user_categories.map(&:id)
    (keys + (category_ids - keys)).each do |category|
      @categories << current_user.categories.find(category)
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :barance_of_payments, :submit_type)
  end
end
