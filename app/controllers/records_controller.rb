class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:set_breakdowns_from_category]

  def index
    @year = year_param || Date.today.year.to_s
    @month = month_param || (@year == Date.today.year.to_s ? Date.today.month.to_s : "1")

    @records = current_user.records.where("year(published_at) = #{@year} and month(published_at) = #{@month}")
  end

  def show
  end

  def new
    @record = Record.new
  end

  def edit
  end

  def create
    @record = Record.new(record_params)
    @record.user_id = current_user.id

    respond_to do |format|
      if @record.save
        format.html { redirect_to @record, notice: 'Record was successfully created.' }
        format.json { render :show, status: :created, location: @record }
      else
        format.html { render :new }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @record.update_attributes(record_params)
    @record.user_id = current_user.id
    respond_to do |format|
      if @record.save
        format.html { redirect_to @record, notice: 'Record was successfully updated.' }
        format.json { render :show, status: :ok, location: @record }
      else
        format.html { render :edit }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @record.destroy
    respond_to do |format|
      format.html { redirect_to records_url, notice: 'Record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def set_breakdowns_from_category
    @category_id = ''
    parameters = params
    parameters.delete("controller")
    parameters.delete("action")
    parameters.each do |key, value|
      @category_id = key
    end
    if @category_id
      @breakdowns = Category.find(@category_id).breakdowns
   else
      @breakdowns = Breakdowns.all
    end
    respond_to do |format|
      format.js
    end
  end

  private
    def set_record
      @record = Record.find(params[:id])
    end

    def record_params
      params.require(:record).permit(:published_at, :charge, :breakdown_id, :memo, :deleted_at, :user_id)
    end

    def year_param
      params[:year]
    end

    def month_param
      params[:month]
    end

end