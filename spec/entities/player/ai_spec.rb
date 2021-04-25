require 'rspec'
require 'bootstrapper'

RSpec.describe Player::AI do
  context 'init' do
    it 'inherits from class Player::Base' do
      expect(Player::AI.new('x')).to be_kind_of(Player::Base)
    end
    it 'requires a sign board as input' do
      expect { Player::AI.new }.to raise_error(ArgumentError)
    end
  end

  context 'score per move' do
    let(:board)   { Board.new }
    let(:player)  { Player::AI.new('x') }
    let(:game)    { Game.new(board, player, player) }

    before do
      allow(game).to receive(:training?).and_return(true)
    end

    it 'returns a list of each move, with a default score of 0 for new board states' do
      valid_positions = Arbiter::ValidMoves.new(board).find(player.sign)
      moves_with_score = Player::AI::Generator::Move.new(game).append_moves_with_scores(valid_positions, player)

      expect(moves_with_score).to eq({1=>0, 2=>0, 3=>0, 4=>0, 5=>0, 6=>0, 7=>0})
    end

    it 'returns a list of each move, with their score' do
      temp = Board.new
      temp.make_move('4', 'x')
      state = temp.state

      value = {
        score: 1.0,
        counter: 100
      }.to_json

      Database.set(state, value)

      valid_positions = Arbiter::ValidMoves.new(board).find(player.sign)
      moves_with_score = Player::AI::Generator::Move.new(game).append_moves_with_scores(valid_positions, player)

      expect(moves_with_score).to eq({1=>0, 2=>0, 3=>0, 4=>1.0, 5=>0, 6=>0, 7=>0})
    end

    it 'returns a score of 1, when the move results in a win' do
      skip "the win-function doesn't check if the game has ended"
      allow(board).to receive(:winner?).and_return(true)

      moves_with_score = Player::AI::Generator::Move.new(board).append_moves_with_scores(['a'], player)

      expect(moves_with_score).to eq({'a' => 1})
    end
  end

  context 'make move' do
    let(:board) { Board.new }
    let(:player) { build_full_player }
    let(:game) { Game.new(board, player, player) }

    before do
      expect(player).to receive(:random_move?).and_return(false)
    end

    it 'returns the one single valid move with the highest score' do
      generator = double(Player::AI::Generator::Move, append_moves_with_scores: {"c4"=>0.1, "d3"=>0, "e6"=>0, "f5"=>0})
      allow(Player::AI::Generator::Move).to receive(:new).and_return(generator)

      selected_move = player.get_valid_move(game)
      expect(selected_move).to eq('c4')
    end

    it 'returns a random move from all valid moves with the same score' do
      generator = double(Player::AI::Generator::Move, append_moves_with_scores: {"c4"=>0, "d3"=>0, "e6"=>0, "f5"=>0})
      allow(Player::AI::Generator::Move).to receive(:new).and_return(generator)
      allow(Kernel).to receive(:rand).and_return(0.99)

      selected_move = player.get_valid_move(game)
      expect(selected_move).to eq('f5')
    end

    it 'will print the chosen move' do
      generator = double(Player::AI::Generator::Move, append_moves_with_scores: {"f5"=>0})
      allow(Player::AI::Generator::Move).to receive(:new).and_return(generator)

      expect { player.get_valid_move(game) }.to output("AI-player 'w' chooses: 'f5'\n").to_stdout
    end
  end

  context 'update' do
    let(:player) { build_full_player }

    it 'requires a list of board-states' do
      expect { player.update }.to raise_error(ArgumentError)
      expect { player.update('invalid-input') }.to raise_error(ArgumentError)
    end

    it 'writes the board-states to a database, with their occurences and their discounted scores' do
      states = ["a", "b", "c", "d"]
      expected_result = {
        "a" => '{"score":0.6141249999999999,"counter":1}',
        "b" => '{"score":0.7224999999999999,"counter":1}',
        "c" => '{"score":0.85,"counter":1}',
        "d" => '{"score":1.0,"counter":1}'
      }
      player.update(1, states)

      result = Database.getall
      expect(result).to eq(expected_result)
    end

    it 'updates the board-states in the database, with their occurences and their discounted scores' do
      Database.set('a', '{"score":0.7,"counter":1}')
      Database.set('b', '{"score":1,"counter":1}')
      Database.set('c', 'dummy-entry')

      states = ['a', 'b']
      expected_result = {
        'a' => '{"score":0.8049999999999999,"counter":2}',
        'b' => '{"score":1.0,"counter":2}',
        'c' => 'dummy-entry',
      }
      player.update(1, states)

      result = Database.getall
      expect(result).to eq(expected_result)
    end
  end

  def build_full_player
    Player::AI.new('w')
  end
end
