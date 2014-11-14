# User signs in and out.
class Users::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: [:new]

  def new
    super
  end

  def create
    super
  end
end
