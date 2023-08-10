package player_test

import (
	"fmt"
	"reflect"
	"testing"

	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/internals/player"
	"github.com/stretchr/testify/assert"
)

func TestCreateHumanPlayer(t *testing.T) {
	p := player.New(player.PlayerKindHuman, board.Red)

	kind := fmt.Sprintf("%s", reflect.TypeOf(p))

	assert.Equal(t, "player.Player", kind)
	assert.Equal(t, player.PlayerKindHuman, p.Kind)
	assert.Equal(t, board.Red, p.Chip)
}

func TestCreateAIPlayer(t *testing.T) {
	p := player.New(player.PlayerKindAI, board.Yellow)

	kind := fmt.Sprintf("%s", reflect.TypeOf(p))

	assert.Equal(t, "player.Player", kind)
	assert.Equal(t, player.PlayerKindAI, p.Kind)
	assert.Equal(t, board.Yellow, p.Chip)
}
