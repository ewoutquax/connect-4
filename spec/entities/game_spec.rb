require 'rspec'
require 'bootstrapper'

RSpec.describe Game do
  context 'init' do
    it 'requires a board and 2 players' do
      player_1 = Player::Human.new('x')
      player_2 = Player::Human.new('o')
      board = Board.new

      game = Game.new(board, player_1, player_2)

      expect(game).to be_kind_of(Game)
    end
  end

  context 'play game' do
    let(:board)    { Board.new }
    let(:player_1) { Player::Human.new('x') }
    let(:player_2) { Player::Human.new('o') }
    let(:game)     { Game.new(board, player_1, player_2) }

    context 'init' do
      it 'lets player1 start' do
        game.active_player_next_round

        expect(game.active_player).to be(player_1)
      end
    end

    context 'play single round' do
      before do
        drawer = double('Drawer::Board', exec: nil)
        round  = game.instance_variable_get('@single_round')
        drawer = round.instance_variable_set('@drawer', drawer)

        allow($stdin).to receive(:gets).and_return('4')

        game.active_player_next_round
      end

      it 'draws the board' do
        round = game.instance_variable_get('@single_round')
        drawer = round.instance_variable_get('@drawer')
        expect(drawer).to receive(:exec)

        game.play_round
      end

      context 'when a move is available' do
        it 'asks the active player to choose from the available moves' do
          expect { game.play_round }.to output("Valid moves: 1, 2, 3, 4, 5, 6, 7\nYour choice:\n").to_stdout
        end

        it 'makes the chosen move (= 4; see setup)' do
          state_column = 1 * 3 ** 3
          expected_state = "[0,0,0,0,0,#{state_column}]"

          game.play_round

          expect(board.state).to eq(expected_state)
        end

        it 'adds the new board-state to the list of states' do
          state_column = 1 * 3 ** 3
          expected_state = "[0,0,0,0,0,#{state_column}]"

          game.play_round

          expect(game.states['x']).to eq([expected_state])
        end
      end
    end

    context 'next round' do
      before do
        game.active_player_next_round
      end

      it 'makes player2 active in the next turn' do
        expect(game.active_player).to be(player_1)

        game.active_player_next_round
        expect(game.active_player).to be(player_2)
      end
    end

    context 'at the end' do
      it 'calls the update function of each player, with its score and all the states' do
        expect(game).to receive(:ended?).and_return(true)
        expect(player_1).to receive(:update)
        expect(player_2).to receive(:update)

        game.play
      end
    end
  end

  # context 'training_game' do
  #   context 'spawn' do
  #     let(:board)        { Board.new }
  #     let(:player)       { Player::Human.new('z') }
  #     let(:other_player) { Player::Human.new('w') }
  #     let(:game)         { build_game_with_active_player(board, player, other_player) }
  #     let(:training)     { game.spawn_training(player, 'c4') }

  #     it 'builds a training game' do
  #       expect(game.training?).to eq(false)
  #       expect(training.training?).to eq(true)
  #     end

  #     it 'forces the first move' do
  #       board.make_move('c4', player.color)

  #       8.times do |index|
  #         expect(board.rows[index]).to eq(training.board.rows[index])
  #       end # /index
  #     end

  #     it 'has two AI-players' do
  #       expect(training.instance_variable_get("@player1")).to be_kind_of(Player::AI)
  #       expect(training.instance_variable_get("@player2")).to be_kind_of(Player::AI)
  #     end

  #     it 'both AI-players have adjusted Alpha and Gamma' do
  #       player_1 = training.instance_variable_get("@player1")
  #       player_2 = training.instance_variable_get("@player2")

  #       [player_1, player_2].each do |player|
  #         expect(player.instance_variable_get("@alpha")).to eq(0.4)
  #         expect(player.instance_variable_get("@gamma")).to eq(0.85)
  #         expect(player.instance_variable_get("@epsilon")).to eq(0.8)
  #       end # /player
  #     end

  #     it 'after spawn, the initiating_player is the active player' do
  #       active_player = training.instance_variable_get('@active_player')

  #       expect(active_player.color).to eq(player.color)
  #     end
  #   end
  # end

  def build_game_with_board_and_players(board, player_1, player_2)
    Game.new(board, player_1, player_2)
  end

  def build_game_with_active_player(board, player_1, player_2)
    game = Game.new(board, player_1, player_2)
    game.set_active_player(player_1)
    game
  end
end
