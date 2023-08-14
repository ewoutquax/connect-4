package brain

import (
	"math"

	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/utils"
)

const scoreNeutral float64 = 0.5

func Update(endScore float64, alpha float64, gamma float64, states []board.State) {

	for idx, state := range states {
		power := float64(len(states) - 1 - idx)

		stateScore := utils.GetState(string(state))
		newStateScore := utils.StateScore{
			Count: stateScore.Count + 1,
			Score: stateScore.Score + scoreNeutral + (endScore-scoreNeutral)*math.Pow(gamma, power)*alpha,
		}

		utils.SetState(string(state), newStateScore)
	}
}
