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

  def save_state
    f = File.open("q_state_player_#{@sign}.json", "w")
    f.puts @q_states.to_json
    f.close

    f = File.open("v_state_player_#{@sign}.json", "w")
    f.puts @v_states.to_json
    f.close
  end # /save_state

  def load_state
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
      moves.each_with_index do |master_move, index|
        # puts "Starting for nil-values for move #{index} out of #{moves.size}"

        board = Board.new(@episode.board.state)
        board.make_move(master_move - 1, @sign)

        unless @v_states.key?(board.state)
          # puts "v-state 0 for state #{board.state}"
          puts "Starting for nil-values for move #{index} out of #{moves.size}"
          orig_episode = @episode

          200.times do |i|
            # puts "Starting test-episode #{i}" if i%10 == 0

            board = Board.new(orig_episode.board.state)
            dummy_player.start_episode(board)
            dummy_player.episode.set_allow_exploration(false)
            self.start_episode(board)
            @episode.set_allow_exploration(false)
            @episode.set_states(orig_episode.states)
            @episode.make_move(master_move - 1, @sign)

            current_player = self
            begin
              current_player =
                if current_player == self
                  dummy_player
                else
                  self
                end

              move = current_player.generate_move
              # puts "Player #{current_player.sign} chooses: #{move}" if $verbose
              current_player.make_move(move)
              board.draw if $verbose
            end until board.winner?(current_player.sign) || board.full?

            self.update()
            dummy_player.update()
          end
          @episode = orig_episode
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

      # board = Board.new(state)
      # board.make_move(move, @sign)
      # v_board_state = board.state
      # count, score = @q_states[state][move]
      # current_mean = score / count
      # if @v_states.key?(v_board_state)
      #   puts "Previous v-state for #{v_board_state} is: #{@v_states[v_board_state]}" if $verbose
      #   if @v_states[v_board_state] < current_mean
      #     puts "v-state for #{v_board_state} is updated to: #{current_mean}" if $verbose
      #     @v_states[v_board_state] = current_mean
      #   else
      #     puts "v-state for #{v_board_state} is NOT updated to: #{current_mean}" if $verbose
      #   end
      # else
      #   puts "v-state for new #{v_board_state} is set to: #{current_mean}" if $verbose
      #   @v_states[v_board_state] = current_mean
      # end
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
