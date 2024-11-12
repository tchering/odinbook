class MessagesController < ApplicationController
  def create
    @message = current_user.sent_messages.build(message_params)
    if @message.save
      ActionCable.server.broadcast(
        "private_chat_#{[@message.sender_id, @message.recipient_id].sort.join("_")}",
        @message.as_json(include: :sender)
      )
    end
  end

  def chat
    @recipient = User.find(params[:id])
    @message = Message.new
    @messages = Message.includes(:sender).where(
      "(sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)",
      current_user.id, @recipient.id, @recipient.id, current_user.id
    ).order(created_at: :asc)
  end

  private

  def message_params
    params.require(:message).permit(:body, :recipient_id, :sender_id)
  end
end
