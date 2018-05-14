require 'bootstrap'

describe Board do
  it 'can be instantiated' do
    expect(Board.new).to be_kind_of(::Board)
  end

  it 'has a state' do
    expected_result =
      [
      '0000000',
      '0000000',
      '0000000',
      '0000000',
      '0000000',
      '0000000'
    ].join(' ')

    expect(Board.new.state).to eq(expected_result)
  end

  it 'can accept a state a new-parameter' do
    state = [
      '0000000',
      '0000000',
      '0000000',
      '0000000',
      '00xx000',
      'xxxoo00'
    ].join(' ')

    expect(Board.new(state).state).to eq(state)
  end

  context 'valid moves' do
    it 'returns all 7 rows for a new game' do
      expect(Board.new.valid_moves).to eq([1, 2, 3, 4, 5, 6, 7])
    end

    it 'skips columns that are full' do
      state = [
        'x000000',
        'x000000',
        'x000000',
        'x000000',
        'x000000',
        'x000000'
      ].join(' ')

      expect(Board.new(state).valid_moves).to eq([2, 3, 4, 5, 6, 7])
    end
  end

  context 'make move' do
    it 'first sign in a columns will end up in the bottom row' do
      state1 = [
        '0000000',
        '0000000',
        '0000000',
        '0000000',
        '0000000',
        '00x0000'
      ].join(' ')
      state2 = [
        '0000000',
        '0000000',
        '0000000',
        '0000000',
        '00o0000',
        '00x0000'
      ].join(' ')
      board = Board.new

      board.make_move(2, 'x')
      expect(board.state).to eq(state1)

      board.make_move(2, 'o')
      expect(board.state).to eq(state2)
    end
  end

  context 'ended' do
    context 'can determine x as the winner' do
      it 'returns false for an initial board' do
        expect(Board.new.winner?('x')).to eq(false)
      end
      it 'returns true for 4 x-s horizontal' do
        state = [
          '0000000',
          '0000000',
          '0000000',
          '0000000',
          '0000000',
          '00xxxx0'
        ].join(' ')

        expect(Board.new(state).winner?('x')).to eq(true)
      end
      it 'returns true for 4 x-s vertical' do
        state = [
          '0000000',
          '0000000',
          '00x0000',
          '00x0000',
          '00x0000',
          '00x0000'
        ].join(' ')

        expect(Board.new(state).winner?('x')).to eq(true)
      end
      it 'returns true for 4 x-s backwards diagonal' do
        state = [
          '0000000',
          '0000000',
          '00x0000',
          '000x000',
          '0000x00',
          '00000x0'
        ].join(' ')

        expect(Board.new(state).winner?('x')).to eq(true)
      end
      it 'returns true for 4 x-s backwards diagonal' do
        state = [
          '0000000',
          '0000000',
          '00000x0',
          '0000x00',
          '000x000',
          '00x0000'
        ].join(' ')

        expect(Board.new(state).winner?('x')).to eq(true)
      end
    end

    context 'full board' do
      it 'returns false for an initial state' do
        expect(Board.new.full?).to eq(false)
      end
      it 'returns true for a full state' do
        state = [
          'ooooooo',
          'ooooooo',
          'oooooxo',
          'ooooxoo',
          'oooxooo',
          'ooxoooo'
        ].join(' ')

        expect(Board.new(state).full?).to eq(true)
      end
    end
  end
end
