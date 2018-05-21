require_relative './bootstrap'

$verbose = false
$verbose = true

player_x = AIPlayer.new('x')
player_o = AIPlayer.new('o')

$verbose = false
# player_x.set_alpha(0.1)
# player_x.set_epsilon(0.5)
# player_o.set_alpha(0.1)
 player_o.set_epsilon(0.5)
# Game.new(player_x, player_o, false).normal_game(50_000)
$verbose = true

player_x.set_alpha(0.6)
player_x.set_epsilon(0.0)
player_o.set_alpha(0.6)
player_o.set_epsilon(0.0)

while true
  puts 'you wanna go first (Y/n)'
  choice = $stdin.gets.chomp
  if choice == 'n'
    player1 = player_x
    player2 = HumanPlayer.new('o')
  else
    player1 = HumanPlayer.new('x')
    player2 = player_o
  end

  Game.new(player1, player2, true).normal_game(1)
end
