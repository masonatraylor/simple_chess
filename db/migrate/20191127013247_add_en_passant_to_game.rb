class AddEnPassantToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :en_passant_pawn, :integer
  end
end
