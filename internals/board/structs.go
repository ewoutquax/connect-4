package board

type Chip uint8

const (
	None Chip = iota
	Red
	Yellow
)

// Definition of the board:
// The board has 7 rows, each row is 6 lines high.
// The state is a 3-digit number system, counting each row from bottom to top, from left to right
//
//	5 |
//	4 |
//	3 |
//	2 |
//	1 |
//	0 |
//	  +---------------
//	    6 5 4 3 2 1 0
//
// A red chip in the lowest column will get the state value: 1 * 3 ^ 0 = 1
// A yellow chip in the highest column will get the state value: 2 * 3 ^ 5 = 486
type Board struct {
	Line map[int][]Chip
}
