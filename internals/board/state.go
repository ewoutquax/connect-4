package board

import (
	"encoding/json"
	"math"
)

func (b Board) toState() string {
	stateLines := make([]int, 6)

	for idxLine, line := range b.Line {
		for idxRow, chip := range line {
			value := int(chip) * int(math.Pow(3.0, float64(idxRow)))
			stateLines[idxLine] += int(value)
		}
	}

	state, _ := json.Marshal(stateLines)
	return string(state)
}

func FromState(state string) (board Board) {
	var stateLines []int

	json.Unmarshal([]byte(state), &stateLines)

	board.Line = make(map[int][]Chip, 7)

	return
}
