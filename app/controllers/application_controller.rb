# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :load_notifications, if: :user_signed_in?  # Only load if user is signed in

  # def after_sign_in_path_for(resource)
  #   dashboard_path # Replace with the desired path
  # end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name role avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name role avatar])
  end

  private

  def load_notifications
    @notifications = current_user.received_notifications
      .includes(:message, :sender, sender: { avatar_attachment: :blob })
      .unread
      .order(created_at: :desc)
  end
end
