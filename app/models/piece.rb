# frozen_string_literal: true

class Piece < ApplicationRecord
  include PiecesHelper
  belongs_to :game

  def at_coord?(xpos, ypos)
    x_position == xpos && y_position == ypos
  end

  def color
    white? ? :white : :black
  end

  def opposite_color
    white? ? :black : :white
  end

  def enemy_piece_at?(xpos, ypos)
    game.piece_at(xpos, ypos)&.color == opposite_color
  end

  def valid_move?(xpos, ypos)
    Piece.on_board?(xpos, ypos) &&
      color != game.piece_at(xpos, ypos)&.color &&
      !obstructed?(xpos, ypos) &&
      !would_be_in_check?(xpos, ypos)
  end

  def valid_moves
    return [] unless x_position && y_position

    all_coords = (0..7).to_a.product((0..7).to_a)
    all_coords.filter { |x, y| valid_move?(x, y) }
  end

  def move_to!(xpos, ypos)
    game.piece_at(xpos, ypos)&.remove!
    update_attributes(x_position: xpos, y_position: ypos, moved: true)
    game.update_attributes(en_passant_pawn: nil)
    game.pieces.reload
  end

  def remove!
    update_attributes(x_position: nil, y_position: nil)
  end

  def obstructed?(xpos, ypos)
    return false unless valid_coords_for_obstruction?(xpos, ypos)

    x_inc = inc(xpos, x_position)
    y_inc = inc(ypos, y_position)

    # Only check squares between the two endpoints
    until xpos + x_inc == x_position && ypos + y_inc == y_position
      xpos += x_inc
      ypos += y_inc

      return true if game.piece_at(xpos, ypos)
    end

    false
  end

  def can_take?(piece)
    valid_move?(piece.x_position, piece.y_position)
  end

  def on_board?
    Piece.on_board?(x_position, y_position)
  end

  def self.on_board?(xpos, ypos)
    return false unless xpos && ypos

    [xpos, ypos].min >= 0 && [xpos, ypos].max <= 7
  end

  def friendly_pieces
    game.pieces_for(color)
  end

  def opponent_pieces
    game.pieces_for(opposite_color)
  end

  def player_id
    white? ? game.white_player_id : game.black_player_id
  end

  def can_move?(user)
    on_board? && my_turn? && user.id == player_id
  end

  def my_turn?
    game.turn_color == color
  end

  private

  def valid_coords_for_obstruction?(xpos, ypos)
    x_diff = xpos - x_position
    y_diff = ypos - y_position
    x_diff.zero? || y_diff.zero? || x_diff.abs == y_diff.abs
  end

  def inc(from, to)
    return 1 if from < to
    return -1 if from > to

    0
  end

  def would_be_in_check?(xpos, ypos)
    target = game.piece_at(xpos, ypos)

    # Would not be in check if this move ends the game
    return false if target&.type == 'King'

    previous_attrs = attributes
    previous_target_attrs = target&.attributes

    begin
      update_attributes(x_position: xpos, y_position: ypos)
      target&.update_attributes(x_position: nil, y_position: nil)
      game.pieces.reload
      return game.check?(color)
    ensure
      update_attributes(previous_attrs)
      target&.update_attributes(previous_target_attrs)
      game.pieces.reload
    end
  end
end
