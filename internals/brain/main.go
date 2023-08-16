package brain

import (
	"math"

	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/utils"
)

const scoreNeutral float64 = 0.5

func Update(endScore float64, alpha float64, gamma float64, states []board.State) {
	var newStateScore utils.StateScore

	for idx, state := range states {
		power := float64(len(states) - 1 - idx)

		isFound, currentStateScore := utils.GetState(string(state))
		if isFound {
			newStateScore = utils.StateScore{
				Count: currentStateScore.Count + 1,
				Score: currentStateScore.Score + scoreNeutral + (endScore-scoreNeutral)*math.Pow(gamma, power)*alpha,
			}
		} else {
			newStateScore = utils.StateScore{
				Count: 1,
				Score: scoreNeutral + (endScore-scoreNeutral)*math.Pow(gamma, power)*alpha,
			}
		}

		utils.SetState(string(state), newStateScore)
	}
}
