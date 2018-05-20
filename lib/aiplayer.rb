class AIPlayer < Player
  attr_reader :sign, :q_states, :v_states, :alpha, :epsilon
  attr_accessor :episode

  def initialize(sign)
    raise ArgumentError, sign.class.to_s unless sign.is_a?(::String)

    @sign = sign
    @rewards = {}
    @q_states = {}
    @v_states = {}

    @alpha = 0.7
    @epsilon = 0
    @gamma = 0.85
  end

  def set_alpha(alpha)
    @alpha = alpha
  end # /set_alpha

  def set_epsilon(epsilon)
    @epsilon = epsilon
  end # /set_epsilon

  def save_state
    f = File.open("q_state_player_#{@sign}.json", "w")
    f.puts @q_states.to_json
    f.close

    f = File.open("v_state_player_#{@sign}.json", "w")
    f.puts @v_states.to_json
    f.close
  end # /save_state

  def load_state
    puts "loading start"
    @q_states = {}
    f = File.open("q_state_player_#{@sign}.json")
    temp = JSON.parse(f.gets)
    f.close
    temp.each do |state, values|
      values.each do |move, more_values|
        @q_states[state] ||= {}
        @q_states[state][move.to_i] = more_values
      end # /move, more_values
    end # /key, some_data

    @v_states = {}
    f = File.open("v_state_player_#{@sign}.json")
    @v_states = JSON.parse(f.gets)
    f.close
    puts "loading complete"
  end # /load_state

  def start_episode(board)
    raise ArgumentError, board.class.to_s unless board.is_a?(::Board)

    @episode = Episode.new(board)
  end

  def generate_move
    moves = @episode.board.valid_moves

    if @episode.allow_exploration
      $verbose = false
      puts "Checking for exploration"

      other_sign = @sign == 'x' ? 'o' : 'x'
      dummy_player = AIPlayer.new(other_sign)
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

      index = (Kernel.rand *  selected_moves.length).floor
      selected_moves[index]
    else
      puts "Random move?!?" if $verbose
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
      @rewards[@episode.board] || 1
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
    end
  end

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
