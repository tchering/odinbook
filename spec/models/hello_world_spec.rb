# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HelloWorld, type: :model do
  it 'returns hello world' do
    hello = HelloWorld.new
    expect(hello.greet).to eq('Hello, World!')
  end
end
