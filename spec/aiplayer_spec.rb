require 'bootstrap'

describe AIPlayer do
  let(:aiplayer) { AIPlayer.new('x') }
  let(:aiplayer_with_episode) { aiplayer.start_episode(Board.new); aiplayer }


  it 'can be instantiated' do
    expect(aiplayer).to be_kind_of(::AIPlayer)
  end

  it 'has a sign' do
    expect(aiplayer.sign).to eq('x')
  end

  it 'q-learning is empty' do
    expect(aiplayer.q_state).to eq({})
  end

  context 'episode' do
    it 'can start a new episode' do
      aiplayer_with_episode

      expect(aiplayer.episode).to be_kind_of(::AIPlayer::Episode)
    end

    it 'can make a move on the board' do
      expected_result = [
        '0000000',
        '0000000',
        '0000000',
        '0000000',
        '0000000',
        '000x000'
      ].join(' ')

      aiplayer_with_episode.make_move(4)
      expect(aiplayer_with_episode.episode.board.state).to eq(expected_result)
    end

    context 'rewards' do
      it 'gets a default reward of 0 for a state' do
        expect(aiplayer_with_episode.reward).to eq(0)
      end
      it 'gets a reward of 1 for a winning state' do
        state = [
          '0000000',
          '0000000',
          '0x00000',
          '0x00000',
          '0x00000',
          '0x00000'].join(' ')
        board = Board.new(state)
        aiplayer.start_episode(board)

        expect(aiplayer.reward).to eq(1)
      end
    end

    context 'episode-state' do
      it 'is an empty hash upon initialisation' do
        expect(aiplayer_with_episode.episode.states).to eq({})
      end

      it 'adds the state to the episode after each move' do
        state1 = [
          '0000000',
          '0000000',
          '0000000',
          '0000000',
          '0000000',
          '000x000'
        ].join(' ')

        state2 = [
          '0000000',
          '0000000',
          '0000000',
          '0000000',
          '0000000',
          '000xx00'
        ].join(' ')
        expected_result = { state1 => 3, state2 => 4 }

        aiplayer_with_episode.make_move(4)
        aiplayer_with_episode.make_move(5)
        expect(aiplayer_with_episode.episode.states).to eq(expected_result)
      end
    end
  end

  context 'update' do
    it 'updates the Q-learning after winning' do
      player = aiplayer_with_episode
      player.make_move(1)
      player.make_move(2)
      player.make_move(3)
      player.make_move(4)

      player.update

      expect(player.q_state).to eq({})
    end
  end
end
