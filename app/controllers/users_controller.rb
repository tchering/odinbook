# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  include ActionView::RecordIdentifier

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @post = current_user.posts.build(wall_owner: @user)

    if @user
      @posts = @user.wall_posts
                    .includes(author: :avatar_attachment, image_attachment: :blob)
                    .recent
    else
      redirect_to users_path, notice: "User not found" and return
    end
  end
end
