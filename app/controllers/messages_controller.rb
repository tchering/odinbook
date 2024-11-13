class MessagesController < ApplicationController
  def chat
    @conversations = User.joins("INNER JOIN messages ON users.id = messages.sender_id OR users.id = messages.recipient_id")
                         .where("messages.sender_id = :user_id OR messages.recipient_id = :user_id", user_id: current_user.id)
                         .where.not(id: current_user.id)
                         .distinct.includes(avatar_attachment: :blob)
    @recipient = User.find(params[:id])
    @messages = Message.where(sender_id: current_user.id, recipient_id: @recipient.id)
                       .or(Message.where(sender_id: @recipient.id, recipient_id: current_user.id)).includes(:sender)
                       .order(created_at: :asc)
    @message = Message.new
  end

  def create
    @message = current_user.sent_messages.build(message_params)
    if @message.save
      ActionCable.server.broadcast(
        "private_chat_#{[@message.sender_id, @message.recipient_id].sort.join("_")}",
        @message.as_json(include: :sender)
      )
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_message_path(@message.recipient_id) }
      end
    else
      render :chat
    end
  end

  private

  def message_params
    params.require(:message).permit(:recipient_id, :body)
  end
end
