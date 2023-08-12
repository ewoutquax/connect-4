package board

import (
	"encoding/json"
	"math"
)

func (b Board) ToState() string {
	stateLines := make([]int, 7)

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
	var rowIdx, value int

	json.Unmarshal([]byte(state), &stateLines)

	board.Line = make(map[int][]Chip, 7)

	for lineIdx, stateLine := range stateLines {
		rowIdx = 0
		for value = stateLine; value > 0; value /= 3 {
			board.Line[lineIdx] = append(board.Line[lineIdx], Chip(value%3))
			rowIdx++
		}
		for rowIdx < 6 {
			board.Line[lineIdx] = append(board.Line[lineIdx], None)
			rowIdx++
		}
	}

	return
}
