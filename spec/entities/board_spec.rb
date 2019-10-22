require 'bootstrapper'

describe Board do
  it 'can be instantiated' do
    expect(Board.new).to be_kind_of(::Board)
  end

  it 'has a state' do
    expected_result = "[0,0,0,0,0,0]"

    expect(Board.new.state).to eq(expected_result)
  end

  it 'can accept a state in the new-parameter' do
    state = [
      0,
      0,
      0,
      0,
      (2 * 3 ** 2) + (2 * 3 ** 3),
      (1 * 3 ** 2) + (1 * 3 ** 3),
    ].to_json

    expect(Board.new(state).state).to eq(state)
  end

  context 'make move' do
    it 'first chip in a columns will end up in the bottom row' do
      state1 = [
        0,
        0,
        0,
        0,
        0,
        1 * 3 ** 1,
      ].to_json
      state2 = [
        0,
        0,
        0,
        0,
        2 * 3 ** 1,
        1 * 3 ** 1,
      ].to_json
      board = Board.new

      board.make_move(2, 'x')
      expect(board.state).to eq(state1)

      board.make_move(2, 'o')
      expect(board.state).to eq(state2)
    end
  end

  context 'full board' do
    it 'returns false for an initial state' do
      expect(Board.new.full?).to eq(false)
    end

    it 'returns true for a full state' do
      state = [
        1093,
        1093,
        1093,
        1093,
        1093,
        1093
      ].to_json

      expect(Board.new(state).full?).to eq(true)
    end
  end
end
