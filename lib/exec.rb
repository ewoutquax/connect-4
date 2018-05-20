require_relative './bootstrap'

$verbose = false
$verbose = true

player_x = AIPlayer.new('x')
player_x.load_state
player_o = AIPlayer.new('o')
player_o.load_state

# Game.new(player_x, player_o, false).normal_game(50_000)

player_x.set_alpha(0.6)
player_x.set_epsilon(0.0)
player_o.set_alpha(0.6)
player_o.set_epsilon(0.0)

while true
  puts "you wanna go first (Y/n)"
  choice = $stdin.gets.chomp
  if choice == 'n'
    player1 = player_x
    player2 = HumanPlayer.new('o')
  else
    player1 = HumanPlayer.new('x')
    player2 = player_o
  end

  game = Game.new(player1, player2, false)
  board = Board.new

  player1.start_episode(board)
  player2.start_episode(board)

  current_player = nil

  begin
    current_player =
      if current_player == player1
        player2
      else
        player1
      end

    move = current_player.generate_move
    puts "Player #{current_player.sign} chooses: #{move}" if $verbose
    current_player.make_move(move)
    # board.draw if $verbose
  end until board.winner?(current_player.sign) || board.full?

  if board.full?
    puts "Gelijkspel!"
  else
    puts "Speler #{current_player.sign} heeft gewonnen"
  end

  player1.update
  player2.update

  temp = (player1.is_a?(AIPlayer)) ? player1 : player2
  puts "aiplayer v-state: #{temp.v_states[temp.episode.states.last.first]}"
  puts "aiplayer q-state: #{temp.q_states[temp.episode.states.last.first]}"

  player1.save_state
  player2.save_state
end
