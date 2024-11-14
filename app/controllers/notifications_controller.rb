class NotificationsController < ApplicationController
  def mark_as_read
    @notifications = current_user.received_notifications.where(sender_id: params[:sender_id], read: false)
    @notifications.update_all(read: true)

    ActionCable.server.broadcast("notification_#{current_user.id}", {
      count: current_user.received_notifications.unread.count,
    })

    head :ok
  end
end
