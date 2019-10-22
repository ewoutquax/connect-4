module Player
  class AI < Player::Base
    attr_reader :sign

    def initialize(sign)
      raise ArgumentError, sign.class.to_s unless sign.is_a?(::String)

      @sign = sign
      @rewards = {}

      @alpha   = 0.7
      @gamma   = 0.85
      @epsilon = 0
    end

    def get_valid_move(game)
      raise ArgumentError unless game.is_a?(Game)

      best_moves  = select_best_moves_by_score(game)
      pick        = (Kernel.rand * best_moves.length).floor

      chosen_move = best_moves[pick]
      puts "Chosen move: '#{chosen_move}'"
      chosen_move
    end # /get_valid_move

    def update(score, states)
      db_conn     = Database.connection
      db_name     = Database.name
      local_score = score.to_f

      states.reverse.each do |state|
        if (json = db_conn.hget(db_name, state))
          value = JSON.parse(json)
          old_score = value['score']
          value['score']   += (local_score - value['score']) * @alpha / value['counter']
          value['counter'] += 1

          Log.info("Update state '#{state}' with score: #{local_score}")
          Log.info("Old score: #{old_score}; new score: #{value['score']}")
        else
          value = {
            score: local_score,
            counter: 1
          }
          Log.info("Score for new state '#{state}': #{local_score}")
        end

        db_conn.hset(db_name, state, value.to_json)

        local_score *= @gamma
      end # /state
    end # /update

    private

      def select_best_moves_by_score(game)
        valid_moves = Arbiter::ValidMoves.new(game.board).find(@sign)
        moves_with_score = Generator::Move.new(game).append_moves_with_scores(valid_moves, self)

        max = moves_with_score.values.max
        moves_with_score.select do |move, score|
          score == max
        end.keys
      end

    module Generator
      class Move
        def initialize(game)
          raise ArgumentError unless game.is_a?(Game)

          @game = game
        end # /initialize

        def append_moves_with_scores(moves, player)
          raise ArgumentError unless player.is_a?(Player::AI)

          Log.info("")
          Log.info("Score per move")
          Log.info("--------------")

          db_conn = Database.connection
          orig_state = @game.board.state

          moves.inject({}) do |acc, move|
            temp_board = Board.new(orig_state)
            temp_board.make_move(move, player.sign)
            state = temp_board.state

            # if !@game.training? && !db_conn.hexists('othello', state)
            #   Log.info("Unknown state for move '#{move}'; start training game")
            #   Log.log_level = :warn
            #   training = @game.spawn_training(player, move)
            #   training.play
            #   Log.log_level = $log_level

            #   if training.board.winner?(player.color)
            #     Log.info("Training game for move '#{move}' was won")
            #   else
            #     Log.info("Training game for move '#{move}' was lost")
            #   end
            # end

            acc[move] =
              if (json = db_conn.hget(Database.name, state))
                value = JSON.parse(json)
                value['score']
              else
                0
              end

            Log.info("#{move}: #{acc[move]}")

            acc
          end # /acc, move
        end # /append_moves_with_scores
      end # /Move
    end # /Generator
  end
end # /Player
