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
	p := player.New(
		player.WithKind(player.PlayerKindHuman),
		player.WithChip(board.Red),
	)

	kind := fmt.Sprintf("%s", reflect.TypeOf(p))
	reader := fmt.Sprintf("%s", reflect.TypeOf(p.Reader))

	assert := assert.New(t)
	assert.Equal("*player.Player", kind)
	assert.Equal(player.PlayerKindHuman, p.Kind)
	assert.Equal(board.Red, p.Chip)
	assert.Equal(0, len(p.BoardStates))
	assert.Equal("utils.StdinReaderDefault", reader)

}

func TestCreateHumanPlayerWithMockedStdInReader(t *testing.T) {
	p := player.New(
		player.WithKind(player.PlayerKindHuman),
		player.WithChip(board.Red),
		player.WithReader(StdinReaderMockMessage{message: "mocking succeeded"}),
	)

	kind := fmt.Sprintf("%s", reflect.TypeOf(p))
	reader := fmt.Sprintf("%s", reflect.TypeOf(p.Reader))

	assert := assert.New(t)
	assert.Equal("*player.Player", kind)
	assert.Equal(player.PlayerKindHuman, p.Kind)
	assert.Equal(board.Red, p.Chip)
	assert.Equal(0, len(p.BoardStates))
	assert.Equal("player_test.StdinReaderMockMessage", reader)
	assert.Equal("mocking succeeded", p.Reader.StdinReaderExec())
}

func TestCreateAIPlayer(t *testing.T) {
	p := player.New(
		player.WithKind(player.PlayerKindAI),
		player.WithChip(board.Yellow),
	)

	kind := fmt.Sprintf("%s", reflect.TypeOf(p))
	reader := fmt.Sprintf("%s", reflect.TypeOf(p.Reader))

	assert := assert.New(t)
	assert.Equal("*player.Player", kind)
	assert.Equal(player.PlayerKindAI, p.Kind)
	assert.Equal(board.Yellow, p.Chip)
	assert.Equal(0, len(p.BoardStates))
	assert.Equal("utils.StdinReaderNone", reader)
}
