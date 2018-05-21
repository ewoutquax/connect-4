class AIPlayer < Player
  class VState < Sequel::Model; end
  class QState < Sequel::Model; end

  attr_reader :sign, :alpha, :epsilon
  attr_accessor :episode

  def initialize(sign)
    raise ArgumentError, sign.class.to_s unless sign.is_a?(::String)

    @sign = sign
    @rewards = {}

    @alpha = 0.7
    @epsilon = 0
    @v_states = {}
    @q_states = {}
    @gamma = 0.85
  end

  def set_alpha(alpha)
    @alpha = alpha
  end # /set_alpha

  def set_epsilon(epsilon)
    @epsilon = epsilon
  end # /set_epsilon

  def start_episode(board)
    raise ArgumentError, board.class.to_s unless board.is_a?(::Board)

    @episode = Episode.new(board)
  end

  def generate_move
    moves = @episode.board.valid_moves

    if @q_states[@episode.board.state].nil?
      # puts "Found no state for #{@episode.board.state}"

      max_mean = nil
      QState.where(state: @episode.board.state).each do |q_state|
        @q_states[q_state.state] ||= {}
        @q_states[q_state.state][q_state.move] = [q_state.counter, q_state.value]
        current_mean = q_state.value / q_state.counter
        if max_mean.nil?  || max_mean < current_mean
          max_mean = current_mean
        end
      end # /do q_state
      if max_mean
        @v_states[@episode.board.state] = max_mean
      end
    end

    if @episode.allow_exploration
      $verbose = false
      puts "Checking for exploration"

      other_sign = @sign == 'x' ? 'o' : 'x'
      moves.each_with_index do |move, index|
        board = Board.new(@episode.board.state)
        board.make_move(move - 1, @sign)
        unless @v_states.key?(board.state)
          Game.start_training_for_player(self, move)
        end
      end
      $verbose = true
    end

    if make_greedy_move?
      _value, selected_moves =
        moves.inject([nil, nil]) do |best_selected, move|
          best, selected = best_selected

          board = Board.new(@episode.board.state)
          board.make_move(move - 1, @sign)

          value = @v_states[board.state] || 0

          puts "Found move #{move} with value #{value}" if $verbose

          if best.nil? || best < value
            [value, [move]]
          elsif best == value
            [value, selected << move]
          else
            [best, selected]
          end
        end # /move

      index = (Kernel.rand * selected_moves.length).floor
      selected_moves[index]
    else
      puts 'Random move?!?' if $verbose
      index = (Kernel.rand * moves.length).floor
      moves[index]
    end
  end # /generate_move

  def make_move(column)
    @episode.make_move(column - 1, @sign)
  end # /make_move

  def reward
    board = episode.board
    other_sign = (['x', 'o'] - [@sign]).first
    if board.winner?(@sign)
      1
    elsif board.full? || board.winner?(other_sign)
      -1
    else
      @v_states[@episode.board.state] || 0
    end
  end # /reward

  def update
    target = reward / @gamma

    @episode.states.reverse.each do |state, move|
      @q_states[state] ||= {}
      counter, prev_value = @q_states[state][move] || [0, 0]
      @q_states[state][move] = [counter + 1, prev_value + @gamma * target]
      target *= @gamma

      max_mean = nil
      @q_states[state].each do |move, count_score|
        count, score = count_score
        current_mean = score / count
        if max_mean.nil?  || max_mean < current_mean
          max_mean = current_mean
        end
      end
      @v_states[state] = max_mean
    end # /do state, move
  end

  def save_q_states
    puts "Saving #{@q_states.size} states"
    index = 0
    @q_states.each do |state, moves|
      index += 1
      puts index if index%100 == 0
      moves.each do |move, counter_value|
        counter, value = counter_value

        q_state =
          QState.first(state: state, move: move) ||
          QState.new(state: state, move: move)
        q_state.update(
          counter: counter,
          value:   value
        )
      end # /do move, counter_value
    end # /do state, moves

    @q_states = {}

    # @v_states.each do |state, value|
    #   v_state =
    #     VState.first(state: state) ||
    #     VState.new(
    #       state: state
    #     )
    #   v_state.update(value: value)
    # end # /do state, value
  end # /save_q_states

  private

    def make_greedy_move?
      Kernel.rand > @epsilon
    end

  class Episode
    attr_reader :board, :states, :allow_exploration

    def initialize(board)
      raise ArgumentError, board.class.to_s unless board.is_a?(::Board)

      @board = board
      @states = []
      set_allow_exploration(true)
    end

    def set_states(states)
      @states = states.dup
    end # /set_states(states)

    def set_allow_exploration(value)
      @allow_exploration = value
    end # /set_allow_exploration(value)

    def make_move(column, sign)
      @board.make_move(column, sign)
      @states << [@board.state, column]
    end # /make_move
  end
end
