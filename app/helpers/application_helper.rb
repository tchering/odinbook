# frozen_string_literal: true

module ApplicationHelper
  def admin_or_author?(post)
    current_user && (current_user.admin? || post.author == current_user)
  end
end
