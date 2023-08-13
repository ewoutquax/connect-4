package utils_test

import (
	"os"
	"testing"

	"github.com/ewoutquax/connect-4/utils"
	"github.com/stretchr/testify/assert"
)

// "github.com/stretchr/testify/assert"

const redisKey string = "test-state"
const redisKeyUnknown string = "unknown-state"

func TestMain(m *testing.M) {
	os.Setenv("GOENV", "TEST")
	utils.ClearRedis()
	exitCode := m.Run()
	utils.ClearRedis()
	os.Exit(exitCode)
}

func TestWriteValue(t *testing.T) {
	stateScore := utils.StateScore{
		Count: 7,
		Score: 0.85,
	}

	utils.SetState(redisKey, stateScore)
	result := utils.GetState(redisKey)

	assert.Equal(t, 7, result.Count)
	assert.Equal(t, 0.85, result.Score)
}

func TestReadUnknownValue(t *testing.T) {
	result := utils.GetState(redisKeyUnknown)

	assert.Equal(t, 0, result.Count)
	assert.Equal(t, 0.5, result.Score)
}
