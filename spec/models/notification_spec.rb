require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'callbacks' do
    describe 'after_create :broadcast_notification' do
      it 'broadcasts notification with correct count and sender_id' do
        recipient = create(:user)
        sender = create(:user)
        message = create(:message)
        expect {
          Notification.create!(recipient: recipient, sender: sender, message: message)
        }.to have_broadcasted_to("notification_#{recipient.id}").with(
          hash_including(count: recipient.received_notifications.unread.count, sender_id: sender.id)
        )
      end
    end
  end
end
