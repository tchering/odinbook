# frozen_string_literal: true

class CreateLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :likeable, polymorphic: true, null: false

      t.timestamps
    end
    # need to add this so that a user can only like a post once
    add_index :likes, %i[user_id likeable_id likeable_type], unique: true
    # Ex:- add_index("admin_users", "username")
  end
end
