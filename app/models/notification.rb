class Notification < ApplicationRecord
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"
  belongs_to :message, optional: true

  scope :unread, -> { where(read: false) }

  after_create :broadcast_notification

  private

  def broadcast_notification
    ActionCable.server.broadcast(
      "notification_#{recipient.id}",
      { count: recipient.received_notifications.unread.count,
        sender_id: sender.id }
    )
  end
end
