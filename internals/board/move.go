package board

func (b *Board) MakeMove(rowNr, chip Chip) {
	var lineNr int

	for lineNr = 5; lineNr > 0; lineNr-- {
		if b.Line[lineNr][rowNr] != None {
			break
		}
	}

	b.Line[lineNr][rowNr] = chip
}
