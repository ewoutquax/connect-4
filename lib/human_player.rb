class HumanPlayer
  attr_reader :sign, :episode, :q_states, :v_states

  def initialize(sign)
    @sign = sign
  end

  def start_episode(board)
    raise ArgumentError, board.class.to_s unless board.is_a?(::Board)

    @episode = Episode.new(board)
  end

  def generate_move
    @episode.board.draw

    $stdin.gets.chomp.to_i
  end # /generate_move

  def make_move(column)
    @episode.make_move(column - 1, @sign)
  end # /make_move

  def update
    nil
  end

  def save_state
    nil
  end # /save_state

  def load_state
    nil
  end # /load_state

  private

  class Episode
    attr_reader :board

    def initialize(board)
      raise ArgumentError, board.class.to_s unless board.is_a?(::Board)

      @board = board
    end

    def make_move(column, sign)
      @board.make_move(column, sign)
    end # /make_move
  end
end
