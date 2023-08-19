package player

import (
	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/utils"
)

type PlayerKind uint8

const (
	PlayerKindHuman PlayerKind = iota + 1 // Player is controlled by a human; questions will be answered via a prompt
	PlayerKindAI                          // Player is controlled by computer; questions will not be prompted, but calculated
)

type Player struct {
	Alfa    float64 // How solid is each step made. Normal: 0.7, but can be lower when epsilon is lower
	Gamma   float64 // How solid is this move compared to the list of move. Normal: 0.85
	Epsilon float64 // How often should we just do a blind guess between the valid move; normal: 0.95

	Kind PlayerKind // Human or AI player
	Chip board.Chip // Color of the chip of this player

	Reader utils.StdinReader
	Writer utils.StdoutWriter

	BoardStates []board.State // List of board-states the player has had this game
}
