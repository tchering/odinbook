# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    return unless user_signed_in?
    @user = current_user
    @post = current_user.posts.build
    @posts = Post.includes(:wall_owner,
                           :author,
                           author: { avatar_attachment: :blob },
                           image_attachment: :blob)
      .recent

    @conversations = User.joins("INNER JOIN messages ON users.id = messages.sender_id OR users.id = messages.recipient_id")
      .where("messages.sender_id = :user_id OR messages.recipient_id = :user_id", user_id: current_user.id)
      .where.not(id: current_user.id)
      .distinct.includes(avatar_attachment: :blob)
  end
end
