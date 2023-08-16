package game

import (
	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/internals/player"
)

type Game struct {
	PlayerRed     *player.Player // The player using the red chips, either AI or Human
	PlayerYellow  *player.Player // The player using the yellow chips, either AI or Human
	CurrentPlayer *player.Player // Player who has to make the next move
	Board         board.Board    // The board the players are playing on, with the current state
	Training      bool           // Is this a training session; trainings use different meta-values for learning and can't start new trainings
}
