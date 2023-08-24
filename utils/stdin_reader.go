package utils

import (
	"bufio"
	"os"
	"strings"
)

type StdinReader interface {
	StdinReaderExec() string
}

type StdinReaderDefault struct{}
type StdinReaderNone struct{}

func (r StdinReaderDefault) StdinReaderExec() string {
	reader := bufio.NewReader(os.Stdin)
	msg, err := reader.ReadString('\n')
	if err != nil {
		panic(err)
	}
	return strings.Trim(msg, "\n")
}

func (r StdinReaderNone) StdinReaderExec() string {
	return ""
}
