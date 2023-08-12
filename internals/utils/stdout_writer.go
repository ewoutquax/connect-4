package utils

import "fmt"

type StdoutWriter interface {
	StdoutWriterExec(string)
}

type StdoutWriterDefault struct{}

func (r StdoutWriterDefault) StdoutWriterExec(m string) {
	fmt.Println(m)
}
