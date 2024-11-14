class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  has_many :notifications, dependent: :destroy

  validates :body, presence: true, length: { minimum: 1, maximum: 300 }
end
