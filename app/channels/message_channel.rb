class MessageChannel < ApplicationCable::Channel
  def subscribed
    recipient_id = params[:recipient_id].to_i #passed from the message_channel.js
    current_user_id = params[:current_user_id].to_i
    stream_name = [current_user_id, recipient_id].sort.join("_")
    stream_from "private_chat_#{stream_name}"
  end

  # above i tried stream_name=[current_user.id,recipient_id].sort.join("_") but it was not working so i changed it to above line. The problem was when user logs in for first time even though message is saved in db but the message was not displayed in chat window. So i changed the stream_name to above line and it worked.

  def speak(data)
    sender_id = data["sender_id"]
    recipient_id = data["recipient_id"]
    message = data["message"]
    message = Message.create(body: message, sender_id: sender_id, recipient_id: recipient_id)
    ActionCable.server.broadcast("private_chat_#{[sender_id, recipient_id].sort.join("_")}", message.as_json(include: :sender))
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
    # User.find(current_user.id).update(online: false)
    # broadcast_to("presence_channel", { user: current_user.id, status: "offline" })
  end
end
