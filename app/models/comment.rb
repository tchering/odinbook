class Comment < ApplicationRecord
  belongs_to :post, counter_cache: true, touch: true
  belongs_to :author, class_name: "User", foreign_key: "user_id"

  scope :recent, -> { order(created_at: :desc) }

  validates :body, presence: true, length: { minimum: 1 }

  has_many :likes, as: :likeable, dependent: :destroy
end
