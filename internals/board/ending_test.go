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
	fullState := "[243,243,243,243,243,243,243]"
	board := FromState(fullState)

	assert.True(t, board.IsFull())
}
