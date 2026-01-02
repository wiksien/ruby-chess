# frozen_string_literal: true

require_relative 'game_utils'
require_relative 'pieces'

module GameController
  include GameUtils
  include Pieces

  @helpMessage = "
  In order to make a move,
  when prompted type first square to select a piece to move and then
  type in the desired location.

  Examples:
  - a1a2
  - B4H4
  - C1 to d3
  - Pretty please move that A5 piece to A6

  Invalid examples:
  - a 1 a 2
  - I like trains

  The standard game follows typical chess rules.
  If you wish to review or change them in detail, checkout pieces.rb

  En passant is currently not implemented, sorry!
  Enjoy the game!
  "

  def self.start_new_game
    Pieces.start_new_game
    GameUtils.display_game(Pieces.all_pieces)

    @turn = 0
    @active_player = 'White'

    player_move = GameController.handle_utility_commands

    return if player_move == 'quit'

    move_response = GameController.process_player_move(player_move)

    GameController.handle_move_response(move_response)
  end

  def self.start_new_turn
    GameUtils.display_game(Pieces.all_pieces)

    @turn += 1
    @active_player = @active_player == 'White' ? 'Black' : 'White'

    player_move = GameController.handle_utility_commands

    return if player_move == 'quit'

    move_response = GameController.process_player_move(player_move)

    GameController.handle_move_response(move_response)
  end

  def self.handle_utility_commands
    utility_command = GameController.prompt_player

    case utility_command
    when 'quit' || 'exit'
      puts 'Thanks for playing. Bye bye!'
      return 'quit'
    when 'help' || '--help'
      puts @helpMessage
      utility_command = GameController.handle_utility_commands
    end

    utility_command
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

    if !translated_move_set.nil? &&
       translated_move_set.include?(desired_piece_location) &&
       @active_player == 'White' &&
       GameUtils.check_square(desired_piece_location, Pieces.white.values).nil?

      squares_to_check = calculate_coordinates_in_between(initial_piece_location, desired_piece_location)

      return 'Path is blocked!' if squares_to_check.any? { |square| GameUtils.check_square(square, Pieces.all_pieces) }

      unless GameUtils.check_square(desired_piece_location, Pieces.black.values).nil?
        Pieces.black.delete(Pieces.black.find do |k, v|
          v[:currentPosition] == desired_piece_location
        end[0])
      end

      Pieces.white.find do |k, v|
        v[:currentPosition] == initial_piece_location
      end[1][:currentPosition] = desired_piece_location

      'Move processed'

    elsif !translated_move_set.nil? &&
          translated_move_set.include?(desired_piece_location) &&
          @active_player == 'Black' &&
          GameUtils.check_square(desired_piece_location, Pieces.black.values).nil?

      squares_to_check = calculate_coordinates_in_between(initial_piece_location, desired_piece_location)

      return 'Path is blocked!' if squares_to_check.any? { |square| GameUtils.check_square(square, Pieces.all_pieces) }

      unless GameUtils.check_square(desired_piece_location, Pieces.white.values).nil?
        Pieces.white.delete(Pieces.white.find do |k, v|
          v[:currentPosition] == desired_piece_location
        end[0])
      end

      Pieces.black.find do |k, v|
        v[:currentPosition] == initial_piece_location
      end[1][:currentPosition] = desired_piece_location

      'Move processed'

    else
      'Invalid move, please try again.'
    end
  end

  def self.chess_to_matrix_coordinates(chess_coordinate)
    [('a'..'h').to_a.index(chess_coordinate[0]), 8 - chess_coordinate[1].to_i]
  end

  def self.calculate_coordinates_in_between(initial_coordinate, final_coordinate)
    x_dist = final_coordinate[0] - initial_coordinate[0]
    y_dist = final_coordinate[1] - initial_coordinate[1]

    # Check for knights. Kinda dirty to hide it here,
    # but I will add a "canJump" flag in pieces.rb later
    # so until then a hotfix will be here.
    is_straight = x_dist == 0 || y_dist == 0
    is_diagonal = x_dist.abs == y_dist.abs

    return [] unless is_straight || is_diagonal

    step = [x_dist <=> 0, y_dist <=> 0]

    number_of_steps = [x_dist.abs, y_dist.abs].max - 1

    in_between_coordinates = []
    current_position = initial_coordinate

    number_of_steps.times do
      current_position = [current_position[0] + step[0], current_position[1] + step[1]]
      in_between_coordinates << current_position
    end

    in_between_coordinates
  end

  def self.translate_move_set_to_relative(initial_piece_location, move_set)
    move_set.map do |move|
      [initial_piece_location[0] + move[0],
       initial_piece_location[1] + move[1]]
    end
  end
end
