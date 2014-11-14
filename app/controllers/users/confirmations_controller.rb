class Users::ConfirmationsController < Devise::ConfirmationsController

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    @confirmation_type = params[:confirmation_type]
    yield resource if block_given?

    if resource.errors.empty?
      if @confirmation_type == 'edit'
        set_flash_message(:notice, :update_email) if is_flashing_format?
      else
        set_flash_message(:notice, :confirmed) if is_flashing_format?
      end
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
  end

  protected

    def after_confirmation_path_for(resource_name, resource)
      if signed_in?(resource_name)
        if @confirmation_type == 'edit'
          users_mypage_path
        else
          signed_in_root_path(resource)
        end
      else
        new_session_path(resource_name)
      end
    end
end
