class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:set_breakdowns_from_category]
  respond_to :html

  def index
    @year = year_param || Date.today.year.to_s
    @month = month_param || Date.today.month.to_s

    @records = current_user.records.where("year(published_at) = #{@year} and month(published_at) = #{@month}").order(:published_at).reverse_order
  end

  def show
  end

  def new
    @record = current_user.records.new
    if params[:category].present?
      category = current_user.categories.find_by_id(params[:category])
      @record.category_id = category.id
      @record.category_type = category.barance_of_payments
    end
  end

  def edit
    @record.tagged = (@record.tagged_records.map {|r| r.tag.name }).join(',')
  end

  def create
    @record = current_user.records.new(record_params)
    @record.tagged = params[:record][:tagged] if params[:record][:tagged]
    tagged_records = params[:record][:tagged]
    if @record.save
      flash[:notice] = I18n.t("messages.record.created")
      set_tags(tagged_records.split(',')) if tagged_records.present?
    end
    respond_with @record, location: new_record_path
  end

  def update
    @record.update_attributes(record_params)
    @record.user_id = current_user.id
    respond_to do |format|
      if @record.save
        tagged_records = params[:record][:tagged]
        set_tags(tagged_records.split(',')) if tagged_records.present?
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
      @breakdowns = current_user.categories.find(@category_id).breakdowns
    else
      @breakdowns = current_user.breakdowns.all
    end
    respond_to do |format|
      format.js
    end
  end

  def download
    respond_to do |format|
      format.csv { send_csv Record.sample_format_csvfile }
    end
  end

  private
    def set_record
      @record = Record.find(params[:id])
    end

    def record_params
      params.require(:record).permit(:published_at, :charge, :category_id, :breakdown_id, :place_id, :memo, :user_id)
    end

    def year_param
      params[:year]
    end

    def month_param
      params[:month]
    end

    def set_tags(tagged_records)
      current_user.tagged_records.each do |tagged_record|
        tagged_record.destroy
      end
      tagged_records.each do |tagged_record|
        new_tag = current_user.tags.where(name: tagged_record).first || current_user.tags.create(name: tagged_record, color_code: "#5e7535")
        current_user.tagged_records.create(tag_id: new_tag.id, record_id: @record.id)
      end
    end
end
