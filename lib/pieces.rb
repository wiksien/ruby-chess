# frozen_string_literal: true

module Pieces
  # currentPosition default value describes starting position
  # default position assumes white is at the bottom and moves first

  class << self
    attr_accessor :white, :black
  end

  def self.start_new_game
    @white = {
      pawn1: { icon: '♙', currentPosition: [0, 6],
               moveSetRequiresSpace: Pieces.pawn_move_set_white_requires_space,
               moveSetRequiresTaking: Pieces.pawn_move_set_white_requires_taking,
               isCaptured: false, isEnPassable: false },
      pawn2: { icon: '♙', currentPosition: [1, 6],
               moveSetRequiresSpace: Pieces.pawn_move_set_white_requires_space,
               moveSetRequiresTaking: Pieces.pawn_move_set_white_requires_taking,
               isCaptured: false, isEnPassable: false }
    }
    @black = {
      pawn1: { icon: '♟', currentPosition: [0, 1],
               moveSetRequiresSpace: Pieces.pawn_move_set_black_requires_space,
               moveSetRequiresTaking: Pieces.pawn_move_set_black_requires_taking,
               isCaptured: false, isEnPassable: false },
      pawn2: { icon: '♟', currentPosition: [1, 1],
               moveSetRequiresSpace: Pieces.pawn_move_set_black_requires_space,
               moveSetRequiresTaking: Pieces.pawn_move_set_black_requires_taking,
               isCaptured: false, isEnPassable: false }
    }
  end

  def self.pawn_move_set_white_requires_space
    [[0, 1]]
  end

  def self.pawn_move_set_white_requires_taking
    [[1, 1], [-1, 1]]
  end

  def self.pawn_move_set_black_requires_space
    [[0, -1]]
  end

  def self.pawn_move_set_black_requires_taking
    [[1, -1], [-1, -1]]
  end

  def self.all_pieces
    @white.values + @black.values
  end
end
