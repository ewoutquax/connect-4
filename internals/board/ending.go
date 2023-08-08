package board

func (b *Board) IsFull() bool {
	for _, line := range b.Line {
		if line[5] == None {
			return false
		}
	}

	return true
}
