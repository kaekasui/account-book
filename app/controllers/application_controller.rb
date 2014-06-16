class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_years

  private

    def set_years
      if current_user && !@years
        @years = current_user.records.group_by_years
        @current_year = Date.today.year
      end
    end
end
