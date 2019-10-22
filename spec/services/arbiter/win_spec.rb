require 'bootstrapper'

describe Arbiter::Win do
  it 'can be instantiated' do
    expect(Arbiter::Win.new(Board.new)).to be_kind_of(Arbiter::Win)
  end

  context 'can determine x as the winner' do
    it 'returns false for an initial board' do
      board = Board.new
      arbiter = Arbiter::Win.new(board)

      expect(arbiter.winner?('x')).to eq(false)
    end

    it 'returns true for 4 x-s horizontal' do
      state = [
        0,0,0,0,0, (
          1 * 3 ** 0 +
          1 * 3 ** 1 +
          1 * 3 ** 2 +
          1 * 3 ** 3
        )].to_json

      assert_win_for_state(state)
    end

    it 'returns true for 4 x-s vertical' do
      state = [
        0,
        0,
        1 * 3 ** 0,
        1 * 3 ** 0,
        1 * 3 ** 0,
        1 * 3 ** 0
      ].to_json

      assert_win_for_state(state)
    end

    it 'returns true for 4 x-s backwards diagonal' do
      state = [
        0,
        0,
        1 * 3 ** 0,
        1 * 3 ** 1,
        1 * 3 ** 2,
        1 * 3 ** 3
      ].to_json

      assert_win_for_state(state)
    end

    it 'returns true for 4 x-s forwards diagonal' do
      state = [
        0,
        0,
        1 * 3 ** 3,
        1 * 3 ** 2,
        1 * 3 ** 1,
        1 * 3 ** 0
      ].to_json

      assert_win_for_state(state)
    end

    def assert_win_for_state(state)
      board = Board.new(state)
      arbiter = Arbiter::Win.new(board)

      expect(arbiter.winner?('x')).to eq(true)
    end
  end
end
