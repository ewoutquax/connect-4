package board

import (
	"fmt"
	"reflect"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestInitBoardToState(t *testing.T) {
	expectedState := State("[0,0,0,0,0,0,0]")
	myBoard := Init()

	assert.Equal(t, expectedState, myBoard.ToState())
}

func TestInitBoardFromState(t *testing.T) {
	myBoard := FromState("[486,0,0,0,1,0]")
	kind := fmt.Sprintf("%s", reflect.TypeOf(myBoard))

	assert.Equal(t, "board.Board", kind)
	assert.Equal(t, Yellow, myBoard.Line[0][5])
	assert.Equal(t, Red, myBoard.Line[4][0])
}
