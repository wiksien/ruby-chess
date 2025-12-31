# frozen_string_literal: true

require_relative 'game_utils'
require_relative 'pieces'

module GameController
  include GameUtils
  include Pieces

  def self.start_new_game
    Pieces.start_new_game
    GameUtils.display_game(Pieces.all_pieces)

    @turn = 0
    @active_player = 'White'

    player_move = GameController.prompt_player
    move_response = GameController.process_player_move(player_move)

    GameController.handle_move_response(move_response)
  end

  def self.start_new_turn
    GameUtils.display_game(Pieces.all_pieces)

    @turn += 1
    @active_player = @active_player == 'White' ? 'Black' : 'White'

    player_move = GameController.prompt_player
    move_response = GameController.process_player_move(player_move)

    GameController.handle_move_response(move_response)
  end

  def self.handle_move_response(move_response)
    if move_response == 'Move processed'
      GameController.start_new_turn
    else
      puts move_response

      player_move = GameController.prompt_player
      move_response = GameController.process_player_move(player_move)

      GameController.handle_move_response(move_response)
    end
  end

  def self.prompt_player
    puts "#{@active_player} turn, input your move.\n"
    print "[#{GameController.display_player_circle}]$ ".colorize(color: :cyan)
    gets.chomp
  end

  def self.display_player_circle
    @active_player == 'White' ? '○' : '●'
  end

  PLAYER_MOVE_REGEX = /[a-h][1-9]/

  def self.process_player_move(player_move)
    move_codes = player_move.downcase.scan(PLAYER_MOVE_REGEX)
    return "Invalid move format, please try again.\n\n" if move_codes.length != 2

    initial_piece_location = chess_to_matrix_coordinates(move_codes[0])

    piece_to_move = if @active_player == 'White'
                      GameUtils.check_square(initial_piece_location, Pieces.white.values)
                    else
                      GameUtils.check_square(initial_piece_location, Pieces.black.values)
                    end

    return "Invalid selection, please try again.\n\n" if piece_to_move.nil?

    desired_piece_location = chess_to_matrix_coordinates(move_codes[1])

    unless piece_to_move[:moveSet].nil?
      translated_move_set =
        GameController.translate_move_set_to_relative(initial_piece_location,
                                                      piece_to_move[:moveSet])
    end

    unless piece_to_move[:moveSetRequiresSpace].nil?
      translated_move_set_requires_space =
        GameController.translate_move_set_to_relative(initial_piece_location,
                                                      piece_to_move[:moveSetRequiresSpace])
    end

    unless piece_to_move[:moveSetRequiresTaking].nil?
      translated_move_set_requires_taking =
        GameController.translate_move_set_to_relative(initial_piece_location,
                                                      piece_to_move[:moveSetRequiresTaking])
    end

    if !translated_move_set_requires_taking.nil? and
       translated_move_set_requires_taking.include? desired_piece_location

      if @active_player == 'White' and
         !GameUtils.check_square(desired_piece_location, Pieces.black.values).nil?
        Pieces.white.find do |k, v|
          v[:currentPosition] == initial_piece_location
        end[1][:currentPosition] = desired_piece_location

        Pieces.black.delete(Pieces.black.find do |k, v|
          v[:currentPosition] == desired_piece_location
        end[0])

        return 'Move processed'
      elsif @active_player == 'Black' and
            !GameUtils.check_square(desired_piece_location, Pieces.white.values).nil?
        Pieces.black.find do |k, v|
          v[:currentPosition] == initial_piece_location
        end[1][:currentPosition] = desired_piece_location

        Pieces.white.delete(Pieces.white.find do |k, v|
          v[:currentPosition] == desired_piece_location
        end[0])

        return 'Move processed'
      else
        return "#{piece_to_move[:icon]} cannot move that way, because there is no piece to capture."
      end

    end

    if !translated_move_set_requires_space.nil? and
       translated_move_set_requires_space.include? desired_piece_location

      if @active_player == 'White' and
         GameUtils.check_square(desired_piece_location, Pieces.all_pieces).nil?
        Pieces.white.find do |k, v|
          v[:currentPosition] == initial_piece_location
        end[1][:currentPosition] = desired_piece_location

        return 'Move processed'
      elsif @active_player == 'Black' and
            GameUtils.check_square(desired_piece_location, Pieces.all_pieces).nil?
        Pieces.black.find do |k, v|
          v[:currentPosition] == initial_piece_location
        end[1][:currentPosition] = desired_piece_location

        return 'Move processed'
      else
        blocking_piece_icon =
          GameUtils.check_square(desired_piece_location, Pieces.all_pieces)[:icon]
        return "#{piece_to_move[:icon]} cannot move, because #{blocking_piece_icon} blocks it."
      end

    end

    if !translated_move_set.nil? and
       translated_move_set.include? desired_piece_location

      if @active_player == 'White'
        Pieces.white.find do |k, v|
          v[:currentPosition] == initial_piece_location
        end[1][:currentPosition] = desired_piece_location

        # Remember to implement piece removal logic here
        # if desired_piece_location has another piece.
        # The piece needs to be opposite color in order
        # to be valid for the taking.

        'Move processed'
      else
        Pieces.black.find do |k, v|
          v[:currentPosition] == initial_piece_location
        end[1][:currentPosition] = desired_piece_location

        # Remember to implement piece removal logic here
        # if desired_piece_location has another piece.
        # The piece needs to be opposite color in order
        # to be valid for the taking.
        #
        # Black and White should be different

        'Move processed'
      end
    else
      'Invalid move, try again.'
    end
  end

  def self.chess_to_matrix_coordinates(chess_coordinate)
    [('a'..'h').to_a.index(chess_coordinate[0]), 8 - chess_coordinate[1].to_i]
  end

  def self.translate_move_set_to_relative(initial_piece_location, move_set)
    move_set.map do |move|
      [initial_piece_location[0] - move[0],
       initial_piece_location[1] - move[1]]
    end
  end
end
