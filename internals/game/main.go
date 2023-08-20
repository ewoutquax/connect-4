package game

import (
	"github.com/ewoutquax/connect-4/internals/ai"
	"github.com/ewoutquax/connect-4/internals/player"
)

func (g *Game) Play() {
	var otherPlayer, t *player.Player

	if g.CurrentPlayer == g.PlayerRed {
		otherPlayer = g.PlayerYellow
	} else {
		otherPlayer = g.PlayerRed
	}

	for !g.IsEnded() {
		g.CurrentPlayer.PlayRound(&g.Board)
		if !g.IsEnded() {
			// Other player can make move, by swapping the current player and the other player
			t = g.CurrentPlayer
			g.CurrentPlayer = otherPlayer
			otherPlayer = t
		}
	}

	ai.Update(g.CurrentPlayer.Score(), g.CurrentPlayer.Alfa, g.CurrentPlayer.Gamma, g.CurrentPlayer.BoardStates)
	ai.Update(otherPlayer.Score(), otherPlayer.Alfa, otherPlayer.Gamma, otherPlayer.BoardStates)
}
