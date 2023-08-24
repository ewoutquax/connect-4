package player_test

import (
	"strconv"
	"testing"

	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/internals/player"
	"github.com/stretchr/testify/assert"
)

type MockedScoringMoves struct {
	list []int
}

type StdinReaderMockScoring struct {
	moves *MockedScoringMoves
}

func (m StdinReaderMockScoring) StdinReaderExec() (next string) {
	next = strconv.Itoa(m.moves.list[0])
	m.moves.list = m.moves.list[1:]

	return
}

func TestRedWins(t *testing.T) {
	moves := MockedScoringMoves{
		list: []int{3, 3, 4, 4, 2, 1, 5},
	}
	mock := StdinReaderMockScoring{
		moves: &moves,
	}

	playerRed := player.Building(
		player.WithKind(player.PlayerKindHuman),
		player.WithChip(board.Red),
		player.WithReader(mock),
	)
	playerYellow := player.Building(
		player.WithKind(player.PlayerKindHuman),
		player.WithChip(board.Yellow),
		player.WithReader(mock),
	)
	myBoard := board.Init()

	playerRed.PlayRound(&myBoard, mockTrainingGame)
	playerYellow.PlayRound(&myBoard, mockTrainingGame)
	playerRed.PlayRound(&myBoard, mockTrainingGame)
	playerYellow.PlayRound(&myBoard, mockTrainingGame)
	playerRed.PlayRound(&myBoard, mockTrainingGame)
	playerYellow.PlayRound(&myBoard, mockTrainingGame)
	playerRed.PlayRound(&myBoard, mockTrainingGame)

	playerRedScore := playerRed.Score()
	playerYellowScore := playerYellow.Score()

	assert := assert.New(t)
	assert.Equal(1.0, playerRedScore)
	assert.Equal(0.0, playerYellowScore)
}
