package board

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestIsFullForInitBoard(t *testing.T) {
	board := Init()

	assert.False(t, board.IsFull())
}

func TestIsFullForFullBoard(t *testing.T) {
	fullState := State("[243,243,243,243,243,243,243]")
	board := FromState(fullState)

	assert.True(t, board.IsFull())
}

func TestIsNotWinner(t *testing.T) {
	board := Init()

	assert.False(t, board.IsWinner(Red))
}

func TestIsWinnerHorizontal(t *testing.T) {
	board := Init()

	board.MakeMove(1, Red)
	board.MakeMove(2, Red)
	board.MakeMove(3, Red)
	board.MakeMove(4, Red)

	assert.True(t, board.IsWinner(Red))
	assert.False(t, board.IsWinner(Yellow))
}

func TestIsWinnerVertical(t *testing.T) {
	board := Init()

	board.MakeMove(2, Red)
	board.MakeMove(2, Red)
	board.MakeMove(2, Red)
	board.MakeMove(2, Red)

	assert.True(t, board.IsWinner(Red))
	assert.False(t, board.IsWinner(Yellow))
}

func TestIsWinnerForwardDiagonal(t *testing.T) {
	board := Init()

	board.MakeMove(1, Yellow)
	board.MakeMove(2, Yellow)
	board.MakeMove(2, Yellow)
	board.MakeMove(3, Yellow)
	board.MakeMove(3, Yellow)
	board.MakeMove(3, Yellow)

	board.MakeMove(0, Red)
	board.MakeMove(1, Red)
	board.MakeMove(2, Red)
	board.MakeMove(3, Red)

	assert.True(t, board.IsWinner(Red))
	assert.False(t, board.IsWinner(Yellow))
}

func TestIsWinnerBackwardDiagonal(t *testing.T) {
	board := Init()

	board.MakeMove(1, Yellow)
	board.MakeMove(1, Yellow)
	board.MakeMove(1, Yellow)
	board.MakeMove(2, Yellow)
	board.MakeMove(2, Yellow)
	board.MakeMove(3, Yellow)

	board.MakeMove(1, Red)
	board.MakeMove(2, Red)
	board.MakeMove(3, Red)
	board.MakeMove(4, Red)

	assert.True(t, board.IsWinner(Red))
	assert.False(t, board.IsWinner(Yellow))
}
