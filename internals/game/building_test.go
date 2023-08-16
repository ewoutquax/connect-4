package game_test

import (
	"fmt"
	"reflect"
	"testing"

	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/internals/game"
	"github.com/ewoutquax/connect-4/internals/player"
	"github.com/stretchr/testify/assert"
)

func TestBuilding(t *testing.T) {
	game := game.Building(
		game.WithPlayerRed(player.PlayerKindHuman),
		game.WithPlayerYellow(player.PlayerKindAI),
		game.WithTraining,
	)

	typeGame := fmt.Sprintf("%s", reflect.TypeOf(game))
	typePlayerRed := fmt.Sprintf("%s", reflect.TypeOf(game.PlayerRed))
	typePlayerYellow := fmt.Sprintf("%s", reflect.TypeOf(game.PlayerYellow))
	typeBoard := fmt.Sprintf("%s", reflect.TypeOf(game.Board))

	assert := assert.New(t)
	assert.Equal("*game.Game", typeGame)
	assert.Equal("*player.Player", typePlayerRed)
	assert.Equal("*player.Player", typePlayerYellow)
	assert.Equal("board.Board", typeBoard)

	assert.Equal(board.Red, game.PlayerRed.Chip)
	assert.Equal(player.PlayerKindHuman, game.PlayerRed.Kind)
	assert.Equal(0, len(game.PlayerRed.BoardStates))

	assert.Equal(board.Yellow, game.PlayerYellow.Chip)
	assert.Equal(player.PlayerKindAI, game.PlayerYellow.Kind)
	assert.Equal(0, len(game.PlayerYellow.BoardStates))

	assert.Equal(board.State("[0,0,0,0,0,0,0]"), game.Board.ToState())
	assert.False(game.Board.IsFull())

	assert.True(game.Training)
}
