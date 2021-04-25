module Arbiter
  class GameEnd
    def initialize(game)
      raise ArgumentError, game.class.to_s unless game.is_a?(Game)

      @game = game
      @arbiter_win = Arbiter::Win.new(@game.board)
    end # /initialize

    def ended?
      @game.board.full? ||
        @arbiter_win.winner?(@game.player_1.sign) ||
        @arbiter_win.winner?(@game.player_2.sign)
    end # /ended?
  end # /GameEnd
end # /Arbiter
