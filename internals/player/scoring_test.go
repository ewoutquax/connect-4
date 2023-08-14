package player_test

import (
	"strconv"
	"testing"

	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/internals/player"
	"github.com/stretchr/testify/assert"
)

type Moves struct {
	list []int
}

type StdinReaderMockScoring struct {
	moves *Moves
}

func (m StdinReaderMockScoring) StdinReaderExec() (next string) {
	next = strconv.Itoa(m.moves.list[0])
	m.moves.list = m.moves.list[1:]

	return
}

func TestRedWins(t *testing.T) {
	moves := Moves{
		list: []int{2, 2, 3, 3, 1, 0, 4},
	}
	mock := StdinReaderMockScoring{
		moves: &moves,
	}

	playerRed := player.New(player.PlayerKindHuman, board.Red, mock)
	playerYellow := player.New(player.PlayerKindHuman, board.Yellow, mock)
	myBoard := board.Init()

	playerRed.PlayRound(&myBoard)
	playerYellow.PlayRound(&myBoard)
	playerRed.PlayRound(&myBoard)
	playerYellow.PlayRound(&myBoard)
	playerRed.PlayRound(&myBoard)
	playerYellow.PlayRound(&myBoard)
	playerRed.PlayRound(&myBoard)

	playerRedScore := playerRed.Score()
	playerYellowScore := playerYellow.Score()

	assert := assert.New(t)
	assert.Equal(1.0, playerRedScore)
	assert.Equal(0.0, playerYellowScore)
}
