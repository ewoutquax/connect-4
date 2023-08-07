package board

func Init() (board Board) {
	board.Line = make(map[int][]Chip, 7)

	for idx := 0; idx < 7; idx++ {
		board.Line[idx] = make([]Chip, 6)
	}

	return board
}
