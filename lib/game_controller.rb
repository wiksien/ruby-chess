# frozen_string_literal: true

require_relative 'game_utils'
require_relative 'pieces'

module GameController
  include GameUtils
  include Pieces

  def self.start_new_game
    Pieces.start_new_game
    GameUtils.display_game(Pieces.all_pieces)
  end
end
