module Player
  class Base
    def get_valid_move(_)
      raise NotImplementedError
    end

    def draw_board_before_make_move?
      false
    end # /draw_board_before_make_move?

    def update(score, states)
      local_score = score.to_f

      states.reverse.each do |state|
        if (json = Database.get(state))
          value = JSON.parse(json)
          old_score = value['score']
          value['score']   += (local_score - value['score']) * @alpha / value['counter']
          value['counter'] += 1

          Log.info("Update state '#{state}' with score: #{local_score}")
          Log.info("Old score: #{old_score}; new score: #{value['score']}")
        else
          value = {
            score: local_score,
            counter: 1
          }
          Log.info("Score for new state '#{state}': #{local_score}")
        end

        Database.set(state, value.to_json)

        local_score *= @gamma
      end # /state
    end # /update
  end
end # /Player
