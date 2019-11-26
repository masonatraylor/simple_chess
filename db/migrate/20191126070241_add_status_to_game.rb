class AddStatusToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :status, :integer, default: 0
    add_index :games, :status
  end
end
