# User import the csv file, and User download the sample csv file.
class CsvController < ApplicationController
  respond_to :html

  def new
    @record = Record.new
  end

  def import
    @record = current_user.records.new
    @record = @record.import(params[:csv_file])
    flash[:notice] = I18n.t('messages.record.created') unless @record.errors.any?
    respond_with @record, location: csv_new_path
    rescue => ex
    puts ex.message
    render :new
  end
end
