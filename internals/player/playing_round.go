package player

import (
	"fmt"

	utils "github.com/ewoutquax/aoc-go-utils"
	"github.com/ewoutquax/connect-4/internals/board"
)

func (p *Player) PlayRound(b *board.Board) {
	validMoves := b.ValidMoves()
	move := p.ChooseMove(validMoves)
	b.MakeMove(move, p.Chip)
}

func (p *Player) ChooseMove(allowedMoves []int) int {
	fmt.Printf("Make a move (%d): ", allowedMoves)
	choice := p.Reader.StdinReaderExec()

	return utils.ConvStrToI(choice)
}
