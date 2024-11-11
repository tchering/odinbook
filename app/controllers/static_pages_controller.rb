class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @post = current_user.posts.build
      @posts = Post.includes(:author,
                             image_attachment: :blob,
                             author: { avatar_attachment: :blob })
                   .recent
    end
  end
end
