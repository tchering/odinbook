class MessagesController < ApplicationController
  def chat
    @conversations = load_conversations
    @recipient = User.find(params[:id])
    @messages = Message.where(sender_id: current_user.id, recipient_id: @recipient.id)
                       .or(Message.where(sender_id: @recipient.id, recipient_id: current_user.id)).includes(:sender)
                       .order(created_at: :asc)
    @message = Message.new

    #mark notifications as read
    Notification.where(sender_id: @recipient.id, recipient_id: current_user.id, read: false).update_all(read: true)
    ActionCable.server.broadcast("notification_#{current_user.id}",
                                 {
      count: current_user.received_notifications.unread.count,
    })
  end

  def create
    @message = current_user.sent_messages.build(message_params)

    if @message.save
      @conversations = load_conversations
      create_notification

      # Real-time message update via Action Cable
      ActionCable.server.broadcast(
        "private_chat_#{[@message.sender_id, @message.recipient_id].sort.join("_")}",
        @message.as_json(include: :sender)
      )
    end
  end

  private

  def load_conversations
    @conversations = User.joins("INNER JOIN messages ON users.id = messages.sender_id OR users.id = messages.recipient_id")
      .where("messages.sender_id = :user_id OR messages.recipient_id = :user_id", user_id: current_user.id)
      .where.not(id: current_user.id)
      .distinct.includes(avatar_attachment: :blob)
  end

  def create_notification
    Notification.create(
      recipient_id: @message.recipient_id,
      sender_id: @message.sender_id,
      message_id: @message.id,
      read: false,
    )
  end

  def message_params
    params.require(:message).permit(:recipient_id, :body)
  end
end

# The flow is:

# Message saved and → Creates notification
# Notification created → Broadcasts count to recipient
# User reads notifications → Marks as read → Broadcasts updated count
