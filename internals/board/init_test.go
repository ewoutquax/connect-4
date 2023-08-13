package board_test

import (
	"fmt"
	"reflect"
	"testing"

	. "github.com/ewoutquax/connect-4/internals/board"
	"github.com/stretchr/testify/assert"
)

func TestEmptyBoard(t *testing.T) {
	assert := assert.New(t)

	board := Init()
	boardType := fmt.Sprintf("%s", reflect.TypeOf(board))

	assert.Equal("board.Board", boardType)
	assert.Equal(7, len(board.Line))

	for idx := 0; idx < 7; idx++ {
		assert.Equal(6, len(board.Line[idx]))
	}

	assert.Equal(0, len(board.States))
}
