# frozen_string_literal: true

require './lib/menu_controller'

describe MenuController do
  describe '#process_user_start' do
    it 'display chessboard when user types "start"' do
      expect do
        described_class.process_user_start('start')
      end.to output("start\n").to_stdout
    end

    it 'display helpful information when user types "help"' do
      expect do
        described_class.process_user_start('help')
      end.to output("help\n").to_stdout
    end

    it 'display credits when user types "credits"' do
      expect do
        described_class.process_user_start('credits')
      end.to output("credits\n").to_stdout
    end
  end
end
