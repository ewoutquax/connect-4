package board

func (b Board) IsFull() bool {
	for _, line := range b.Line {
		if line[5] == None {
			return false
		}
	}

	return true
}

func (b *Board) IsWinner(c Chip) bool {
	return isWinnerHorizontal(b, c) ||
		isWinnerVertical(b, c) ||
		isWinnerForwardDiagonal(b, c) ||
		isWinnerBackwardDiagonal(b, c)
}

func isWinnerHorizontal(b *Board, c Chip) bool {
	for idxRow := 5; idxRow >= 0; idxRow-- {
		for idxLine := 0; idxLine <= 3; idxLine++ {
			if b.Line[idxLine+0][idxRow] == c &&
				b.Line[idxLine+1][idxRow] == c &&
				b.Line[idxLine+2][idxRow] == c &&
				b.Line[idxLine+3][idxRow] == c {
				return true
			}
		}
	}

	return false
}

func isWinnerVertical(b *Board, c Chip) bool {
	for idxRow := 5; idxRow >= 3; idxRow-- {
		for idxLine := 0; idxLine <= 6; idxLine++ {
			if b.Line[idxLine][idxRow-0] == c &&
				b.Line[idxLine][idxRow-1] == c &&
				b.Line[idxLine][idxRow-2] == c &&
				b.Line[idxLine][idxRow-3] == c {
				return true
			}
		}
	}

	return false
}

func isWinnerForwardDiagonal(b *Board, c Chip) bool {
	for idxRow := 0; idxRow <= 2; idxRow++ {
		for idxLine := 0; idxLine <= 3; idxLine++ {
			if b.Line[idxLine+0][idxRow+0] == c &&
				b.Line[idxLine+1][idxRow+1] == c &&
				b.Line[idxLine+2][idxRow+2] == c &&
				b.Line[idxLine+3][idxRow+3] == c {
				return true
			}
		}
	}

	return false
}

func isWinnerBackwardDiagonal(b *Board, c Chip) bool {
	for idxRow := 5; idxRow >= 3; idxRow-- {
		for idxLine := 0; idxLine <= 3; idxLine++ {
			if b.Line[idxLine+0][idxRow-0] == c &&
				b.Line[idxLine+1][idxRow-1] == c &&
				b.Line[idxLine+2][idxRow-2] == c &&
				b.Line[idxLine+3][idxRow-3] == c {
				return true
			}
		}
	}

	return false
}
