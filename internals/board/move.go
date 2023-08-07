package board

func (b *Board) MakeMove(lineIdx int, chip Chip) {
	var rowIdx int
	for rowIdx = 5; rowIdx > 0 && b.Line[lineIdx][rowIdx] == None; rowIdx-- {
		continue
	}

	b.Line[lineIdx][rowIdx] = chip
}
