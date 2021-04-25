module Drawer
  class Board
    def initialize(board)
      raise ArgumentError unless board.is_a?(::Board)

      @board = board
    end # /initialize

    def exec(player = nil)
      puts "\e[40m"

      player && puts("Current player: '#{player.sign}'")

      @board.rows.each do |row|
        out =
          row
          .split(//)
          .join('|')
          .gsub('o', "\e[91mO\e[32m")
          .gsub('x', "\e[93mX\e[32m")

        puts out

      end # /row
      puts "\e[93m-------------"
      puts "\e[36m1 2 3 4 5 6 7"
    end # /exec
  end # /Board
end # /Drawer
