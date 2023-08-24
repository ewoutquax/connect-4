package game

import (
	"fmt"

	"github.com/ewoutquax/connect-4/internals/ai"
	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/internals/player"
)

const epochTrainingRounds int = 100

func (g *Game) Play() {
	var otherPlayer, t *player.Player

	if g.CurrentPlayer == g.PlayerRed {
		otherPlayer = g.PlayerYellow
	} else {
		otherPlayer = g.PlayerRed
	}

	for !g.IsEnded() {
		g.CurrentPlayer.PlayRound(&g.Board, g.trainingGame())
		if !g.IsEnded() {
			// Other player can make move, by swapping the current player and the other player
			t = g.CurrentPlayer
			g.CurrentPlayer = otherPlayer
			otherPlayer = t
		}
	}

	if !g.Training {
		fmt.Printf("internals/game/main.go: Play: score for player with chip '%v': '%f'\n", g.CurrentPlayer.Chip, g.CurrentPlayer.Score())
		fmt.Printf("internals/game/main.go: Play: score for player with chip '%v': '%f'\n", otherPlayer.Chip, otherPlayer.Score())
	}

	ai.Update(g.CurrentPlayer.Score(), g.CurrentPlayer.Alfa, g.CurrentPlayer.Gamma, g.CurrentPlayer.BoardStates)
	ai.Update(otherPlayer.Score(), otherPlayer.Alfa, otherPlayer.Gamma, otherPlayer.BoardStates)
}

func (g *Game) trainingGame() func(int) {
	return func(move int) {
		if !g.Training {
			fmt.Printf("internals/game/main.go: trainingGame: training move '%d'\n", move)
			for i := epochTrainingRounds; i > 0; i-- {
				trainingGame := BuildingTraining(
					WithCurrentPlayer(g.CurrentPlayer.Chip),
					WithBoard(board.FromState(g.Board.ToState())),
					WithNextMove(move),
				)

				trainingGame.Play()
			}
		}
	}
}
