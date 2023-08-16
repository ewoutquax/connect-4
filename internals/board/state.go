package board

import (
	"encoding/json"
	"math"
)

func (b *Board) ToState() State {
	stateLines := make([]int, MaxBoardLines)

	for idxLine, line := range b.Line {
		for idxRow, chip := range line {
			value := int(chip) * int(math.Pow(float64(StateBaseNumber), float64(idxRow)))
			stateLines[idxLine] += int(value)
		}
	}

	state, _ := json.Marshal(stateLines)
	return State(state)
}

func FromState(s State) (board Board) {
	var stateLines []int
	var rowIdx, value int

	json.Unmarshal([]byte(s), &stateLines)

	board.Line = make(map[int][]Chip, MaxBoardLines)

	for lineIdx, stateLine := range stateLines {
		rowIdx = 0
		for value = stateLine; value > 0; value /= StateBaseNumber {
			board.Line[lineIdx] = append(board.Line[lineIdx], Chip(value%3))
			rowIdx++
		}
		for rowIdx < MaxBoardRows {
			board.Line[lineIdx] = append(board.Line[lineIdx], None)
			rowIdx++
		}
	}

	return
}
