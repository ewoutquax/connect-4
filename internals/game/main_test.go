package game

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestMain(m *testing.M) {
	os.Setenv("GOENV", "TEST")
	exitCode := m.Run()
	os.Exit(exitCode)
}

func TestPlayWithTwoHumanPlayers(t *testing.T) {
	// game := game.Build{}
	assert := assert.New(t)
	assert.True(false)
}
