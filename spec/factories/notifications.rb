FactoryBot.define do
  factory :notification do
    sender { association :user }
    recipient { association :user }
    message { association :message }
    read { false }
  end
end
