#! /usr/bin/env bash

mkdir -p bin/
go build -o bin/connect-4 cmd/play/main.go
