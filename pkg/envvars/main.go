package envvars

import (
	"os"
	"path/filepath"
	"strings"

	"github.com/ewoutquax/connect-4/pkg/rootdir"
	"github.com/joho/godotenv"
)

const defaultEnv string = "DEV"

func LoadEnvVars() {
	env := os.Getenv("GOENV")
	if env == "" {
		env = defaultEnv
	}

	baseDir := rootdir.Get()

	envFile, _ := filepath.Abs(baseDir + "/.env." + strings.ToLower(env))

	godotenv.Load(envFile)
}
