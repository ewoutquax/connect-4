class Game
  def initialize(player1, player2, allow_exploration)
    raise ArgumentError, player1.class.to_s unless player1.is_a?(::Player)
    raise ArgumentError, player2.class.to_s unless player2.is_a?(::Player)

    @player1 = player1
    @player2 = player2
    @allow_exploration = allow_exploration
  end

  def start_episode(board = nil)
    board ||= Board.new
    @player1 = player1.start_episode(self, board)
    @player2 = player2.start_episode(self, board)
  end # /start_episode

  def normal_game(repeats)
    repeats.times do |i|
      puts i if i%5_000 == 0

      board = Board.new

      @player1.start_episode(board)
      @player1.episode.set_allow_exploration(@allow_exploration)
      @player2.start_episode(board)
      @player2.episode.set_allow_exploration(@allow_exploration)

      current_player = nil
      begin
        current_player =
          if current_player == @player1
            @player2
          else
            @player1
          end

        move = current_player.generate_move
        puts "Player #{current_player.sign} chooses: #{move}" if $verbose
        current_player.make_move(move)
      end until board.winner?(current_player.sign) || board.full?

      if $verbose
        if board.full?
          puts "Gelijkspel!"
        else
          puts "Speler #{current_player.sign} heeft gewonnen"
        end
      end

      @player1.update()
      @player2.update()

      @player1.save_q_states()
      @player2.save_q_states()
    end
  end

  def self.start_training_for_player(player, first_move)
    raise ArgumentError, player.class.to_s unless player.is_a?(::Player)

    orig_episode = player.episode
    orig_alpha   = player.alpha
    orig_epsilon = player.epsilon
    player.set_alpha(0.1)
    player.set_epsilon(0.5)

    sign = (player.sign == 'x') ? 'o' : 'x'
    dummy_player = AIPlayer.new(sign)
    dummy_player.set_alpha(0.7)
    dummy_player.set_epsilon(0.05)

    500.times do |i|
      board = Board.new(orig_episode.board.state)
      dummy_player.start_episode(board)
      dummy_player.episode.set_allow_exploration(false)

      player.start_episode(board)
      player.episode.set_allow_exploration(false)
      player.episode.set_states(orig_episode.states)
      player.episode.make_move(first_move - 1, player.sign)

      current_player = player
      begin
        current_player =
          if current_player == player
            dummy_player
          else
            player
          end

        move = current_player.generate_move
        current_player.make_move(move)
      end until board.winner?(current_player.sign) || board.full?

      player.update()
      dummy_player.update()
    end

    player.episode = orig_episode
    player.set_alpha(orig_alpha)
    player.set_epsilon(orig_epsilon)
  end
end
