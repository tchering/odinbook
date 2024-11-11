# spec/factories/posts.rb
FactoryBot.define do
  factory :post do
    body { "Test post content" }
    association :author, factory: :user
  end
end

