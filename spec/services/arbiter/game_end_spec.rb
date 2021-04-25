require 'rspec'
require 'bootstrapper'

RSpec.describe Arbiter::GameEnd do
  let(:board)    { Board.new }
  let(:player_1) { Player::Human.new('x') }
  let(:player_2) { Player::Human.new('o') }
  let(:game)     { Game.new(board, player_1, player_2) }

  context 'init' do
    it 'requires a game' do
      arbiter = Arbiter::GameEnd.new(game)

      expect(arbiter).to be_kind_of(Arbiter::GameEnd)
    end
  end

  context 'end of game' do
    let(:arbiter) { Arbiter::GameEnd.new(game) }

    it 'returns false by default' do
      expect(arbiter.ended?).to eq(false)
    end

    it 'returns true when the board is full' do
      expect(board).to receive(:full?).and_return(true)

      expect(arbiter.ended?).to eq(true)
    end

    it 'returns true when player-1 has won' do
      arbiter_win = double(Arbiter::Win)
      expect(arbiter_win).to receive(:winner?).with(player_1.sign).and_return(true)
      expect(Arbiter::Win).to receive(:new).and_return(arbiter_win)

      expect(arbiter.ended?).to eq(true)
    end

    it 'returns true when player-2 has won' do
      arbiter_win = double(Arbiter::Win)
      expect(arbiter_win).to receive(:winner?).with(player_1.sign).and_return(false)
      expect(arbiter_win).to receive(:winner?).with(player_2.sign).and_return(true)
      expect(Arbiter::Win).to receive(:new).and_return(arbiter_win)

      expect(arbiter.ended?).to eq(true)
    end
  end
end
