
all: gofmt build

gofmt:
	find ./pkg ./cmd -name "*.go"  | xargs -n1 -t go fmt

build:
	go build -o ./bin/builder ./cmd/builder/main.go
