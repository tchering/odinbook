# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    return unless user_signed_in?
    @user = current_user
    @post = current_user.posts.build
    @posts = Post.includes(:author,
                           image_attachment: :blob,
                           author: { avatar_attachment: :blob })
                 .recent
  end
end
