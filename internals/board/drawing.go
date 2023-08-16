package board

import (
	"fmt"
	"strings"
)

const (
	ColorReset  string = "\033[0m"
	ColorRed           = "\033[91m"
	ColorYellow        = "\033[93m"
)

func (b *Board) Draw() {
	var outputCells []string

	for idxRow := MaxBoardRows - 1; idxRow >= 0; idxRow-- {
		outputCells = make([]string, 1, 8)
		outputCells[0] = fmt.Sprintf("%d: ", MaxBoardRows-idxRow)
		for _, line := range b.Line {
			switch line[idxRow] {
			case Red:
				outputCells = append(outputCells, ColorRed+"X")
			case Yellow:
				outputCells = append(outputCells, ColorYellow+"O")
			default:
				outputCells = append(outputCells, " ")
			}
		}

		outputRow := strings.Join(outputCells, ColorReset+"|") + ColorReset + "|"
		fmt.Printf(outputRow + "\n")
	}
	fmt.Println("   ---------------")
	fmt.Println("    1 2 3 4 5 6 7 ")
}
