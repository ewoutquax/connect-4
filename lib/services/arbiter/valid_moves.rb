module Arbiter
  class ValidMoves
    def initialize(board)
      raise ArgumentError unless board.is_a?(Board)

      @board = board
    end # /initialize

    def find(_sign)
      column = @board.rows.first.split(//)
      (0..6).inject([]) do |acc, index|
        if column[index] == ' '
          acc << index + 1
        else
          acc
        end
      end
    end # /find
  end # /ValidMoves
end # /Arbiter
