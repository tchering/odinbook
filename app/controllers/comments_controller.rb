# frozen_string_literal: true

class CommentsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_post, only: [:new, :create, :edit, :update, :destroy, :index]

  def index
    # @post = Post.find(params[:post_id])

    # debugger

    @comments = @post.comments
    respond_to do |format|
      format.html { }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("comments_#{dom_id(@post)}", partial: "comments/comments_list", locals: { comments: @comments })
      end
    end
  end

  def new
    # @post = Post.find(params[:post_id])
    @comment = @post.comments.build
  end

  def create
    @comment = @post.comments.build(comment_params)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to comments_path }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :post_id, :user_id)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end
end
