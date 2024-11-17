# frozen_string_literal: true

class User < ApplicationRecord
  before_create :set_default_role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github]

  # Method to find or create a user from OmniAuth data
  def self.from_omniauth(auth)
    # Find the user by provider and UID
    user = where(provider: auth.provider, uid: auth.uid).first

    # If user exists, return it
    return user if user

    # If user doesn't exist, create a new one
    where(email: auth.info.email).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name || auth.info.nickname
      user.email = auth.info.email # Assuming the user model has an email
      user.password = Devise.friendly_token[0, 20]
      #this is the line that was causing too many errors
      attach_avatar(user, auth.info.image) if auth.info.image.present? # Assuming you have an avatar field or attachment
      # Add any additional user fields here
    end
  end

  validates :name, presence: true
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_many :posts, dependent: :destroy
  has_many :wall_posts, class_name: "Post", foreign_key: "wall_owner_id", dependent: :destroy

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

  def self.attach_avatar(user, image_url)
    begin
      downloaded_image = URI.open(image_url)
      user.avatar.attach(
        io: downloaded_image,
        filename: "avatar-#{user.uid}.jpg",
      )
    rescue => e
      Rails.logger.error "Failed to attach avatar: #{e.message}"
    end
  end
end
