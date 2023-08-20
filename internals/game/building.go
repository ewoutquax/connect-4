package game

import (
	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/internals/player"
	"github.com/ewoutquax/connect-4/utils"
)

type GameOptsFunc func(*Game)

func Building(optFuncs ...GameOptsFunc) *Game {
	g := defaultGame()
	for _, fn := range optFuncs {
		fn(g)
	}
	return g
}

func BuildingTraining(opts ...GameOptsFunc) *Game {
	game := defaultGame()

	game.PlayerRed.Kind = player.PlayerKindAI
	game.PlayerYellow.Kind = player.PlayerKindAI

	for _, fn := range opts {
		fn(game)
	}

	WithTraining(game)

	return game
}

func defaultGame() *Game {
	red := player.Building(
		player.WithKind(player.PlayerKindHuman),
		player.WithChip(board.Red),
	)
	yellow := player.Building(
		player.WithKind(player.PlayerKindHuman),
		player.WithChip(board.Yellow),
	)

	return &Game{
		PlayerRed:     red,
		PlayerYellow:  yellow,
		CurrentPlayer: red,
		Board:         board.Init(),
		Training:      false,
	}
}

func WithPlayerRed(kind player.PlayerKind) GameOptsFunc {
	return func(g *Game) {
		g.PlayerRed.Kind = kind
	}
}

func WithPlayerYellow(kind player.PlayerKind) GameOptsFunc {
	return func(g *Game) {
		g.PlayerYellow.Kind = kind
	}
}

func WithStdinReader(reader utils.StdinReader) GameOptsFunc {
	return func(g *Game) {
		g.PlayerRed.Reader = reader
		g.PlayerYellow.Reader = reader
	}
}

func WithBoard(b board.Board) GameOptsFunc {
	return func(g *Game) {
		g.Board = b
	}
}

func WithTraining(g *Game) {
	g.Training = true

	if g.PlayerRed.Kind == player.PlayerKindAI {
		g.PlayerRed.Alfa = player.MetaTrainingAIAlfa
		g.PlayerRed.Gamma = player.MetaTrainingAIGamma
		g.PlayerRed.Epsilon = player.MetaTrainingAIEpsilon
	}
	if g.PlayerYellow.Kind == player.PlayerKindAI {
		g.PlayerYellow.Alfa = player.MetaTrainingAIAlfa
		g.PlayerYellow.Gamma = player.MetaTrainingAIGamma
		g.PlayerYellow.Epsilon = player.MetaTrainingAIEpsilon
	}
}

func WithCurrentPlayer(chip board.Chip) GameOptsFunc {
	return func(g *Game) {
		switch chip {
		case board.Red:
			g.CurrentPlayer = g.PlayerRed
		case board.Yellow:
			g.CurrentPlayer = g.PlayerYellow
		}
	}
}

func WithNextMove(move int) GameOptsFunc {
	return func(g *Game) {
		g.Board.MakeMove(move, g.CurrentPlayer.Chip)
		g.CurrentPlayer.BoardStates = append(g.CurrentPlayer.BoardStates, g.Board.ToState())

		if g.CurrentPlayer == g.PlayerRed {
			g.CurrentPlayer = g.PlayerYellow
		} else {
			g.CurrentPlayer = g.PlayerRed
		}
	}
}
