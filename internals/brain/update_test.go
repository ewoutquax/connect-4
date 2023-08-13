package brain_test

import (
	"testing"

	"github.com/ewoutquax/connect-4/internals/board"
)

// states after quick win: [[0,0,1,0,0,0,0] [0,0,7,1,0,0,0] [0,1,7,7,0,0,0] [2,1,7,7,1,0,0]]
// states after quick loose: [[0,0,7,0,0,0,0] [0,0,7,7,0,0,0] [2,1,7,7,0,0,0]]

func TestUpdateFirstWin(t *testing.T) {
	brain.Update(1.0,
		[]board.State{
			"[0,0,1,0,0,0,0]",
			"[0,0,7,1,0,0,0]",
			"[0,1,7,7,0,0,0]",
			"[2,1,7,7,1,0,0]",
		})
}
