package ai_test

import (
	"fmt"
	"reflect"
	"testing"

	"github.com/ewoutquax/connect-4/internals/ai"
	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/utils"
	"github.com/stretchr/testify/assert"
)

func TestBestMoveForBoard(t *testing.T) {

	utils.SetState("[0,0,0,0,0,1,0]", utils.StateScore{Count: 1, Score: 1.0})

	myBoard := board.Init()
	moves := []int{0, 1, 2, 3, 4, 5, 6}

	move := ai.BestMoveForBoard(
		ai.BuildBestMoveOptions(
			ai.WithMoves(moves),
			ai.WithBoard(&myBoard),
			ai.WithChip(board.Red),
			ai.WithEpsilon(1.0),
		),
	)

	typeMove := fmt.Sprintf("%s", reflect.TypeOf(move))

	assert := assert.New(t)
	assert.Equal("int", typeMove)
	assert.LessOrEqual(0, move)
	assert.LessOrEqual(move, 6)
}
