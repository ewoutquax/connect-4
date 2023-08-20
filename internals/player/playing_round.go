package player

import (
	"fmt"

	utils "github.com/ewoutquax/aoc-go-utils"
	"github.com/ewoutquax/connect-4/internals/ai"
	"github.com/ewoutquax/connect-4/internals/board"
)

func (p *Player) PlayRound(b *board.Board) {
	var move int

	if p.Kind == PlayerKindHuman {
		b.Draw()
		move = p.chooseMoveHuman(b.ValidMoves(), b)
	}
	if p.Kind == PlayerKindAI {
		move = p.chooseMoveAI(b.ValidMoves(), b)
	}

	b.MakeMove(move, p.Chip)
	p.BoardStates = append(p.BoardStates, b.ToState())
}

func (p *Player) chooseMoveHuman(allowedMoves []int, b *board.Board) int {
	fmt.Printf("Make a move (%d): ", allowedMoves)
	choice := p.Reader.StdinReaderExec()

	return utils.ConvStrToI(choice) - 1
}

func (p *Player) chooseMoveAI(allowedMoves []int, b *board.Board) (move int) {
	move = ai.BestMoveForBoard(
		ai.BuildBestMoveOptions(
			ai.WithMoves(allowedMoves),
			ai.WithBoard(b),
			ai.WithChip(p.Chip),
			ai.WithEpsilon(p.Epsilon),
		),
	)

	return
}
