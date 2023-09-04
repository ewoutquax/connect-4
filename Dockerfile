## Build
FROM golang:1.21.0-alpine3.17 AS builder

WORKDIR /opt/app

COPY ./cmd ./cmd
COPY ./internals ./internals
COPY ./pkg ./pkg
COPY ./utils ./utils
COPY ./go.mod ./
COPY ./go.sum ./

RUN go build -o /tmp/connect-4 cmd/play/main.go


FROM alpine:3.17

WORKDIR /opt/app

COPY --from=builder /tmp/connect-4 .
COPY ./.env.prod ./

CMD ["sh", "-c", "./connect-4"]
