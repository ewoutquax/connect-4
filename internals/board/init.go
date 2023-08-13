package board

func Init() (board Board) {
	board.Line = make(map[int][]Chip, MaxBoardLines)

	for idx := 0; idx < MaxBoardLines; idx++ {
		board.Line[idx] = make([]Chip, MaxBoardRows)
	}

	return board
}
