# frozen_string_literal: true

FactoryBot.define do
  factory :relationship do
    follower_id { nil }
    followed_id { nil }
  end
end
