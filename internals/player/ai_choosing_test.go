package player_test

import (
	"fmt"
	"reflect"
	"testing"

	"github.com/ewoutquax/connect-4/internals/board"
	. "github.com/ewoutquax/connect-4/internals/player"
	"github.com/ewoutquax/connect-4/pkg/storage"
	"github.com/stretchr/testify/assert"
)

func TestBestMoveForBoard(t *testing.T) {
	storage.SetState("[0,0,0,0,0,1,0]", storage.StateScore{Count: 1, Score: 1.0})

	myBoard := board.Init()
	moves := []int{0, 1, 2, 3, 4, 5, 6}

	move := BestMoveForBoard(
		BuildBestMoveOptions(
			WithMoves(moves),
			WithBoard(&myBoard),
			WithChipForMove(board.Red),
			WithEpsilon(1.0),
			WithHookTrainingGame(mockTrainingGame),
		),
	)

	typeMove := fmt.Sprintf("%s", reflect.TypeOf(move))

	assert := assert.New(t)
	assert.Equal("int", typeMove)
	assert.LessOrEqual(0, move)
	assert.LessOrEqual(move, 6)
}
