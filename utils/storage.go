package utils

import (
	"context"
	"encoding/json"

	redis "github.com/redis/go-redis/v9"
)

const RedisHashKey string = "connect-4"

type StateScore struct {
	Count int     `json:"count"` // Number of times this state has been given a score. Needed to calculate the average score
	Score float64 `json:"score"` // Total score by a state
}

var (
	rdb = RedisConnection()
	ctx = context.Background()
)

func RedisConnection() *redis.Client {
	return redis.NewClient(&redis.Options{
		Addr:     "localhost:6379",
		Password: "", // no password set
		DB:       9,  // use default DB
	})
}

func GetState(state string) (stateScore StateScore) {
	val, _ := rdb.HGet(ctx, RedisHashKey, state).Result()

	json.Unmarshal([]byte(val), &stateScore)

	return
}

func SetState(state string, stateScore StateScore) {
	var writeable []byte
	var err error
	if writeable, err = json.Marshal(stateScore); err != nil {
		panic(err)
	}

	rdb.HSet(ctx, RedisHashKey, state, writeable)
}
