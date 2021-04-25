#! /usr/bin/env ruby

dir = File.expand_path(__dir__ + "/../lib")
$LOAD_PATH.push(dir)

require "bootstrapper"

ai_player_x = Player::AI.new("x")
ai_player_o = Player::AI.new("o")

ai_player_x.set_alpha_gamma_epsilon(0.6, 0.8, 0.9)
ai_player_o.set_alpha_gamma_epsilon(0.6, 0.8, 0.9)

# 1_000.times do |index|
0.times do |index|
  index % 100 == 0 && puts("Playing game no: #{index}")

  Game.new(Board.new, ai_player_x, ai_player_o).play
end # /index

ai_player_x.set_alpha_gamma_epsilon(0.75, 0.85, 1.0)
ai_player_o.set_alpha_gamma_epsilon(0.75, 0.85, 1.0)

while true
  puts "you wanna go first (Y/n)"
  choice = $stdin.gets.chomp
  if choice == "n"
    player1 = ai_player_x
    player2 = Player::Human.new("o")
  else
    player1 = Player::Human.new("x")
    player2 = ai_player_o
  end

  Game.new(Board.new, player1, player2).play
end
