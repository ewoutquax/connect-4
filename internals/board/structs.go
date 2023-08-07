package board

type Chip uint8

const (
	None Chip = iota
	Red
	Green
)

// Definition of the board:
// The board has 7 rows, each row is 6 lines high.
// The state is a 3-digit number system, counting from right to left, starting with 0
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
// A red chip in the rightmost column will get the state value: 1 * 3 ^ 0 = 1
// A yellow chip in the left column will get the state value: 2 * 3 ^ 6 = 1458
type Board struct {
	Line map[int][]Chip
}
