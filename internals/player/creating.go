package player

import "github.com/ewoutquax/connect-4/internals/board"

func New(pk PlayerKind, c board.Chip) Player {
	return Player{
		Kind: pk,
		Chip: c,
	}
}
