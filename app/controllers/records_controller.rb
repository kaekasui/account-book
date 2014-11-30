# User records.
class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:set_breakdowns_from_category]
  respond_to :html

  def index
    @year = year_param || Date.today.year.to_s
    @month = month_param || Date.today.month.to_s

    @records = current_user.records.where("year(published_at) = #{@year} and month(published_at) = #{@month}").order(:published_at).reverse_order
    @outgo = @records.joins(:category).where("barance_of_payments = ?", 0)
    @income = @records.joins(:category).where("barance_of_payments = ?", 1)
  end

  def show
  end

  def new
    @record = current_user.records.new
    @places_list = current_user.places.where(id: nil)
    unless current_user.places.blank?
      current_user.places.joins(:records).group('records.place_id').order('count_all desc').count.keys.each do |place|
        @places_list << current_user.places.find(place)
      end
    end
    if params[:category].present?
      category = current_user.categories.find_by_id(params[:category])
      @record.category_id = category.id
      @record.category_type = category.barance_of_payments
    end
  end

  def copy
    @record = current_user.records.new
    @record.attributes = Record.find(params[:record_id]).attributes
    @record.tagged = (@record.tagged_records.map {|r| r.tag.name }).join(',')
  end

  def edit
    @record.tagged = (@record.tagged_records.map {|r| r.tag.name }).join(',')
  end

  def create
    @record = current_user.records.new(record_params)
    @record.tagged = params[:record][:tagged] if params[:record][:tagged]
    tagged_records = params[:record][:tagged]
    if @record.save
      set_tags(@record.id, tagged_records.split(',')) if tagged_records.present?
      if @record.errors.any?
      else
        flash[:notice] = I18n.t('messages.record.created')
        session[:pre_record_id] = @record.id
      end
    end
    respond_with @record, location: new_record_path
  end

  def update
    @record.update_attributes(record_params)
    respond_to do |format|
      if @record.save
        tagged_records = params[:record][:tagged]
        set_tags(@record.id, tagged_records.split(',')) if tagged_records.present?
        session[:pre_record_id] = @record.id
        format.html { redirect_to records_path(year: @record.published_at.year, month: @record.published_at.month), notice: I18n.t('messages.record.updated') }
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
    parameters.delete('controller')
    parameters.delete('action')
    parameters.each do |key, value|
      @category_id = key
    end
    @breakdowns = current_user.breakdowns.where(id: nil)
    if @category_id == ''
    elsif @category_id
      user_breakdowns = current_user.categories.find(@category_id).breakdowns
      keys = user_breakdowns.joins(:records).group('records.breakdown_id').order('count_all desc').count.keys
      breakdown_ids = user_breakdowns.map {|b| b.id }
      (keys + (breakdown_ids - keys)).each do |breakdown|
        @breakdowns << current_user.breakdowns.find(breakdown)
      end
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

  def set_tags(record_id, tagged_records)
    current_user.tagged_records.where(record_id: record_id).each do |tagged_record|
      @record.errors.add(:tagged, tagged_record.errors.full_messages.first) unless tagged_record.destroy
    end
    tagged_records.each do |tagged_record|
      new_tag = current_user.tags.where(name: tagged_record).first || current_user.tags.create(name: tagged_record, color_code: generate_color_code)
      unless new_tag.persisted?
        @record.errors.add(:tagged, new_tag.errors.full_messages.first)
      else
        new_tagged_record = current_user.tagged_records.create(tag_id: new_tag.id, record_id: @record.id)
        @record.errors.add(:tagged, new_tagged_record.errors.full_messages.first) unless new_tagged_record.persisted?
      end
    end
  end

  def generate_color_code
    color_code = '#%06x' % (rand * 0xffffff)
    current_user.tags.where(color_code: color_code).first.blank? ? color_code : generate_color_code
  end
end
