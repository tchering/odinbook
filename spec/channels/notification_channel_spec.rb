require 'rails_helper'

RSpec.describe NotificationChannel, type: :channel do
  it 'successfully subscribes and streams for the current user' do
    user = create(:user)
    stub_connection current_user: user

    subscribe(channel: "NotificationChannel")

    expect(subscription).to be_confirmed
    expect(streams).to include("notification_#{user.id}")
  end

  it 'receives and handles data correctly' do
    user = create(:user)
    stub_connection current_user: user
    subscribe(channel: "NotificationChannel")

    expect {
      ActionCable.server.broadcast("notification_#{user.id}", { count: 5, sender_id: 1 })
    }.to have_broadcasted_to("notification_#{user.id}").with(hash_including(count: 5, sender_id: 1))
  end
end
