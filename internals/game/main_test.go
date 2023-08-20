package game

import (
	"os"
	"strconv"
	"testing"

	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/internals/player"
	"github.com/ewoutquax/connect-4/utils"
	"github.com/stretchr/testify/assert"
)

type MockedPlayingMoves struct {
	list []int
}

type StdinReaderMockPlaying struct {
	moves *MockedPlayingMoves
}

func (m StdinReaderMockPlaying) StdinReaderExec() (move string) {
	move = strconv.Itoa(m.moves.list[0])
	m.moves.list = m.moves.list[1:]

	return
}

func TestMain(m *testing.M) {
	os.Setenv("GOENV", "TEST")
	utils.ClearRedis()
	exitCode := m.Run()
	utils.ClearRedis()
	os.Exit(exitCode)
}

func TestPlayWithTwoHumanPlayers(t *testing.T) {
	moves := MockedPlayingMoves{
		list: []int{3, 3, 4, 4, 2, 1, 5},
	}
	mock := StdinReaderMockPlaying{
		moves: &moves,
	}

	// game := Building(player.PlayerKindHuman, player.PlayerKindHuman, mock)
	game := Building(
		WithPlayerRed(player.PlayerKindHuman),
		WithPlayerYellow(player.PlayerKindHuman),
		WithStdinReader(mock),
	)

	game.Play()

	boardStatesWin :=
		[]board.State{
			"[0,0,1,0,0,0,0]",
			"[0,0,7,1,0,0,0]",
			"[0,1,7,7,0,0,0]",
			"[2,1,7,7,1,0,0]",
		}
	boardStatesLoose :=
		[]board.State{
			"[0,0,7,0,0,0,0]",
			"[0,0,7,7,0,0,0]",
			"[2,1,7,7,0,0,0]",
		}
	resultStates := utils.GetAll()

	assert := assert.New(t)
	assert.InDelta(0.71494375, resultStates[string(boardStatesWin[0])].Score, 0.01)
	assert.InDelta(0.752875, resultStates[string(boardStatesWin[1])].Score, 0.001)
	assert.InDelta(0.7975, resultStates[string(boardStatesWin[2])].Score, 0.0001)
	assert.InDelta(0.85, resultStates[string(boardStatesWin[3])].Score, 0.00001)

	assert.InDelta(0.247125, resultStates[string(boardStatesLoose[0])].Score, 0.001)
	assert.InDelta(0.2025, resultStates[string(boardStatesLoose[1])].Score, 0.0001)
	assert.InDelta(0.15, resultStates[string(boardStatesLoose[2])].Score, 0.00001)
}
