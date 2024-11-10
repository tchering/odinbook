class UsersController < ApplicationController
  include ActionView::RecordIdentifier

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    @posts = @user.posts.includes(:author).recent
    unless @user
      redirect_to users_path, notice: "No user found"
    end
  end
end
