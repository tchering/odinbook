# frozen_string_literal: true

# spec/factories/likes.rb
FactoryBot.define do
  factory :like do
    association :user
    association :likeable, factory: :post
  end
end
