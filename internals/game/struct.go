package game

import (
	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/internals/player"
)

type Game struct {
	PlayerRed    player.Player
	PlayerYellow player.Player
	Board        board.Board
	Training     bool
}
