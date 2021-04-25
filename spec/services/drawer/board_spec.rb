require 'rspec'
require 'bootstrapper'

RSpec.describe Drawer::Board do
  context 'init' do
    it 'raises an error when instantiated without a board' do
      expect { Drawer::Board.new(1) }.to raise_error(ArgumentError)
    end

    it 'needs a board to be instantiated' do
      board = Board.new

      expect(Drawer::Board.new(board)).to be_kind_of(Drawer::Board)
    end
  end

  context 'exec' do
    it 'draws the board without failure' do
      board = Board.new
      drawer = Drawer::Board.new(board)
      drawer.exec

      board.make_move(5, 'o')
      drawer.exec
    end
  end
end
