package ai

import (
	"math"

	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/pkg/storage"
)

const scoreNeutral float64 = 0.5

func Update(endScore float64, alpha float64, gamma float64, states []board.State) {
	var newStateScore storage.StateScore

	for idx, state := range states {
		power := float64(len(states) - 1 - idx)

		isFound, currentStateScore := storage.GetState(string(state))
		if isFound {
			newStateScore = storage.StateScore{
				Count: currentStateScore.Count + 1,
				Score: currentStateScore.Score + scoreNeutral + (endScore-scoreNeutral)*math.Pow(gamma, power)*alpha,
			}
		} else {
			newStateScore = storage.StateScore{
				Count: 1,
				Score: scoreNeutral + (endScore-scoreNeutral)*math.Pow(gamma, power)*alpha,
			}
		}

		storage.SetState(string(state), newStateScore)
	}
}
