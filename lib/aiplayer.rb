class AIPlayer
  attr_reader :sign, :episode, :q_states, :v_states

  def initialize(sign)
    raise ArgumentError, sign.class.to_s unless sign.is_a?(::String)

    @sign = sign
    @rewards = {}
    @q_states = {}
    @v_states = {}


    @alpha = 0.1
    @gamma = 0.85
    @epsilon = 0.05
  end

  def start_episode(board)
    raise ArgumentError, board.class.to_s unless board.is_a?(::Board)

    @episode = Episode.new(board)
  end

  def generate_move
    moves = @episode.board.valid_moves
    if make_greedy_move?
      _value, selected_move =
        moves.inject([nil, nil]) do |best_selected, move|
          best, selected = best_selected

          board = Board.new(@episode.board.state)
          board.make_move(move - 1, @sign)
          value = @v_states[board.state] || 0

          puts "Found move #{move} with value #{value}" if $verbose

          if best.nil? || best < value
            [value, move]
          else
            [best, selected]
          end
        end # /move
      selected_move
    else
      puts "make random move" if $verbose
      index = (Kernel.rand *  moves.length).floor
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
      @rewards[@episode.board] || 0
    end
  end # /reward

  def update
    target = reward
    first = true

    @episode.states.reverse.each do |state, move|
      if first
        first = false
        @q_states[state] ||= {}
        @q_states[state][move] ||= [0, 0]
        counter, score = @q_states[state][move]
        @q_states[state][move] = [counter + 1, score + target]
      else
        @q_states[state] ||= {}
        counter, prev_value = @q_states[state][move] || [0, 0]
        # @q_states[state][move] = (1 - @alpha) * prev_value + @alpha * @gamma * (target - prev_value)
        # @q_states[state][move] = [counter + 1, prev_value + @gamma * (target - prev_value)]
        @q_states[state][move] = [counter + 1, prev_value + @gamma * target]

        # max_mean =
        #   @q_states[state].inject(nil) do |acc, (move, counter_value)|
        #     counter, value = counter_value
        #     mean = value / counter
        #     if acc.nil?
        #       mean
        #     elsif acc < mean
        #       mean
        #     else
        #       acc
        #     end
        #   end

        target *= @gamma
      end

      board = Board.new(state)
      board.make_move(move, @sign)
      v_board_state = board.state
      count, score = @q_states[state][move]
      current_mean = score / count
      if @v_states.key?(v_board_state)
        puts "Previous v-state for #{v_board_state} is: #{@v_states[v_board_state]}" if $verbose
        if @v_states[v_board_state] < current_mean
          puts "v-state for #{v_board_state} is updated to: #{current_mean}" if $verbose
          @v_states[v_board_state] = current_mean
        else
          puts "v-state for #{v_board_state} is NOT updated to: #{current_mean}" if $verbose
        end
      else
        puts "v-state for new #{v_board_state} is set to: #{current_mean}" if $verbose
        @v_states[v_board_state] = current_mean
      end
    end
  end

  private

    def make_greedy_move?
      Kernel.rand > @epsilon
    end

  class Episode
    attr_reader :board, :states

    def initialize(board)
      raise ArgumentError, board.class.to_s unless board.is_a?(::Board)

      @board = board
      @states = []
    end

    def make_move(column, sign)
      @states << [@board.state, column]
      @board.make_move(column, sign)
    end # /make_move
  end
end
