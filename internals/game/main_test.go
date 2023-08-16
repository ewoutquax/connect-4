package game

import (
	"os"
	"testing"

	"github.com/ewoutquax/connect-4/utils"
	"github.com/stretchr/testify/assert"
)

func TestMain(m *testing.M) {
	os.Setenv("GOENV", "TEST")
	utils.ClearRedis()
	exitCode := m.Run()
	utils.ClearRedis()
	os.Exit(exitCode)
}

func TestPlayWithTwoHumanPlayers(t *testing.T) {
	// game := game.Build{}
	assert := assert.New(t)
	assert.True(false)
}
