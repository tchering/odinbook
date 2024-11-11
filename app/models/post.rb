class Post < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "user_id"

  validates :body, presence: true, length: { minimum: 5, maximum: 300 }

  scope :recent, -> { order(created_at: :desc) }

  has_many :comments, dependent: :destroy

  has_one_attached :image

  validate :acceptable_image, if: -> { image.attached? }

  def display_image
    if image.attached?
      image.variant(resize_to_limit: [500, 500])
    end
  end

  private

  def acceptable_image
    # Check content type
    unless image.content_type.in?(%w[image/png image/jpg image/jpeg image/gif])
      errors.add(:image, "must be a PNG, JPG, JPEG or GIF")
    end

    # Check file size
    unless image.byte_size <= 2.megabytes
      errors.add(:image, "should be less than 2MB")
    end
  end
end
