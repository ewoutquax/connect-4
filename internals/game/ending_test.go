package game_test

import (
	"testing"

	. "github.com/ewoutquax/connect-4/internals/game"
	"github.com/stretchr/testify/assert"
)

func TestIsEndedEmptyBoard(t *testing.T) {
	game := Building()

	assert.False(t, game.IsEnded())
}

func TestIsEndedFullBoard(t *testing.T) {
}

func TestIsEndedCurrentPlayerWins(t *testing.T) {
}

func TestIsEndedOtherPlayerWins(t *testing.T) {
}
