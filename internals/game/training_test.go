package game_test

import (
	"fmt"
	"reflect"
	"testing"

	"github.com/ewoutquax/connect-4/internals/board"
	. "github.com/ewoutquax/connect-4/internals/game"
	"github.com/ewoutquax/connect-4/internals/player"
	"github.com/stretchr/testify/assert"
)

func TestStartTraining(t *testing.T) {
	// Sets yellow player as current player

	trainingGame := BuildingTraining(
		WithCurrentPlayer(board.Yellow),
		WithBoard(board.FromState(board.State("[0,0,0,7,0,0,0]"))),
		WithNextMove(2),
	)

	typeTraining := fmt.Sprintf("%s", reflect.TypeOf(trainingGame))

	assert := assert.New(t)
	assert.Equal("*game.Game", typeTraining)
	assert.Equal("*game.Game", typeTraining)

	// Use two AI players
	assert.Equal(player.PlayerKindAI, trainingGame.PlayerRed.Kind)
	assert.Equal(player.PlayerKindAI, trainingGame.PlayerYellow.Kind)

	// Set the state after the first move to the state of the correct player
	assert.Equal(0, len(trainingGame.PlayerRed.BoardStates))
	assert.Equal(1, len(trainingGame.PlayerYellow.BoardStates))
	assert.Equal(board.State("[0,0,2,7,0,0,0]"), trainingGame.PlayerYellow.BoardStates[0])

	// Use board with state of previous board, with the first next move done
	assert.Equal(board.State("[0,0,2,7,0,0,0]"), trainingGame.Board.ToState())

	// Sets training to true
	assert.True(trainingGame.Training)

	// Use adjusted meta-values, applicable for training
	assert.Equal(0.5, trainingGame.PlayerRed.Alfa)
	assert.Equal(0.85, trainingGame.PlayerRed.Gamma)
	assert.Equal(0.85, trainingGame.PlayerRed.Epsilon)
	assert.Equal(0.5, trainingGame.PlayerYellow.Alfa)
	assert.Equal(0.85, trainingGame.PlayerYellow.Gamma)
	assert.Equal(0.85, trainingGame.PlayerYellow.Epsilon)
}
