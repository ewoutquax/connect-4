module Player
  class Base
    def get_valid_move(_)
      raise NotImplementedError
    end

    def update(_score, states)
      raise ArgumentError, states.class.to_s unless states.is_a?(Array)

      raise NotImplementedError
    end # /update
  end
end # /Player
