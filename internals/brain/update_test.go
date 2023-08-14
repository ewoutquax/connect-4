package brain_test

import (
	"os"
	"testing"

	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/internals/brain"
	"github.com/ewoutquax/connect-4/utils"
	"github.com/stretchr/testify/assert"
)

// states after quick win: [[0,0,1,0,0,0,0] [0,0,7,1,0,0,0] [0,1,7,7,0,0,0] [2,1,7,7,1,0,0]]
// states after quick loose: [[0,0,7,0,0,0,0] [0,0,7,7,0,0,0] [2,1,7,7,0,0,0]]

func TestMain(m *testing.M) {
	os.Setenv("GOENV", "TEST")
	utils.ClearRedis()
	exitCode := m.Run()
	// utils.ClearRedis()
	os.Exit(exitCode)
}

func TestUpdateFirstWin(t *testing.T) {
	boardStates :=
		[]board.State{
			"[0,0,1,0,0,0,0]",
			"[0,0,7,1,0,0,0]",
			"[0,1,7,7,0,0,0]",
			"[2,1,7,7,1,0,0]",
		}
	brain.Update(1.0, 0.7, 0.85, boardStates)

	assert := assert.New(t)
	assert.InDelta(1.21494375, resultStates[string(boardStates[0])].Score, 0.01)
	assert.InDelta(1.252875, resultStates[string(boardStates[1])].Score, 0.001)
	assert.InDelta(1.2975, resultStates[string(boardStates[2])].Score, 0.0001)
	assert.Equal(1.35, resultStates[string(boardStates[3])].Score)
}

func TestUpdateFirstLoose(t *testing.T) {
	boardStates :=
		[]board.State{
			"[0,0,7,0,0,0,0]",
			"[0,0,7,7,0,0,0]",
			"[2,1,7,7,0,0,0]",
		}
	brain.Update(0.0, 0.7, 0.85, boardStates)

	assert := assert.New(t)
	assert.InDelta(0.747125, resultStates[string(boardStates[0])].Score, 0.001)
	assert.InDelta(0.7025, resultStates[string(boardStates[1])].Score, 0.0001)
	assert.Equal(0.65, resultStates[string(boardStates[2])].Score)
}
