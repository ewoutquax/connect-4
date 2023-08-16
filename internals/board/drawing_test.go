package board_test

import (
	"testing"

	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/stretchr/testify/assert"
)

func TestDrawingEmptyBoard(t *testing.T) {
	b := board.Init()

	b.Draw()
	assert.True(t, false)
}

func TestDrawingWithRedAndYellow(t *testing.T) {
	b := board.Init()

	b.MakeMove(3, board.Red)
	b.MakeMove(0, board.Yellow)
	b.MakeMove(1, board.Yellow)

	b.Draw()
	assert.True(t, false)
}
