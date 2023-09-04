## Build
FROM golang:1.21.0-alpine3.17

WORKDIR /opt/app

COPY ./cmd ./cmd
COPY ./internals ./internals
COPY ./pkg ./pkg
COPY ./utils ./utils
COPY ./.env.prod ./
COPY ./go.mod ./
COPY ./go.sum ./
COPY ./build.sh ./

RUN mkdir bin
RUN go build -o bin/connect-4 cmd/play/main.go

CMD ["sh", "-c", "./bin/connect-4"]
