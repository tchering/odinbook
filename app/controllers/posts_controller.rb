class PostsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_post, only: [:show, :destroy, :edit, :update]

  def index
    @posts = Post.includes(:author).recent
    respond_to do |format|
      format.html { }
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("posts_container", partial: "posts/post", locals: { post: @post })
      end
    end
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
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(dom_id(@post),
                                                  partial: "posts/edit_form", locals: { post: Post.new })
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to posts_path, notice: "Post has been updated" }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(dom_id(@post), partial: "posts/post", locals: { post: @post })
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @post && @post.destroy
        format.html { redirect_to root_path, notice: "Post deleted" }
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove(dom_id(@post))
        end
      else
        format.html { redirect_to root_path, error: "Please try again later", status: :unprocessable_entity }
      end
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
