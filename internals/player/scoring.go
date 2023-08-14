package player

import "github.com/ewoutquax/connect-4/internals/board"

const (
	scoreWin  float64 = 1.0
	scoreLose float64 = 0.0
)

func (p *Player) Score() (score float64) {
	tempBoard := board.FromState(p.BoardStates[len(p.BoardStates)-1])
	if tempBoard.IsWinner(p.Chip) {
		score = scoreWin
	} else {
		score = scoreLose
	}
	return
}
