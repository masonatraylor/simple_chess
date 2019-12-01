# frozen_string_literal: true

class Pawn < Piece
  def valid_move?(xpos, ypos, promotion = nil)
    (valid_step_move?(xpos, ypos) ||
      valid_jump_move?(xpos, ypos) ||
      valid_diagonal_move?(xpos, ypos)) &&
      valid_promotion?(ypos, promotion) &&
      super(xpos, ypos)
  end

  def valid_step_move?(xpos, ypos)
    xpos == x_position &&
      ypos == y_position + dir &&
      !enemy_piece_at?(x_position, y_position + dir)
  end

  def valid_jump_move?(xpos, ypos)
    !moved? &&
      xpos == x_position &&
      ypos == y_position + 2 * dir &&
      !enemy_piece_at?(x_position, y_position + 2 * dir)
  end

  def valid_diagonal_move?(xpos, ypos)
    (xpos - x_position).abs == 1 &&
      ypos == y_position + dir &&
      will_take_piece?(xpos, ypos)
  end

  def will_take_piece?(xpos, ypos)
    enemy_piece_at?(xpos, ypos) || en_passant_take?(xpos, ypos)
  end

  def en_passant_take?(xpos, ypos)
    return false unless game.en_passant_pawn

    Pawn.find(game.en_passant_pawn).at_coord?(xpos, ypos - dir)
  end

  def valid_promotion?(ypos, promotion)
    promotion.nil? ||
      ([0, 7].include?(ypos) &&
      %w[Queen Rook Bishop Knight].include?(promotion))
  end

  def move_to!(xpos, ypos, promotion = nil)
    jump_move = valid_jump_move?(xpos, ypos)
    Pawn.find(game.en_passant_pawn).remove! if en_passant_take?(xpos, ypos)
    super(xpos, ypos)
    game.en_passant_pawn = id if jump_move
    promote_to promotion if promotion
  end

  def promote_to(promotion)
    update_attributes(type: promotion)
  end

  def dir
    white? ? -1 : 1
  end
end
