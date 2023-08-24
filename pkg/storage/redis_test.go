package storage_test

import (
	"os"
	"testing"

	"github.com/ewoutquax/connect-4/pkg/storage"
	"github.com/stretchr/testify/assert"
)

// "github.com/stretchr/testify/assert"

const redisKey string = "test-state"
const redisKeyUnknown string = "unknown-state"

func TestMain(m *testing.M) {
	os.Setenv("GOENV", "TEST")
	storage.ClearRedis()
	exitCode := m.Run()
	storage.ClearRedis()
	os.Exit(exitCode)
}

func TestWriteValue(t *testing.T) {
	stateScore := storage.StateScore{
		Count: 7,
		Score: 0.85,
	}

	storage.SetState(redisKey, stateScore)
	isFound, result := storage.GetState(redisKey)

	assert := assert.New(t)
	assert.True(isFound)
	assert.Equal(7, result.Count)
	assert.Equal(0.85, result.Score)
}

func TestReadUnknownValue(t *testing.T) {
	isFound, result := storage.GetState(redisKeyUnknown)

	assert := assert.New(t)
	assert.False(isFound)
	assert.Equal(1, result.Count)
	assert.Equal(0.5, result.Score)
}
