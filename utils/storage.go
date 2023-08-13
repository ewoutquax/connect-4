package utils

import (
	"context"
	"encoding/json"
	"os"
	"sync"

	"github.com/ewoutquax/connect-4/pkg/envvars"
	redis "github.com/redis/go-redis/v9"
)

type StateScore struct {
	Count int     `json:"count"` // Number of times this state has been given a score. Needed to calculate the average score
	Score float64 `json:"score"` // Total score by a state
}

const EnvVarRedisConn string = "REDIS_CONN"
const RedisHashKey string = "connect-4"

var (
	ctx  = context.Background()
	conn *redis.Client
	once sync.Once
)

func GetState(state string) (stateScore StateScore) {
	val, err := rdb().HGet(ctx, RedisHashKey, state).Result()

	if err != nil {
		if err.Error() == "redis: nil" {
			stateScore = StateScore{
				Count: 0,
				Score: 0.5,
			}
		} else {
			panic(err)
		}
	} else {
		json.Unmarshal([]byte(val), &stateScore)
	}

	return
}

func SetState(state string, stateScore StateScore) {
	writeable, err := json.Marshal(stateScore)
	if err != nil {
		panic(err)
	}

	rdb().HSet(ctx, RedisHashKey, state, writeable)
}

func ClearRedis() {
	rdb().Do(ctx, "FLUSHDB")
}

func rdb() *redis.Client {
	once.Do(func() {
		buildRedisConnection()
	})

	return conn
}

func buildRedisConnection() {
	envvars.LoadEnvVars()

	opt, err := redis.ParseURL(os.Getenv(EnvVarRedisConn))
	if err != nil {
		panic(err)
	}

	conn = redis.NewClient(opt)
}
