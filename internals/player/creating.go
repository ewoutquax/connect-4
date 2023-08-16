package player

import (
	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/utils"
)

type PlayerOptsFunc func(*Player)

func defaultPlayer() *Player {
	return &Player{
		Alfa:    0.7,
		Gamma:   0.85,
		epsilon: 0.95,

		Kind: PlayerKindHuman,
		Chip: board.Red,

		Reader: utils.StdinReaderDefault{},
		Writer: utils.StdoutWriterDefault{},

		BoardStates: make([]board.State, 0, board.MaxBoardLines*board.MaxBoardRows/2),
	}
}

func New(optFuncs ...PlayerOptsFunc) *Player {
	p := defaultPlayer()
	for _, fn := range optFuncs {
		fn(p)
	}

	return p
}

func WithKind(kind PlayerKind) PlayerOptsFunc {
	return func(p *Player) {
		p.Kind = kind
		if kind == PlayerKindAI {
			p.Reader = utils.StdinReaderNone{}
		}
	}
}

func WithChip(chip board.Chip) PlayerOptsFunc {
	return func(p *Player) {
		p.Chip = chip
	}
}

func WithReader(reader utils.StdinReader) PlayerOptsFunc {
	return func(p *Player) {
		p.Reader = reader
	}
}
