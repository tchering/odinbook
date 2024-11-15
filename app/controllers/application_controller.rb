# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :load_notifications

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
