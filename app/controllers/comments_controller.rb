# frozen_string_literal: true

class CommentsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_post, only: [:new, :create, :edit, :update, :destroy, :index]

  def index
    # @post = Post.find(params[:post_id])

    # debugger

    @comments = @post.comments.includes(:author).recent
  end

  def new
    # @post = Post.find(params[:post_id])
    @comment = @post.comments.build
    respond_to do |format|
      format.html { }
      format.turbo_stream
    end
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.author = current_user
    respond_to do |format|
      streams = []
      if @comment.save
        if @post.comments.count == 1
          streams << turbo_stream.remove("empty_state_#{dom_id(@post)}")
        end

        # add new comment
        streams << turbo_stream.prepend("after_post_comment", partial: "comments/comment", locals: { comment: @comment })
        #reset form
        streams << turbo_stream.replace("new_comment_form", partial: "comments/form", locals: { comment: Comment.new })
        format.html { }
        format.turbo_stream { render turbo_stream: streams }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    respond_to do |format|
      if @comment.destroy
        format.html { }
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove("comment_#{dom_id(@comment)}")
        end
      else
        format.turbo_stream do
          render turbo_stream: { notice: "Unable to delete the comment" }
        end
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_post
    @post = Post.find_by(id: params[:post_id])
  end
end
