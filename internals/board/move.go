package board

import "sort"

func (b *Board) MakeMove(lineIdx int, chip Chip) {
	var rowIdx int
	for rowIdx = 5; rowIdx > 0 && b.Line[lineIdx][rowIdx-1] == None; rowIdx-- {
		continue
	}

	b.Line[lineIdx][rowIdx] = chip
}

func (b *Board) ValidMoves() (valid []int) {
	for idx, line := range b.Line {
		if line[5] == None {
			valid = append(valid, idx)
		}
	}
	sort.Ints(valid)

	return
}
