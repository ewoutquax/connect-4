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
    expect(aiplayer.q_states).to eq({})
  end

  context 'generate move' do
    it 'returns a greedy move, based on value' do
      expect(aiplayer).to receive(:make_greedy_move?).and_return(true)

      expect(aiplayer_with_episode.generate_move).to eq(1)
    end
    it 'returns a random move' do
      expect(aiplayer).to receive(:make_greedy_move?).and_return(false)
      expect(Kernel).to receive(:rand).and_return(0.3)

      expect(aiplayer_with_episode.generate_move).to eq(3)
    end
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
      it 'is an empty array upon initialisation' do
        expect(aiplayer_with_episode.episode.states).to eq([])
      end

      it 'adds the state to the episode after each move' do
        state1 = [
          '0000000',
          '0000000',
          '0000000',
          '0000000',
          '0000000',
          '0000000'
        ].join(' ')

        state2 = [
          '0000000',
          '0000000',
          '0000000',
          '0000000',
          '0000000',
          '000x000'
        ].join(' ')
        expected_result = [ [state1, 3], [state2, 4] ]

        aiplayer_with_episode.make_move(4)
        aiplayer_with_episode.make_move(5)
        expect(aiplayer_with_episode.episode.states).to eq(expected_result)
      end
    end
  end

  context 'update' do
    it 'updates the Q-learning and the values after winning' do
      q_expected_result1 = {
        "0000000 0000000 0000000 0000000 0000000 0000000" => {0=>[1, 0.6141249999999999]},
        "0000000 0000000 0000000 0000000 0000000 x000000" => {1=>[1, 0.7224999999999999]},
        "0000000 0000000 0000000 0000000 0000000 xx00000" => {2=>[1, 0.85]},
        "0000000 0000000 0000000 0000000 0000000 xxx0000" => {3=>[1, 1]}
      }
      q_expected_result2 = {
        "0000000 0000000 0000000 0000000 0000000 0000000" => {0=>[2, 1.2282499999999998]},
        "0000000 0000000 0000000 0000000 0000000 x000000" => {1=>[2, 1.4449999999999998]},
        "0000000 0000000 0000000 0000000 0000000 xx00000" => {2=>[1, 0.85], 3=>[1, 0.85]},
        "0000000 0000000 0000000 0000000 0000000 xx0x000" => {2=>[1, 1]},
        "0000000 0000000 0000000 0000000 0000000 xxx0000" => {3=>[1, 1]}
      }
      q_expected_result3 = {
        "0000000 0000000 0000000 0000000 0000000 0000000" => {0=>[2, 1.2282499999999998], 1=>[1, -0.85]},
        "0000000 0000000 0000000 0000000 0000000 0x00000" => {0=>[1, -1]},
        "0000000 0000000 0000000 0000000 0000000 x000000" => {1=>[2, 1.4449999999999998]},
        "0000000 0000000 0000000 0000000 0000000 xx00000" => {2=>[1, 0.85], 3=>[1, 0.85]},
        "0000000 0000000 0000000 0000000 0000000 xx0x000" => {2=>[1, 1]},
        "0000000 0000000 0000000 0000000 0000000 xxx0000" => {3=>[1, 1]}
      }

      v_expected_result1 = {
        "0000000 0000000 0000000 0000000 0000000 x000000" => 0.6141249999999999,
        "0000000 0000000 0000000 0000000 0000000 xx00000" => 0.7224999999999999,
        "0000000 0000000 0000000 0000000 0000000 xxx0000" => 0.85
      }
      v_expected_result2 = {
        "0000000 0000000 0000000 0000000 0000000 x000000" => 0.6141249999999999,
        "0000000 0000000 0000000 0000000 0000000 xx00000" => 0.7224999999999999,
        "0000000 0000000 0000000 0000000 0000000 xx0x000" => 0.85,
        "0000000 0000000 0000000 0000000 0000000 xxx0000" => 0.85
      }
      v_expected_result3 = {
        "0000000 0000000 0000000 0000000 0000000 x000000" => 0.6141249999999999,
        "0000000 0000000 0000000 0000000 0000000 0x00000" => -0.85,
        "0000000 0000000 0000000 0000000 0000000 xx00000" => 0.7224999999999999,
        "0000000 0000000 0000000 0000000 0000000 xx0x000" => 0.85,
        "0000000 0000000 0000000 0000000 0000000 xxx0000" => 0.85
      }

      player = aiplayer_with_episode
      player.make_move(1)
      player.make_move(2)
      player.make_move(3)
      player.make_move(4)

      player.update

      expect(player.q_states).to eq(q_expected_result1)
      expect(player.v_states).to eq(v_expected_result1)

      player.start_episode(Board.new)
      player.make_move(1)
      player.make_move(2)
      player.make_move(4)
      player.make_move(3)

      player.update

      expect(player.q_states).to eq(q_expected_result2)
      expect(player.v_states).to eq(v_expected_result2)

      player.start_episode(Board.new)

      player2 = AIPlayer.new('o')
      player2.start_episode(aiplayer.episode.board)

      player.make_move(2)
      player.make_move(1)
      player2.make_move(3)
      player2.make_move(3)
      player2.make_move(3)
      player2.make_move(3)

      player.update
      player2.update

      puts player.episode.states if $verbose

      expect(player.q_states).to eq(q_expected_result3)
      expect(player.v_states).to eq(v_expected_result3)
    end
  end
end
