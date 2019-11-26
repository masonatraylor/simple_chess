# frozen_string_literal: true

class King < Piece
  def valid_move?(xpos, ypos)
    (valid_step_move?(xpos, ypos) ||
      valid_castling_move?(xpos, ypos)) &&
      super(xpos, ypos)
  end

  def valid_step_move?(xpos, ypos)
    (xpos - x_position).abs <= 1 && (ypos - y_position).abs <= 1
  end

  def valid_castling_move?(xpos, ypos)
    !moved? &&
      ypos == y_position &&
      rook_for_castle(xpos, ypos) &&
      !game.check?(color) &&
      can_castle_to_square?(xpos, ypos)
  end

  def rook_for_castle(xpos, ypos)
    rook_x = xpos + inc(x_position, xpos)
    piece = game.piece_at(rook_x, ypos)
    piece&.color == color &&
      piece.type == 'Rook' &&
      !piece.moved? &&
      piece
  end

  def can_castle_to_square?(xpos, ypos)
    until xpos == x_position
      return false if space_taken_or_in_check?(xpos, ypos)

      xpos += inc(xpos, x_position)
    end

    true
  end

  def space_taken_or_in_check?(xpos, ypos)
    game.piece_at(xpos, ypos) ||
      opponent_pieces.any? { |p| p.valid_move?(xpos, ypos) }
  end

  def move_to!(xpos, ypos)
    if valid_castling_move?(xpos, ypos)
      rook = rook_for_castle(xpos, ypos)
      rook_x = xpos + inc(rook.x_position, xpos)
      rook.update_attributes(x_position: rook_x, y_position: ypos)
    end
    super(xpos, ypos)
  end
end
