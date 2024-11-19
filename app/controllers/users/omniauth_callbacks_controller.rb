class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    Rails.logger.debug("Received state: #{params[:state]}")
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # This will sign in the user
      set_flash_message(:notice, :success, kind: "GitHub") if is_navigational_format?
    else
      session["devise.github_data"] = request.env["omniauth.auth"].except("extra") # Remove extra as it can overflow
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    redirect_to root_path, alert: "Authentication failed. Please try again."
  end
end
