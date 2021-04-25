class Board
  attr_reader :rows

  def initialize(state = nil)
    if state.nil?
      @rows = []
      6.times do
        @rows << '       '
      end
    else
      parse_state_to_rows(state)
    end
  end

  def make_move(input_column, sign)
    column = input_column.to_i - 1

    bottom_row =
      (0..5).to_a.reverse.detect do |row|
        @rows[row][column] == ' '
      end

    @rows[bottom_row][column] = sign
  end

  def full?
    @rows.all?{ |row| row.index(' ').nil?}
  end

  def state
    numbers =
      @rows.map do |row|
        base = -1
        row.split(//).inject(0) do |acc, chip|
          base += 1
          multiplier = {' ' => 0, 'x' => 1, 'o' => 2}[chip]

          acc + (3 ** base * multiplier)
        end # /position, acc
      end # /row

    numbers.to_json
  end # /state

  private

    def parse_state_to_rows(state)
      @rows = []
      JSON.parse(state).each_with_index do |row_number, index|
        parse_state_to_row(row_number, index)
      end # /row_number, index
    end

    def parse_state_to_row(number, index)
      @rows[index] =
        (0..6).to_a.inject('') do |acc, base|
          remainder = number%3
          number = (number / 3).floor
          acc << [' ', 'x', 'o'][remainder]
        end # /acc, base
    end # /parse_state_to_row
end
