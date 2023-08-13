package player

import "github.com/ewoutquax/connect-4/internals/board"

func (p *Player) Score() (score float64) {
	tempBoard := board.FromState(p.BoardStates[len(p.BoardStates)-1])
	if tempBoard.IsWinner(p.Chip) {
		score = 1.0
	} else {
		score = 0.0
	}
	return
}
