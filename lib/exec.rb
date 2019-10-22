require_relative './bootstrapper'

ai_player_x = Player::AI.new('x')
ai_player_o = Player::AI.new('o')

# ai_player_x.set_alpha(0.6)
# ai_player_x.set_epsilon(0.0)
# ai_player_o.set_alpha(0.6)
# ai_player_o.set_epsilon(0.0)

# 1_000.times do |index|
#   index%100 == 0 && puts("Playing game #{index}")
#
#   Game.new(Board.new, ai_player_x, ai_player_o).play
# end # /index

while true
  puts 'you wanna go first (Y/n)'
  choice = $stdin.gets.chomp
  if choice == 'n'
    player1 = ai_player_x
    player2 = Player::Human.new('o')
  else
    player1 = Player::Human.new('x')
    player2 = ai_player_o
  end

  Game.new(Board.new, player1, player2).play
end
