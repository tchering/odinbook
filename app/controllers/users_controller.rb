# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  include ActionView::RecordIdentifier

  def index
    @users = User.includes(avatar_attachment: :blob).all
  end

  def show
    @user = User.find(params[:id])
    @post = current_user.posts.build(wall_owner: @user)

    if @user
      wall_posts = @user.wall_posts
      following_posts = Post.where(user_id: @user.following_ids)

      @posts = Post.where(id: wall_posts.pluck(:id) + following_posts.pluck(:id))
                   .includes(
                     :wall_owner,
                     author: { avatar_attachment: :blob },
                     image_attachment: :blob,
                   )
                   .recent
    else
      redirect_to users_path, notice: "User not found" and return
    end
  end
end
