package storage

import (
	"context"
	"encoding/json"
	"os"

	redis "github.com/redis/go-redis/v9"
)

type StateScore struct {
	Count int     `json:"count"` // Number of times this state has been given a score. Needed to calculate the average score
	Score float64 `json:"score"` // Total score by a state
}

const EnvVarRedisConn string = "REDIS_CONN"
const RedisHashKey string = "connect-4"

var (
	ctx = context.Background()
	rdb *redis.Client
)

func GetState(state string) (isFound bool, stateScore StateScore) {
	val, err := rdb.HGet(ctx, RedisHashKey, state).Result()
	isFound = false

	if err != nil {
		if err.Error() == "redis: nil" {
			stateScore = StateScore{
				Count: 1,
				Score: 0.5,
			}
		} else {
			panic(err)
		}
	} else {
		json.Unmarshal([]byte(val), &stateScore)
		isFound = true
	}

	return
}

func SetState(state string, stateScore StateScore) {
	writeable, err := json.Marshal(stateScore)
	if err != nil {
		panic(err)
	}

	rdb.HSet(ctx, RedisHashKey, state, writeable)
}

func ClearRedis() {
	rdb.Do(ctx, "FLUSHDB")
}

func GetAll() map[string]StateScore {
	val, err := rdb.HGetAll(ctx, RedisHashKey).Result()

	if err != nil {
		panic(err)
	}

	var out = make(map[string]StateScore)

	for state, value := range val {
		stateScore := StateScore{}
		json.Unmarshal([]byte(value), &stateScore)
		out[state] = stateScore
	}

	return out
}

func BuildRedisConnection() {
	opt, err := redis.ParseURL(os.Getenv(EnvVarRedisConn))
	if err != nil {
		panic(err)
	}

	rdb = redis.NewClient(opt)
}
