package ai_test

import (
	"os"
	"testing"

	"github.com/ewoutquax/connect-4/internals/ai"
	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/internals/config"
	"github.com/ewoutquax/connect-4/pkg/storage"
	"github.com/stretchr/testify/assert"
)

func TestMain(m *testing.M) {
	os.Setenv("GOENV", "TEST")
	config.ConnectToRedis()
	storage.ClearRedis()
	exitCode := m.Run()
	storage.ClearRedis()
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
	ai.Update(1.0, 0.7, 0.85, boardStates)

	resultStates := storage.GetAll()

	assert := assert.New(t)
	assert.InDelta(0.71494375, resultStates[string(boardStates[0])].Score, 0.01)
	assert.InDelta(0.752875, resultStates[string(boardStates[1])].Score, 0.001)
	assert.InDelta(0.7975, resultStates[string(boardStates[2])].Score, 0.0001)
	assert.InDelta(0.85, resultStates[string(boardStates[3])].Score, 0.00001)
}

func TestUpdateFirstLoose(t *testing.T) {
	boardStates :=
		[]board.State{
			"[0,0,7,0,0,0,0]",
			"[0,0,7,7,0,0,0]",
			"[2,1,7,7,0,0,0]",
		}
	ai.Update(0.0, 0.7, 0.85, boardStates)

	resultStates := storage.GetAll()

	assert := assert.New(t)
	assert.InDelta(0.247125, resultStates[string(boardStates[0])].Score, 0.001)
	assert.InDelta(0.2025, resultStates[string(boardStates[1])].Score, 0.0001)
	assert.InDelta(0.15, resultStates[string(boardStates[2])].Score, 0.00001)
}
