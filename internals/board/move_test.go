package board

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestMove(t *testing.T) {
	myBoard := Init()
	myBoard.MakeMove(4, Red)

	assert.Equal(t, "[0,0,0,0,1,0,0]", myBoard.toState())
}

func TestTwoMovesInTwoLines(t *testing.T) {
	myBoard := Init()
	myBoard.MakeMove(4, Red)
	myBoard.MakeMove(3, Yellow)

	assert.Equal(t, "[0,0,0,2,1,0,0]", myBoard.toState())
}

func TestTwoMovesInSameLine(t *testing.T) {
	myBoard := Init()
	myBoard.MakeMove(4, Red)
	myBoard.MakeMove(4, Yellow)

	assert.Equal(t, "[0,0,0,0,7,0,0]", myBoard.toState())
}

func TestValidMovesOnInitBoard(t *testing.T) {
	myBoard := Init()
	moves := myBoard.ValidMoves()

	assert.Equal(t, []int{0, 1, 2, 3, 4, 5, 6}, moves)
}

func TestValidMovesWithTwoFullLines(t *testing.T) {
	myBoard := Init()

	for idx := 6; idx > 0; idx-- {
		myBoard.MakeMove(2, Red)
		myBoard.MakeMove(4, Yellow)
	}

	moves := myBoard.ValidMoves()

	assert.Equal(t, []int{0, 1, 3, 5, 6}, moves)
}
