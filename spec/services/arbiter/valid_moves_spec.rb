require 'bootstrapper'

describe Arbiter::ValidMoves do
  it 'can be instantiated' do
    expect(Arbiter::ValidMoves.new(Board.new)).to be_kind_of(Arbiter::ValidMoves)
  end

  context 'valid moves' do
    it 'returns all 7 rows for a new game' do
      assert_result_for_board(Board.new, [1, 2, 3, 4, 5, 6, 7])
    end

    it 'skips columns which are full' do
      state = [
        1 * 3 ** 1,
        1 * 3 ** 1,
        1 * 3 ** 1,
        1 * 3 ** 1,
        1 * 3 ** 1,
        1 * 3 ** 1,
      ].to_json
      board = Board.new(state)

      assert_result_for_board(board, [1, 3, 4, 5, 6, 7])
    end

    def assert_result_for_board(board, expected_result)
      expect(Arbiter::ValidMoves.new(board).find('_')).to eq(expected_result)
    end
  end
end
