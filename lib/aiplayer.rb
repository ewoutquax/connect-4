class AIPlayer
  attr_reader :sign, :episode, :q_state

  def initialize(sign)
    raise ArgumentError, sign.class.to_s unless sign.is_a?(::String)

    @sign = sign
    @rewards = {}
    @q_states = {}
  end

  def start_episode(board)
    raise ArgumentError, board.class.to_s unless board.is_a?(::Board)

    @episode = Episode.new(board)
  end

  def make_move(column)
    @episode.board.make_move(column - 1, @sign)
    @episode.states[@episode.board.state] = column - 1
  end

  def reward
    board = episode.board
    if board.winner?(@sign)
      1
    else
      @rewards[@episode.board] || 0
    end
  end

  def update
    final_reward = reward
    first = true
    @episode.states.reverse.each do |state, move|
      if first
        first = false
        @q_states[state] = 0
      else
        @q_states[state] ||= {}
        prev_value = @q_states[state][move] || 0
        @state[state][move] = prev_value + GAMMA * (final_reward - prev_value)
      end
    end
  end

  class Episode
    attr_reader :board, :states

    def initialize(board)
      raise ArgumentError, board.class.to_s unless board.is_a?(::Board)

      @board = board
      @states = {}
    end
  end
end
