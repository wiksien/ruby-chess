# frozen_string_literal: true

require 'colorize'

require_relative 'assets/ascii_logo'
require_relative 'game_controller'

module MenuController
  include AsciiLogo
  include GameController

  attr_accessor :start_menu_user_input

  @ascii_logo = ASCII_LOGO.colorize(color: :cyan)
  @welcome_message = '
    Welcome to Ruby Chess!

    To start type "start" below.
    To learn more on how to play Ruby Chess type "help" below.
    To see the credits, type "credits".

    To quit type "quit" below.
    '

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

  @creditsMessage = "
  All made by Wiktor Sienkiewicz.

  Big thanks to green tea for fueling me.
  "

  def self.start
    puts @ascii_logo

    puts @welcome_message

    MenuController.display_user_start_prompt
  end

  def self.display_user_start_prompt
    print '[○]$ '.colorize(color: :cyan)
    user_input = gets.chomp
    MenuController.process_user_start(user_input)
  end

  def self.process_user_start(user_input)
    case user_input
    when 'start' || 's'
      GameController.start_new_game
    when 'help' || '--help'
      puts @helpMessage
      MenuController.display_user_start_prompt
    when 'credits' || 'credit'
      puts @creditsMessage
      MenuController.display_user_start_prompt
    when 'quit' || 'q'
      puts 'Bye bye!'
    else
      puts "This command doesn't exist, please try again."
      MenuController.display_user_start_prompt
    end
  end
end
