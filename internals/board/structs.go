package board

type Chip uint8

const (
	None   Chip = iota // Indicates an empty space on the board
	Red                // Indicates the space holds a red chip
	Yellow             // Indicates the space holds a yellow chip
)

const (
	MaxBoardLines   int = 7 // Number of lines on the board (y-axis)
	MaxBoardRows    int = 6 // Number of rows on the board (x-axis)
	StateBaseNumber int = 3
)

type State string // A JSON-string representation of the state of the board

// Definition of the board:
// The board has 7 lines, each line is 6 rows high.
// The state is a 3-digit number system, counting each line from bottom to top, from left to right
//
//	Rows
//	|
//	V
//
//	5 |
//	4 |
//	3 |
//	2 |
//	1 |
//	0 |
//	  +---------------
//	    6 5 4 3 2 1 0 <- Lines
//
// A red chip in the lowest column will get the state value: 1 * 3 ^ 0 = 1
// A yellow chip in the highest column will get the state value: 2 * 3 ^ 5 = 486
type Board struct {
	Line map[int][]Chip // A line is a list of 6 rows, each holding a chip
}
