package player

import (
	"github.com/ewoutquax/connect-4/internals/board"
	"github.com/ewoutquax/connect-4/internals/utils"
)

func New(pk PlayerKind, c board.Chip, readers ...utils.StdinReader) (p Player) {
	p.Kind = pk
	p.Chip = c

	if len(readers) > 0 {
		p.Reader = readers[0]
	} else {
		if p.Kind == PlayerKindHuman {
			p.Reader = utils.StdinReaderDefault{}
		}

		if p.Kind == PlayerKindAI {
			p.Reader = utils.StdinReaderNone{}
		}
	}

	return
}
