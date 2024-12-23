# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  belongs_to :wall_owner, class_name: "User", foreign_key: "wall_owner_id", optional: true

  validates :body, presence: true, length: { minimum: 5, maximum: 500 }

  scope :recent, -> { order(created_at: :desc) }

  has_many :comments, dependent: :destroy

  has_one_attached :image

  has_many :likes, as: :likeable, dependent: :destroy

  validate :acceptable_image, if: -> { image.attached? }

  def display_image
    return unless image.attached?

    image.variant(resize_to_limit: [500, 500])
  end

  private

  def acceptable_image
    # Check content type
    unless image.content_type.in?(%w[image/png image/jpg image/jpeg image/gif])
      errors.add(:image, "must be a PNG, JPG, JPEG or GIF")
    end

    # Check file size
    return if image.byte_size <= 5.megabytes

    errors.add(:image, "should be less than 5MB")
  end
end
