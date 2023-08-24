package config

import (
	"sync"

	"github.com/ewoutquax/connect-4/pkg/envvars"
	"github.com/ewoutquax/connect-4/pkg/storage"
)

var once sync.Once

func InitializeApp() {
	ConnectToRedis()
}

func ConnectToRedis() {
	onceLoadEnvVars()
	storage.BuildRedisConnection()
}

func onceLoadEnvVars() {
	once.Do(func() {
		envvars.LoadEnvVars()
	})
}
