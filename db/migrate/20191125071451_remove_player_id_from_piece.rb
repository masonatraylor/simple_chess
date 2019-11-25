class RemovePlayerIdFromPiece < ActiveRecord::Migration[5.2]
  def change
    remove_column :pieces, :player_id
  end
end
