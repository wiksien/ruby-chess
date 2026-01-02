# frozen_string_literal: true

module Pieces
  class << self
    attr_accessor :white, :black
  end

  def self.start_new_game
    @white = {
      # Pawns
      **Array.new(8) do |i|
        [:"pawn#{i + 1}",
         { icon: '♙', currentPosition: [i, 6], moveSetRequiresSpace: pawn_move_set_white_requires_space,
           moveSetRequiresTaking: pawn_move_set_white_requires_taking, isCaptured: false, isEnPassable: false }]
      end.to_h,
      # Rooks
      rook1: { icon: '♖', currentPosition: [0, 7], moveSet: rook_moves, isCaptured: false },
      rook2: { icon: '♖', currentPosition: [7, 7], moveSet: rook_moves, isCaptured: false },
      # Knights
      knight1: { icon: '♘', currentPosition: [1, 7], moveSet: knight_moves, isCaptured: false },
      knight2: { icon: '♘', currentPosition: [6, 7], moveSet: knight_moves, isCaptured: false },
      # Bishops
      bishop1: { icon: '♗', currentPosition: [2, 7], moveSet: bishop_moves, isCaptured: false },
      bishop2: { icon: '♗', currentPosition: [5, 7], moveSet: bishop_moves, isCaptured: false },
      # Royalty
      queen: { icon: '♕', currentPosition: [3, 7], moveSet: queen_moves, isCaptured: false },
      king: { icon: '♔', currentPosition: [4, 7], moveSet: king_moves, isCaptured: false }
    }

    @black = {
      # Pawns
      **Array.new(8) do |i|
        [:"pawn#{i + 1}",
         { icon: '♟', currentPosition: [i, 1], moveSetRequiresSpace: pawn_move_set_black_requires_space,
           moveSetRequiresTaking: pawn_move_set_black_requires_taking, isCaptured: false, isEnPassable: false }]
      end.to_h,
      # Rooks
      rook1: { icon: '♜', currentPosition: [0, 0], moveSet: rook_moves, isCaptured: false },
      rook2: { icon: '♜', currentPosition: [7, 0], moveSet: rook_moves, isCaptured: false },
      # Knights
      knight1: { icon: '♞', currentPosition: [1, 0], moveSet: knight_moves, isCaptured: false },
      knight2: { icon: '♞', currentPosition: [6, 0], moveSet: knight_moves, isCaptured: false },
      # Bishops
      bishop1: { icon: '♝', currentPosition: [2, 0], moveSet: bishop_moves, isCaptured: false },
      bishop2: { icon: '♝', currentPosition: [5, 0], moveSet: bishop_moves, isCaptured: false },
      # Royalty
      queen: { icon: '♛', currentPosition: [3, 0], moveSet: queen_moves, isCaptured: false },
      king: { icon: '♚', currentPosition: [4, 0], moveSet: king_moves, isCaptured: false }
    }
  end

  # --- Piece Logic ---

  def self.pawn_move_set_white_requires_space
    [[0, -1], [0, -2]] # White moves "up" the board (negative Y)
  end

  def self.pawn_move_set_white_requires_taking
    [[1, -1], [-1, -1]]
  end

  def self.pawn_move_set_black_requires_space
    [[0, 1], [0, 2]] # Black moves "down" the board (positive Y)
  end

  def self.pawn_move_set_black_requires_taking
    [[1, 1], [-1, 1]]
  end

  def self.rook_moves
    moves = []
    (1..7).each do |i|
      moves.push([i, 0], [-i, 0], [0, i], [0, -i])
    end
    moves
  end

  def self.knight_moves
    [[1, 2], [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]]
  end

  def self.bishop_moves
    moves = []
    (1..7).each do |i|
      moves.push([i, i], [i, -i], [-i, i], [-i, -i])
    end
    moves
  end

  def self.queen_moves
    rook_moves + bishop_moves
  end

  def self.king_moves
    [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end

  def self.all_pieces
    @white.values + @black.values
  end
end
