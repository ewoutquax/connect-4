package board

import (
	"fmt"
	"reflect"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestInitBoardToState(t *testing.T) {
	expectedState := "[0,0,0,0,0,0]"
	myBoard := Init()

	assert.Equal(t, expectedState, myBoard.toState())
}

func TestInitBoardFromState(t *testing.T) {
	myBoard := FromState("[81,0,0,0,0,0]")
	kind := fmt.Sprintf("%s", reflect.TypeOf(myBoard))

	assert.Equal(t, "board.Board", kind)
}
