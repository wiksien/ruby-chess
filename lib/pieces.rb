# frozen_string_literal: true

module Pieces
  # currentPosition default value describes starting position
  # default position assumes white is at the bottom and moves first

  attr_accessor :white, :black

  def self.start_new_game
    @white = {
      pawn1: { icon: '♙', currentPosition: [0, 6], moveSet: [1, 0],
               isCaptured: false, isEnPassable: false },
      pawn2: { icon: '♙', currentPosition: [1, 6], moveSet: [1, 0],
               isCaptured: false, isEnPassable: false }
    }
    @black = {
      pawn1: { icon: '♟', currentPosition: [0, 1], moveSet: [-1, 0],
               isCaptured: false, isEnPassable: false },
      pawn2: { icon: '♟', currentPosition: [1, 1], moveSet: [-1, 0],
               isCaptured: false, isEnPassable: false }
    }
  end

  def pawn_move_set
    [1, 0]
  end

  def self.all_pieces
    @white.values + @black.values
  end
end
