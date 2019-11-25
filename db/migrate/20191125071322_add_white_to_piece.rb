class AddWhiteToPiece < ActiveRecord::Migration[5.2]
  def change
    add_column :pieces, :white, :boolean, default: true
    add_index :pieces, :white
  end
end
