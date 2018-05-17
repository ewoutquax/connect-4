require_relative './bootstrap'

$verbose = false
player1 = AIPlayer.new('x')
player2 = AIPlayer.new('o')

player1.load_state
player2.load_state

# $verbose = true
# player2 = HumanPlayer.new('o')

while true
  50_000.times do |i|
    puts i if i%200 == 0
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
      board.draw if $verbose
    end until board.winner?(current_player.sign) || board.full?

    player1.update
    player2.update

    binding.pry if $verbose
  end

  player1.save_state
  player2.save_state

  $verbose = true
  player2 = HumanPlayer.new('o')
end

binding.pry
