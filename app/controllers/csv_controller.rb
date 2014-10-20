class CsvController < ApplicationController

  def new
    @record = Record.new
  end

  def import
    @record = current_user.records.new
    respond_to do |format|
      if params[:csv_file].present?
        filename = params[:csv_file].original_filename
        if filename.rindex('.').present? and (filename.slice((filename.rindex('.') + 1), (filename.rindex('.') + 3))) == 'csv'
          @record = @record.csv_import(params[:csv_file])
          if @record.errors.any?
            format.html { render :new }
          else
            flash[:notice] = I18n.t("messages.record.created")
            format.html { redirect_to csv_new_path }
          end
        else
          @record.errors[:base] << I18n.t("messages.record.import_file_is_not_csv")
          format.html { render :new }
        end
      else
        @record.errors[:base] << I18n.t("messages.record.import_file_not_found")
        format.html { render :new }
      end
    end
    rescue => ex
    puts ex.message
    render :new
  end
end
