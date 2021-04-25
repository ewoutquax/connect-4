module Player
  class AI < Player::Base
    attr_reader :sign

    def initialize(sign)
      raise ArgumentError, sign.class.to_s unless sign.is_a?(::String)

      @sign = sign
      @rewards = {}

      @alpha   = 0.7
      @gamma   = 0.85
      @epsilon = 0.95
    end

    def set_alpha_gamma_epsilon(alpha, gamma, epsilon)
      @alpha   = alpha
      @gamma   = gamma
      @epsilon = epsilon
    end # /set_alpha_gamma_epsilon

    def get_valid_move(game)
      raise ArgumentError unless game.is_a?(Game)

      moves =
        if random_move?
          Log.debug("Make random move")
          Arbiter::ValidMoves.new(game.board).find(@sign)
        else
          select_best_moves_by_score(game)
        end

      Log.info("Best moves: #{moves.join(',')}")

      pick = (Kernel.rand * moves.length).floor
      chosen_move = moves[pick]

      game.is_a?(GameTraining) || puts("AI-player '#{self.sign}' chooses: '#{chosen_move}'")
      chosen_move
    end # /get_valid_move

    private

      def select_best_moves_by_score(game)
        valid_moves = Arbiter::ValidMoves.new(game.board).find(@sign)
        moves_with_score = Generator::Move.new(game).append_moves_with_scores(valid_moves, self)

        Log.info('')
        Log.info('Score per move')
        Log.info('--------------')
        moves_with_score.select do |move, score|
          Log.info("#{move}: #{score}")
        end # /move, score

        max = moves_with_score.values.max
        moves_with_score.select do |move, score|
          score == max
        end.keys
      end

      def random_move?
        Kernel.rand > @epsilon
      end # /random_move?

    module Generator
      class Move
        def initialize(game)
          raise ArgumentError unless game.is_a?(Game)

          @game = game
        end # /initialize

        def append_moves_with_scores(moves, player)
          raise ArgumentError unless player.is_a?(Player::AI)

          orig_state = @game.board.state

          Log.info('')
          Log.info('Training results')
          Log.info('----------------')

          moves.inject({}) do |acc, move|
            temp_board = Board.new(orig_state)
            temp_board.make_move(move, player.sign)
            state = temp_board.state

            # if @game.allow_training? && !Database.exists(state)
            #   Log.info("Unknown state for move '#{move}'; start training game")
            #   GameTraining.train_move(move, orig_state, player)
            # end

            acc[move] =
              if Arbiter::Win.new(temp_board).winner?(player.sign)
                Log.info("Winning state found for move '#{move}'")
                1
              elsif (json = Database.get(state))
                Log.info("Known board-state after move '#{move}'")
                value = JSON.parse(json)
                value['score']
              elsif @game.allow_training?
                nr_wins, nr_losses = GameTraining.train_move(move, orig_state, player, @game.states)
                Log.info("Wins vs losses for training move '#{move}': #{nr_wins} / #{nr_losses}")
                JSON.parse(Database.get(state))['score']
              else
                Log.info("Unknown board-state after move '#{move}' and training not allowed")
                0
              end

            acc
          end # /acc, move
        end # /append_moves_with_scores
      end # /Move
    end # /Generator
  end
end # /Player
