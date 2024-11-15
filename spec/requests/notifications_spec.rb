require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  let(:sender) { create(:user) }
  let(:recipient) { create(:user) }
  let(:message) { create(:message) }

  describe "POST /mark_as_read" do
    before do
      sign_in recipient
      create_list(:notification, 3, sender: sender, recipient: recipient, message: message, read: false)
    end

    it "marks notifications as read and broadcasts the updated count" do
      expect {
        post mark_as_read_notifications_path, params: { sender_id: sender.id }
      }.to change { Notification.where(sender: sender, recipient: recipient, read: false).count }.from(3).to(0)

      expect(response).to have_http_status(:ok)
      expect(ActionCable.server).to have_broadcasted_to("notification_#{recipient.id}").with(hash_including(count: 0))
    end
  end

  describe "GET /index" do
    before do
      sign_in recipient
      create_list(:notification, 2, sender: sender, recipient: recipient, message: message, read: false)
    end

    it "retrieves the list of notifications" do
      get notifications_path(post_id: some_post.id)
      expect(response).to have_http_status(:success)
      expect(assigns(:notifications)).to eq(recipient.received_notifications.includes(:sender, author: { avatar_attachment: :blob }).recent)
    end
  end
end
