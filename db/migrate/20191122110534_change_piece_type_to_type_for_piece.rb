class ChangePieceTypeToTypeForPiece < ActiveRecord::Migration[5.2]
  def change
    rename_column :pieces, :piece_type, :type
  end
end
