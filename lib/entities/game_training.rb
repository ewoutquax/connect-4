class GameTraining < Game
  def self.train_move(first_move, board_state, training_player, game_states)
    training_player.is_a?(Player::Base) ||
      raise(ArgumentError, training_player.class.to_s)

    player_sign = training_player.sign
    other_sign  = (player_sign == 'x') ? 'o' : 'x'

    player         = Player::AI.new(player_sign)
    other_player   = Player::AI.new(other_sign)

    player.set_alpha_gamma_epsilon(0.4, 0.85, 0.8)
    other_player.set_alpha_gamma_epsilon(0.4, 0.85, 0.8)

    nr_wins = 0
    nr_losses = 0

    50.times do
      Log.log_level = :warn
      training = GameTraining.new(Board.new(board_state), player, other_player)
      # training.set_states(game_states)
      training.set_active_player(player)
      training.single_round.make_move(first_move)
      training.play
      Log.log_level = $log_level

      if Arbiter::Win.new(training.board).winner?(player.sign)
        nr_wins += 1
      else
        nr_losses += 1
      end
    end

    [nr_wins, nr_losses]
  end # /start_training

  def allow_training?
    false
  end # /allow_training?
end # /GameTraining
