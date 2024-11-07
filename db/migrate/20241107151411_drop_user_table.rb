class DropUserTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :users
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
