class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, only: [ :new, :create ]
  skip_before_action :authenticate_user!, only: [:new]
  prepend_before_filter :authenticate_scope!, only: [:edit, :update, :edit_email, :update_email, :destroy, :mypage, :send_unconfirmed_email, :delete_unconfirmed_email]

  def new
    super
  end

  def create
    super
  end

  def edit
    super
  end

  def edit_email
    render :edit_email
  end

  def update_email
    email = resource_params[:email]
    if email == resource.email
      error_message = email.blank? ? I18n.t("errors.messages.blank") : I18n.t("messages.users.same")
      resource.errors.add(:email, error_message)
      render :edit_email
    else
      resource.unconfirmed_email = email
      resource.send_confirmation_instructions

      if successfully_sent?(resource)
        set_flash_message(:notice, :confirmed) if is_flashing_format?
        respond_with resource, location: users_mypage_path
      else
        set_flash_message(:alert, I18n.t("messages.errors.send_email")) if is_flashing_format?
        respond_with resource, location: users_edit_email_path
      end
    end
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

  def delete_unconfirmed_email
    user = User.where(id: current_user.id).first
    user.update_attributes(unconfirmed_email: nil)
    flash[:notice] = I18n.t("messages.users.delete_an_unconfirmed_email")
    rescue => ex
    flash[:alert] = I18n.t("messages.errors.delete_an_unconfirmed_email")
    ensure
    redirect_to users_mypage_path
  end

  def send_unconfirmed_email
    resource.send_confirmation_instructions
    if successfully_sent?(resource)
      set_flash_message(:notice, :confirmed) if is_flashing_format?
      respond_with resource, location: users_mypage_path
    else
      set_flash_message(:alert, I18n.t("messages.errors.send_email")) if is_flashing_format?
      respond_with resource, location: users_edit_email_path
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
