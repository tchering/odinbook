# frozen_string_literal: true

# spec/models/like_spec.rb
require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post) }

  describe 'validations' do
    it 'allows user to like a post' do
      like = FactoryBot.build(:like, user: user, likeable: post)
      expect(like).to be_valid
    end

    it 'prevents user from liking same post twice' do
      FactoryBot.create(:like, user: user, likeable: post)
      duplicate_like = FactoryBot.build(:like, user: user, likeable: post)
      expect(duplicate_like).not_to be_valid
    end
  end
end
