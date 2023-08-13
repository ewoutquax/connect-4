package envvars

import (
	"os"
	"path/filepath"
	"strings"

	"github.com/joho/godotenv"
)

func LoadEnvVars() {
	env := os.Getenv("GOENV")
	if env == "" {
		env = "DEV"
	}

	envFile, _ := filepath.Abs("../.env." + strings.ToLower(env))

	godotenv.Load(envFile)
}
