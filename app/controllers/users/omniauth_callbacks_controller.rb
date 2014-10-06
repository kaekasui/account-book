class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    authorize :twitter do
      session["devise.twitter_data"] = request.env["omniauth.auth"].except('extra')
    end
    rescue => ex
    #set_flash_message(:alert, :failure, kind: "twitter", reason: I18n.t("messages.reason.authentication_failure"))
    set_flash_message(:alert, ex.message)
    puts ex.message
    redirect_to root_path
  end

  private
    def authorize provider
      auth = request.env["omniauth.auth"]
      @user = provider_class(provider).find_for_oauth(auth)
      if @user
        @user.update_with_oauth(auth)
      else
        @user = provider_class(provider).create_with_oauth(auth)
      end
      set_flash_message(:notice, :success, kind: provider)
      sign_in_and_redirect @user, event: :authentication
    end

    def provider_class(provider)
      eval("#{provider.capitalize}User")
    end
end
