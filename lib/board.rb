class Board
  def initialize(state = nil)
    if state.nil?
      @rows = []
      6.times do
        @rows << '0000000'
      end
    else
      @rows = state.split(' ')
    end
  end

  def state
    @rows.join(' ')
  end

  def valid_moves
    column = @rows.first.split(//)
    (0..6).inject([]) do |acc, index|
      if column[index] == '0'
        acc << index + 1
      else
        acc
      end
    end
  end

  def make_move(column, sign)
    bottom_row =
      (0..5).to_a.reverse.detect do |row|
        @rows[row][column] == '0'
      end

    @rows[bottom_row][column] = sign
  end

  def winner?(sign)
    search = ''.ljust(4, sign)
    winner =
      @rows.any? do |row|
        !row.index(search).nil?
      end

    # Vertical
    (0..6).each do |column|
      (0..2).each do |row|
        current =
          @rows[row + 0][column] +
          @rows[row + 1][column] +
          @rows[row + 2][column] +
          @rows[row + 3][column]

        if current == search
          winner = true
        end
      end
    end

    # Forward diagonal
    (0..3).each do |column|
      (0..2).each do |row|
        current =
          @rows[row + 0][column + 0] +
          @rows[row + 1][column + 1] +
          @rows[row + 2][column + 2] +
          @rows[row + 3][column + 3]

        if current == search
          winner = true
        end
      end
    end

    # Backward diagonal
    (0..3).each do |column|
      (0..2).each do |row|
        current =
          @rows[row + 0][column + 3] +
          @rows[row + 1][column + 2] +
          @rows[row + 2][column + 1] +
          @rows[row + 3][column + 0]

        if current == search
          winner = true
        end
      end
    end

    winner
  end

  def full?
    self.state.index('0').nil?
  end
end
