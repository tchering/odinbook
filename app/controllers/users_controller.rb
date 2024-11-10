# app/controllers/users_controller.rb
class UsersController < ApplicationController
  include ActionView::RecordIdentifier

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])

    if @user
      @posts = @user.posts.includes(:author).recent
    else
      redirect_to users_path, notice: "User not found" and return
    end
  end
end
