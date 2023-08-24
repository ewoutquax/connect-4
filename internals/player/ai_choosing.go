package player

import (
	"math/rand"
	"time"

	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/pkg/storage"
)

const thresholdTrainingStateCount int = 10

type BestMoveOptionsFunc func(*BestMoveOptions)

type BestMoveOptions struct {
	Moves            []int
	Board            *board.Board
	Chip             board.Chip
	Epsilon          float64
	HookTrainingGame func(nextMove int)
}

func BestMoveForBoard(options *BestMoveOptions) int {
	var tempBoard board.Board
	var stateScore storage.StateScore
	var highScore float64
	var bestMoves []int

	if rand.Float64() > options.Epsilon {
		bestMoves = options.Moves
	} else {
		origBoardState := options.Board.ToState()

		for _, move := range options.Moves {
			tempBoard = board.FromState(origBoardState)
			tempBoard.MakeMove(move, options.Chip)

			_, stateScore = storage.GetState(string(tempBoard.ToState()))

			if stateScore.Count < thresholdTrainingStateCount {
				options.HookTrainingGame(move)
				// And refetch the now updated score for the new state
				_, stateScore = storage.GetState(string(tempBoard.ToState()))
			}

			if highScore < stateScore.AverageScore {
				highScore = stateScore.AverageScore
				bestMoves = []int{move}
			} else if highScore == stateScore.AverageScore {
				bestMoves = append(bestMoves, move)
			}
		}
	}

	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	idxChoice := r.Intn(len(bestMoves))
	return bestMoves[idxChoice]
}

func BuildBestMoveOptions(optFuncs ...BestMoveOptionsFunc) *BestMoveOptions {
	opts := &BestMoveOptions{}
	for _, fn := range optFuncs {
		fn(opts)
	}

	return opts
}

func WithMoves(moves []int) BestMoveOptionsFunc {
	return func(bmo *BestMoveOptions) { bmo.Moves = moves }
}

func WithBoard(b *board.Board) BestMoveOptionsFunc {
	return func(bmo *BestMoveOptions) { bmo.Board = b }
}

func WithChipForMove(c board.Chip) BestMoveOptionsFunc {
	return func(bmo *BestMoveOptions) { bmo.Chip = c }
}

func WithEpsilon(e float64) BestMoveOptionsFunc {
	return func(bmo *BestMoveOptions) { bmo.Epsilon = e }
}

func WithHookTrainingGame(htg func(int)) BestMoveOptionsFunc {
	return func(bmo *BestMoveOptions) { bmo.HookTrainingGame = htg }
}
