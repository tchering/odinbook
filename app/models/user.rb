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

  # def display_avatar
  #   if avatar.attached?
  #     avatar.image.variant(resize: "100x100!").processed
  #   else
  #     "/default_avatar.png"
  #   end
  # end

  def display_avatar
    if avatar.attached?
      avatar.variant(resize_to_limit: [140, 140])
    else
      "/default_avatar.png"
    end
  end

  private

  def set_default_role
    self.role = "user"
  end
end
