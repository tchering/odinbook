class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :author, class_name: "User", foreign_key: "user_id"

  scope :recent, -> { order(created_at: :desc) }

  validates :body, presence: true, length: { minimum: 1 }
end
