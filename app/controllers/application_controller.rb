class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_years, :set_feedback

  private

    def set_years
      if current_user && !@years
        @years = current_user.records.group_by_years
        @current_day = Date.today
      end
    end

    def set_feedback
      @feedback = current_user.feedbacks.new if current_user
    end

    def send_csv(csv, options = {})
      bom = "   "
      bom.setbyte(0, 0xEF)
      bom.setbyte(1, 0xBB)
      bom.setbyte(2, 0xBF)
      send_data bom + csv.to_s, options
    end
end
