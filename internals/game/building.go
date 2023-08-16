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

func defaultGame() *Game {
	red := player.New(
		player.WithKind(player.PlayerKindHuman),
		player.WithChip(board.Red),
	)
	yellow := player.New(
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
}
