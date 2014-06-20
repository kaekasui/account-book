class CsvController < ApplicationController

  def new
  end

  def import
    respond_to do |format|
      unless params[:csv_file].blank?
        @error_messages = Record.import_csv(params[:csv_file])
        if @error_messages.blank?
          format.html { redirect_to records_path }
        else
          format.html { render :new }
        end
      else
        format.html { redirect_to csv_new_path }
      end
    end
  end
end
