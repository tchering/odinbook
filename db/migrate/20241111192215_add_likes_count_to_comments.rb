
class AddLikesCountToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :likes_count, :integer, default: 0, null: false

    # Reset existing counters
    reversible do |dir|
      dir.up do
        Comment.find_each do |comment|
          Comment.reset_counters(comment.id, :likes)
        end
      end
    end
  end
end
