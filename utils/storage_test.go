package utils_test

import (
	"testing"

	"github.com/ewoutquax/connect-4/utils"
	"github.com/stretchr/testify/assert"
)

// "github.com/stretchr/testify/assert"

const redisKey string = "test-state"

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
