# frozen_string_literal: true

module GameUtils
  def self.check_square(coordinates, all_pieces)
    all_pieces.find do |piece|
      piece[:currentPosition] == coordinates
    end
  end

  def self.display_game(all_pieces)
    print "\n"
    print '   '
    8.times { |i| print " #{('A'..'H').to_a[i]} " }
    print "\n"
    (0..7).each do |y_coordinate|
      print ' ', 8 - y_coordinate, ' '
      (0..7).each do |x_coordinate|
        coordinate_state = GameUtils.check_square([x_coordinate, y_coordinate],
                                                  all_pieces)

        is_colored = (x_coordinate + y_coordinate).odd?

        if coordinate_state.nil?
          print '   '.colorize(background: :light_cyan) if is_colored
          print '   '.colorize(background: :white) unless is_colored
        elsif is_colored
          print ' '.colorize(background: :light_cyan),
                coordinate_state[:icon].colorize(background: :light_cyan,
                                                 color: :black),
                ' '.colorize(background: :light_cyan)
        else
          print ' '.colorize(background: :white),
                coordinate_state[:icon].colorize(background: :white,
                                                 color: :black),
                ' '.colorize(background: :white)
        end

        print "\n" if x_coordinate == 7
      end
    end
    print "\n"
  end
end
