class AddWallOwnerToPosts < ActiveRecord::Migration[7.1]
  def change
    add_reference :posts, :wall_owner, foreign_key: { to_table: :users }
  end
end
