package player_test

import (
	"fmt"
	"reflect"
	"testing"

	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/internals/player"
	"github.com/stretchr/testify/assert"
)

type StdinReaderMockMessage struct {
	message string
}

func (reader StdinReaderMockMessage) StdinReaderExec() string {
	return reader.message
}

func TestCreateHumanPlayer(t *testing.T) {
	p := player.New(player.PlayerKindHuman, board.Red)

	kind := fmt.Sprintf("%s", reflect.TypeOf(p))
	reader := fmt.Sprintf("%s", reflect.TypeOf(p.Reader))

	assert.Equal(t, "player.Player", kind)
	assert.Equal(t, player.PlayerKindHuman, p.Kind)
	assert.Equal(t, board.Red, p.Chip)
	assert.Equal(t, "utils.StdinReaderDefault", reader)
}

func TestCreateHumanPlayerWithMockedStdInReader(t *testing.T) {
	p := player.New(player.PlayerKindHuman, board.Red, StdinReaderMockMessage{message: "mocking succeeded"})

	kind := fmt.Sprintf("%s", reflect.TypeOf(p))
	reader := fmt.Sprintf("%s", reflect.TypeOf(p.Reader))

	assert.Equal(t, "player.Player", kind)
	assert.Equal(t, player.PlayerKindHuman, p.Kind)
	assert.Equal(t, board.Red, p.Chip)
	assert.Equal(t, "player_test.StdinReaderMockMessage", reader)
	assert.Equal(t, "mocking succeeded", p.Reader.StdinReaderExec())
}

func TestCreateAIPlayer(t *testing.T) {
	p := player.New(player.PlayerKindAI, board.Yellow)

	kind := fmt.Sprintf("%s", reflect.TypeOf(p))
	reader := fmt.Sprintf("%s", reflect.TypeOf(p.Reader))

	assert.Equal(t, "player.Player", kind)
	assert.Equal(t, player.PlayerKindAI, p.Kind)
	assert.Equal(t, board.Yellow, p.Chip)
	assert.Equal(t, "utils.StdinReaderNone", reader)
}
