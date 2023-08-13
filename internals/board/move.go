package board

import "sort"

func (b *Board) MakeMove(lineIdx int, chip Chip) {
	var rowIdx int
	for rowIdx = MaxBoardRows - 1; rowIdx > 0 && b.Line[lineIdx][rowIdx-1] == None; rowIdx-- {
		continue
	}

	b.Line[lineIdx][rowIdx] = chip
	b.States = append(b.States, b.ToState())
}

func (b *Board) ValidMoves() (valid []int) {
	for idx, line := range b.Line {
		if line[MaxBoardRows-1] == None {
			valid = append(valid, idx)
		}
	}
	sort.Ints(valid)

	return
}
