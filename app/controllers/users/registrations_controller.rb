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
=begin
    send(:"authenticate_#{resource_name}!", force: true)
    self.resource = OriginalUser.find_by_code(current_user.code)
    render :edit
=end
  end

  def update
    super
=begin
    self.resource = resource_class.to_adapter.get!(OriginalUser.find_by_code(current_user.code).to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    updated_password = if resource.encrypted_password.blank?
      resource.update(account_update_params)
    else
      resource.update_with_password(account_update_params)
    end
    if updated_password
      yield resource if block_given?
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ? :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
=end
  end

  def mypage
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
  end

=begin
  def show
    @original_user = OriginalUser.find_by_code(current_user.code) || OriginalUser.new
    @virtual_user = VirtualUser.where(code: current_user.code, created_at: Time.now.all_day).last
    @twitter_user = TwitterUser.find_by_code(current_user.code) || TwitterUser.new
  end

  def email
    @user = VirtualUser.where(code: current_user.code, created_at: Time.now.all_day).last || VirtualUser.new
  end

  def send_email
    @user = VirtualUser.where(code: current_user.code, created_at: Time.now.all_day).last || VirtualUser.new
    respond_to do |format|
      if @user.update_attributes(email: user_email_param["email"], code: current_user.code)
        NoticeMailer.change_email(@user).deliver
        format.html { redirect_to users_profile_path, notice: I18n.t("messages.send_mail") }
      else
        format.html { render "email" }
      end
    end
  end

  def name
    @user = OriginalUser.find_by_code(current_user.code) || OriginalUser.new
  end

  def update_name
    @user = OriginalUser.find_by_code(current_user.code) || OriginalUser.new
    respond_to do |format|
      if @user.update_attributes(name: user_name_param["name"], code: current_user.code)
        format.html { redirect_to users_profile_path, notice: I18n.t("messages.update_user_name") }
      else
        format.html { render "name" }
      end
    end
  end

  def update_email
    @virtual_user = VirtualUser.where(code: current_user.code, created_at: Time.now.all_day).first
    @original_user = OriginalUser.find_by_code(current_user.code) || OriginalUser.new(code: current_user.code)

    respond_to do |format|
      if user_code_param == current_user.code
        if @virtual_user
          @original_user.email = @virtual_user.email
          if @original_user.save
            @virtual_user.destroy
            format.html { redirect_to users_profile_path, notice: I18n.t("messages.update_user_email") }
          else
            format.html { redirect_to users_profile_path, alert: I18n.t("errors.messages.update_user_email") }
          end
        else
          format.html { redirect_to users_profile_path, alert: I18n.t("errors.messages.no_virtual_email") }
        end
      else
        format.html { redirect_to root_path, alert: I18n.t("errors.messages.failure_url_code") }
      end
    end
  end

  private
  def sign_up_params
    params = devise_parameter_sanitizer.sanitize(:sign_up)
    params.store("type", "OriginalUser")
    params
  end

  def user_email_param
    params.require(:virtual_user).permit(:email)
  end

  def user_name_param
    params.require(:original_user).permit(:name)
  end

  def user_code_param
    params.require(:code)
  end

  protected
  def after_update_path_for(resource)
    users_profile_path
  end
=end
end
