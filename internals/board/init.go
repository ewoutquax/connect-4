package board

func Init() (board Board) {
	board.Line = make(map[int][]Chip, 6)

	for idx := 0; idx < 6; idx++ {
		board.Line[idx] = make([]Chip, 7)
	}

	return board
}
