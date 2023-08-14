package player

import (
	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/utils"
)

type PlayerKind uint8

const (
	PlayerKindHuman PlayerKind = iota + 1
	PlayerKindAI
)

type Player struct {
	alfa    float64 // How solid is each step made. Normal: 0.7, but can be lower when epsilon is lower
	gamma   float64 // How solid is this move compared to the list of move. Normal: 0.85
	epsilon float64 // How often should we just do a blind guess between the valid move; normal: 0.95

	Kind PlayerKind // Human or AI player
	Chip board.Chip // Color of the chip of this player

	Reader utils.StdinReader
	Writer utils.StdoutWriter

	BoardStates []board.State // List of board-states the player has had this game
}
