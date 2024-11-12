class MessageChannel < ApplicationCable::Channel
  def subscribed
    recipient_id = params[:recipient_id].to_i #passed from the message_channel.js
    stream_name = [current_user.id, recipient_id].sort.join("_")
    stream_from "private_chat_#{stream_name}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
