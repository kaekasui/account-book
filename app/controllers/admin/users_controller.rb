class Admin::UsersController < Admin::AdminBaseController
  respond_to :html

  def index
    @admin_users = User.all
  end
end
