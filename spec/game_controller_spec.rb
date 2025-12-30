# frozen_string_literal: true

require './lib/gamecontroller'

describe GameController do
  describe '#new' do
    it 'creates a new game object with all the chess pieces' do
      newgame = describedclass.new

      describe '#chesspieces.white' do
        newgame.chesspieces.white.keys
      end.to eql?(%i[pawn1 pawn2 pawn3 pawn4 pawn5 pawn6
                     pawn7 pawn8 knight1 knight2 bishop1 bishop2 rook1
                     rook2 queen king])

      describe '#chesspieces.black' do
        newgame.chesspieces.black.keys
      end.to eql?(%i[pawn1 pawn2 pawn3 pawn4 pawn5 pawn6
                     pawn7 pawn8 knight1 knight2 bishop1 bishop2 rook1
                     rook2 queen king])
    end.to eql?('[]')
  end
end
