package rootdir

import (
	"fmt"
	"path/filepath"
	"runtime"
)

var (
	_, b, _, _ = runtime.Caller(0)
	basepath   = filepath.Dir(b)
)

func Get() string {
	relativeRoot := fmt.Sprintf("%s/%s", basepath, "../..")
	rootDir, _ := filepath.Abs(relativeRoot)

	return rootDir
}
