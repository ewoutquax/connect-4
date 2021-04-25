class Game
  attr_reader :board, :player_1, :player_2, :active_player, :states, :single_round

  def initialize(board, player_1, player_2)
    raise ArgumentError, board.class.to_s unless board.is_a?(::Board)
    raise ArgumentError, player_1.class.to_s unless player_1.is_a?(::Player::Base)
    raise ArgumentError, player_2.class.to_s unless player_2.is_a?(::Player::Base)

    @board    = board
    @player_1 = player_1
    @player_2 = player_2

    @single_round = SingleRound.new(self)

    @states = {
      @player_1.sign => [],
      @player_2.sign => []
    }
  end

  def set_states(states)
    @states = states
  end # /set_states

  def play
    active_player_next_round

    until ended?
      play_round
      active_player_next_round
    end

    update_players
  end # /play

  def play_round
    @single_round.play
  end

  def valid_moves
    arbiter_valid_moves.find(@active_player.sign)
  end

  def ended?
    arbiter_game_ended.ended?
  end # /ended?

  def active_player_next_round
    next_player = (@active_player == @player_1) ? @player_2 : @player_1
    set_active_player(next_player)
  end # /active_player_next_round

  def set_active_player(player)
    @active_player = player
  end

  def allow_training?
    true
  end # /allow_training?

  private

    def score_for_player(player)
      (Arbiter::Win.new(@board).winner?(player.sign)) ? 1 : -1
    end # /score_for_player

    def update_players
      [@player_1, @player_2].each { |player| do_update_player(player) }
    end

    def do_update_player(player)
      player.update(score_for_player(player), @states[player.sign])
    end

    def arbiter_game_ended
      @arbiter_game_ended ||= Arbiter::GameEnd.new(self)
    end

    def arbiter_valid_moves
      @arbiter_valid_moves ||= Arbiter::ValidMoves.new(@board)
    end

  class SingleRound
    def initialize(game)
      raise ArgumentError unless game.is_a?(Game)

      @game = game

      @drawer = Drawer::Board.new(board)
    end # /initialize

    def play
      active_player.draw_board_before_make_move? && @drawer.exec(active_player)

      move = active_player.get_valid_move(@game)
      make_move(move)
    end # /play

    def make_move(move)
      active_sign = active_player.sign

      board.make_move(move, active_sign)
      @game.states[active_sign] << board.state
    end # /make_move

    private

      def active_player
        @game.active_player
      end

      def board
        @game.board
      end
  end # /SingleRound
end
