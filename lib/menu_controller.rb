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
    '

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
    when 'start'
      GameController.start_new_game
    when 'help'
      puts 'help'
    when 'credits'
      puts 'credits'
    else
      puts "This command doesn't exist, please try again."
      MenuController.display_user_start_prompt
    end
  end
end
