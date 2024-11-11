class LikesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_likeable

  # def create
  #   @like = @likeable.likes.build(user: current_user)
  #   respond_to do |format|
  #     if @like.save
  #       format.turbo_stream do
  #         render turbo_stream: [
  #           turbo_stream.replace("like_#{dom_id(@likeable)}",
  #                                partial: "shared/like_button",
  #                                locals: { likeable: @likeable }),
  #           turbo_stream.replace("likes_count_#{dom_id(@likeable)}",
  #                                html: @likeable.likes_count),
  #         ]
  #       end
  #     end
  #   end
  # end

  def create
    @like = @likeable.likes.build(user: current_user)
    streams = []
    respond_to do |format|
      if @like.save
        format.html { }
        streams << turbo_stream.replace("like_#{dom_id(@likeable)}", partial: "shared/like_button", locals: { likeable: @likeable })
        streams << turbo_stream.replace("likes_count_#{dom_id(@likeable)}", html: @likeable.likes_count)
        format.turbo_stream { render turbo_stream: streams }
      end
    end
  end

  # def destroy
  #   @like = current_user.likes.find_by(likeable: @likeable)
  #   respond_to do |format|
  #     if @like.destroy
  #       format.turbo_stream do
  #         render turbo_stream: [
  #           turbo_stream.replace("like_#{dom_id(@likeable)}",
  #                                partial: "shared/like_button",
  #                                locals: { likeable: @likeable }),
  #           turbo_stream.replace("likes_count_#{dom_id(@likeable)}",
  #                                html: @likeable.likes_count),
  #         ]
  #       end
  #     end
  #   end
  # end

  def destroy
    @like = current_user.likes.find_by(likeable: @likeable)
    streams = []
    respond_to do |format|
      if @like.destroy
        streams << turbo_stream.replace("like_#{dom_id(@likeable)}", partial: "shared/like_button", locals: { likeable: @likeable })
        streams << turbo_stream.replace("likes_count_#{dom_id(@likeable)}", html: @likeable.reload.likes_count)
        format.turbo_stream { render turbo_stream: streams }
      end
    end
  end

  private

  def set_likeable
    if params[:post_id]
      @likeable = Post.find(params[:post_id])
    elsif params[:comment_id]
      @likeable = Comment.find(params[:comment_id])
    end
  end
end
