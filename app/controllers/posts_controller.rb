class PostsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_post, only: [:show, :destroy, :edit, :update]

  def index
    @posts = Post.includes(:author).all
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to root_path, notice: "New post added" }
        format.turbo_stream do
          render turbo_stream: turbo_stream.append("posts_container", partial: "post", locals: { post: @post }) +
                               turbo_stream.replace("post_form", partial: "posts/form", locals: { post: Post.new })
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("post_form", partial: "posts/form", locals: { post: Post.new })
        end
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @post && @post.update
        format.html { redirect_to posts_path, notice: "Post has been updated" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @post && @post.destroy
      redirect_to posts_path, notice: "Post has been deleted"
    else
      redirect_to posts_path, error: "Post cannot be deleted"
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end

  def set_post
    @post = Post.find_by(id: params[:id])
    unless @post
      redirect_to posts_path, alert: "Post not found."
    end
  end
end
