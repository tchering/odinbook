class UsersController < ApplicationController
  def index
    @users = User.includes(:posts).all
  end

  def show
    @user = User.find_by(id: params[:id])
    @posts = @user.posts
    unless @user
      redirect_to users_path, notice: "No user found"
    end
  end
end
