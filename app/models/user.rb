# frozen_string_literal: true

class User < ApplicationRecord
  before_create :set_default_role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_one_attached :avatar
  validates :avatar, content_type: {
                       in: ["image/png", "image/jpg", "image/jpeg", "image/gif"],
                       message: "must be a PNG, JPG, JPEG or GIF",
                     },
                     size: {
                       less_than: 2.megabytes,
                       message: "should be less than 2MB",
                     }

  has_many :likes, dependent: :destroy

  # relationships association
  has_many :active_relationship, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :active_relationship, source: :followed

  has_many :passive_relationship, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationship, source: :follower

  # messages association
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy
  has_many :received_messages, class_name: "Message", foreign_key: "recipient_id", dependent: :destroy

  # notifications association
  has_many :sent_notifications, class_name: "Notification", foreign_key: "sender_id", dependent: :destroy
  has_many :received_notifications, class_name: "Notification", foreign_key: "recipient_id", dependent: :destroy

  def follow(other_user)
    self.followings << other_user
  end

  def unfollow(other_user)
    self.followings.delete(other_user)
  end

  def display_avatar
    if avatar.attached?
      avatar.variant(resize_to_limit: [140, 140])
    else
      "default_avatar.png"
    end
  end

  def grouped_unread_notifications
    received_notifications
      .unread
      .includes(:message, sender: { avatar_attachment: :blob })
      .group_by(&:sender_id)
      .transform_values { |notifications| notifications.max_by(&:created_at) }
  end

  private

  def set_default_role
    self.role = "user"
  end
end
