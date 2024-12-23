# frozen_string_literal: true

class CreateRelationships < ActiveRecord::Migration[7.1]
  def change
    create_table :relationships do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followed, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    # Ex:- add_index("admin_users", "username")
    add_index :relationships, %i[follower_id followed_id], unique: true
  end
end
