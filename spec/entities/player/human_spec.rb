require 'rspec'
require 'bootstrapper'

RSpec.describe Player::Human do
  context 'init' do
    it 'inherits from class Player::Base' do
      expect(Player::Human.new('x')).to be_kind_of(Player::Base)
    end
    it 'requires a color board as input' do
      expect { Player::Human.new }.to raise_error(ArgumentError)
    end
  end

  context 'make move' do
    let(:board)  { Board.new }
    let(:player) { Player::Human.new('x') }
    let(:game)   { build_game_with_active_player(board, player) }

    it 'returns a valid move' do
      allow($stdin).to receive(:gets).and_return('5')

      move = player.get_valid_move(game)
      expect(move).to eq(5)
    end

    context 'when no move available' do
      it 'will show a message about no moves being available' do
        arbiter = double(Arbiter::ValidMoves, find: [])
        allow(Arbiter::ValidMoves).to receive(:new).and_return(arbiter)
        allow($stdin).to receive(:gets).and_return('')

        expect { player.get_valid_move(game) }.to output("No moves possible\nPress <enter> to continue\n").to_stdout
      end
    end
  end

  context 'update' do
    let(:player) { Player::Human.new('x') }

    it 'requires a list of board-states' do
      expect { player.update }.to raise_error(ArgumentError)
      expect { player.update('invalid-input') }.to raise_error(ArgumentError)
    end

    it 'does nothing in case of the human player' do
      player.update(1, [])
    end
  end

  def build_game_with_active_player(board, player)
    game = Game.new(board, player, player)
    game.set_active_player(player)
    game
  end
end
