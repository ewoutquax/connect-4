package player_test

import (
	"fmt"
	"testing"

	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/internals/player"
	"github.com/stretchr/testify/assert"
)

type StdinReaderMockInput1 struct {
	move string
}

func (mock StdinReaderMockInput1) StdinReaderExec() string {
	return mock.move
}

// A human player will get the valid moves, make a choice
// via stdin (mocked) and then make that moves
func TestPlayRound(t *testing.T) {
	myBoard := board.Init()

	human := player.New(
		player.WithReader(StdinReaderMockInput1{move: "1"}),
	)

	fmt.Println(myBoard)
	fmt.Println(human)

	human.PlayRound(&myBoard)

	assert := assert.New(t)
	assert.Equal(board.State("[0,1,0,0,0,0,0]"), myBoard.ToState())
	assert.Equal(1, len(human.BoardStates))
	assert.Equal(board.State("[0,1,0,0,0,0,0]"), human.BoardStates[0])
}
