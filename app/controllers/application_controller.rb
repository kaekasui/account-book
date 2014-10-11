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
      @feedback = current_user.feedbacks.new
    end
end
