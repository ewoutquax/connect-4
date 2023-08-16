package game

import (
	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/internals/player"
)

func Building(kind1 player.PlayerKind, kind2 player.PlayerKind) Game {
	return Game{
		PlayerRed:    player.New(kind1, board.Red),
		PlayerYellow: player.New(kind2, board.Yellow),
		Board:        board.Init(),
		Training:     false,
	}
}
