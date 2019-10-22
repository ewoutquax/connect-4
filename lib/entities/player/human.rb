module Player
  class Human < Player::Base
    attr_reader :sign

    def initialize(sign)
      @sign = sign
    end

    def update(score, _states)
      if score == 1
        puts "You won!"
      else
        puts "You have lost"
      end
    end

    def get_valid_move(game)
      raise ArgumentError, game.class.to_s unless game.is_a?(Game)

      if (valid_moves = game.valid_moves) == []
        puts "No moves possible"
        puts "Press <enter> to continue"

        ''
      else
        puts "Valid moves: #{valid_moves.join(', ')}"
        puts "Your choice:"

        $stdin.gets.chomp.to_i
      end
    end # /generate_move
  end # /Human
end # /Player
