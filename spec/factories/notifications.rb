FactoryBot.define do
  factory :notification do
    sender { nil }
    recipient { nil }
    message { nil }
    read { false }
  end
end
