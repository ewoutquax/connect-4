package utils

import (
	"io"
	"os"
	"strings"
)

type StdinReader interface {
	StdinReaderExec() string
}

type StdinReaderDefault struct{}
type StdinReaderNone struct{}

func (r StdinReaderDefault) StdinReaderExec() string {
	rawData, _ := io.ReadAll(os.Stdin)
	msg := strings.Trim(string(rawData), "\n")
	return string(msg)
}

func (r StdinReaderNone) StdinReaderExec() string {
	return ""
}
