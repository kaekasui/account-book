# Common methods for administrators.
class Admin::AdminBaseController < ApplicationController
  before_action :admin_authentication

  private

  def admin_authentication
    if !current_user || !current_user.admin
      redirect_to root_path
    end
  end
end
