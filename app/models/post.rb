class Post < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "user_id"

  validates :body, presence: true, length: { minimum: 5, maximum: 300 }

  scope :recent, -> { order(created_at: :desc) }

  has_many :comments, dependent: :destroy
end
