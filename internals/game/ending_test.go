package game_test

import (
	"testing"

	"github.com/ewoutquax/connect-4/internals/board"
	. "github.com/ewoutquax/connect-4/internals/game"
	"github.com/stretchr/testify/assert"
)

func TestIsEndedEmptyBoard(t *testing.T) {
	game := Building()

	assert.False(t, game.IsEnded())
}

func TestIsEndedFullBoard(t *testing.T) {
	game := Building(
		withFullBoard,
	)

	assert.True(t, game.IsEnded())
}

func TestIsEndedCurrentPlayerWins(t *testing.T) {
	redWinBoard := board.FromState(board.State("[2,1,7,7,1,0,0]"))
	game := Building(
		WithBoard(redWinBoard),
	)

	assert.True(t, game.IsEnded())
}

func TestIsEndedOtherPlayerWins(t *testing.T) {
	redWinBoard := board.FromState(board.State("[2,1,7,7,1,0,0]"))
	game := Building(
		WithBoard(redWinBoard),
	)

	game.CurrentPlayer = game.PlayerYellow

	assert.False(t, game.IsEnded())
}

func withFullBoard(g *Game) {
	b := board.FromState(board.State("[243,243,243,243,243,243,243]"))
	g.Board = b
}
