FactoryBot.define do
  factory :message do
    body { "MyText" }
    sender { nil }
    recipient { nil }
  end
end
