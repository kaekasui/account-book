class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_user!, only: [:new]
  prepend_before_filter :authenticate_scope!, only: [:edit, :update, :destroy, :mypage]

  def new
    super
  end

  def create
    super
  end

  def edit
    super
  end

  def update
    super
  end

  def mypage
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
  end

  protected

  def after_update_path_for(resource)
    users_mypage_path
  end
end
