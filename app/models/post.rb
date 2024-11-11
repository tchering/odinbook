class Post < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "user_id"

  validates :body, presence: true, length: { minimum: 5, maximum: 300 }

  scope :recent, -> { order(created_at: :desc) }

  has_many :comments, dependent: :destroy

  has_one_attached :image
  validates :image, content_type: { in: ["image/png", "image/jpg", "image/jpeg", "image/gif"], message: "must be a PNG, JPG, JPEG or GIF" }, size: { less_than: 2.megabytes, message: "should be less than 2MB" }

  def display_image
    if image.attached?
      image.variant(resize_to_limit: [500, 500])
    end
  end
end
