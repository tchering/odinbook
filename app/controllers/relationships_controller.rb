class RelationshipsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_user, only: [:follow, :unfollow]

  def follow
    current_user.follow(@user)
    respond_to do |format|
      format.html { }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("follow_button_#{dom_id(@user)}", partial: "shared/follow_unfollow", locals: { user: @user })
      end
    end
  end

  def unfollow
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("follow_button_#{dom_id(@user)}", partial: "shared/follow_unfollow", locals: { user: @user })
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
