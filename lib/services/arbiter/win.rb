module Arbiter
  class Win

    attr_reader :rows

    def initialize(board)
      raise ArgumentError unless board.is_a?(Board)

      @board = board
    end # /initialize

    def winner?(sign)
      search = ''.ljust(4, sign)

      winner_horizontal?(search)       ||
      winner_vertical?(search)         ||
      winner_diagonal_forward?(search) ||
      winner_diagonal_backward?(search)
    end

    def winner_horizontal?(search)
      @board.rows.any? do |row|
        !row.index(search).nil?
      end
    end # /winner_horizontal?

    def winner_vertical?(search)
      winner = false

      (0..6).each do |column|
        (0..2).each do |row|
          current =
            @board.rows[row + 0][column] +
            @board.rows[row + 1][column] +
            @board.rows[row + 2][column] +
            @board.rows[row + 3][column]

          if current == search
            winner = true
          end
        end
      end

      winner
    end # /winner_vertical?

    def winner_diagonal_forward?(search)
      winner = false

      # Forward diagonal
      (0..3).each do |column|
        (0..2).each do |row|
          current =
            @board.rows[row + 0][column + 0] +
            @board.rows[row + 1][column + 1] +
            @board.rows[row + 2][column + 2] +
            @board.rows[row + 3][column + 3]

          if current == search
            winner = true
          end
        end
      end

      winner
    end # /winner_diagonal_forward?

    def winner_diagonal_backward?(search)
      winner = false

      (0..3).each do |column|
        (0..2).each do |row|
          current =
            @board.rows[row + 0][column + 3] +
            @board.rows[row + 1][column + 2] +
            @board.rows[row + 2][column + 1] +
            @board.rows[row + 3][column + 0]

          if current == search
            winner = true
          end
        end
      end

      winner
    end # /winner_diagonal_backward?
  end # /Win
end # /Arbiter
