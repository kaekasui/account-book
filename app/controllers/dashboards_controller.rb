class DashboardsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
  end

  def set_graph
    @graph_data = if current_user
      current_user.monthly_counts.year_data
    else
      {}
    end
  end
end
