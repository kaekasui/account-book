# Common methods for administrators.
class Admin::AdminBaseController < ApplicationController
  before_action :admin_authentication

  private

  def admin_authentication
    redirect_to root_path if !current_user || !current_user.admin
  end
end
