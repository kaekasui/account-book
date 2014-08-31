class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, only: [ :new, :create ]
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

  def cancel
    @cancel = Cancel.new
  end

  def destroy
    @cancel = Cancel.new(cancel_params)
    @cancel.user_id = current_user.id
    if @cancel.save
      super
    else
      render :cancel
    end
  end

  protected

  def after_update_path_for(resource)
    users_mypage_path
  end

  def cancel_params
    params.require(:cancel).permit(:content)
  end
end
