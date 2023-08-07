package board

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestMove(t *testing.T) {
	myBoard := Init()
	myBoard.MakeMove(4, Red)

	assert.Equal(t, "[81,0,0,0,0,0]", myBoard.toState())
}
