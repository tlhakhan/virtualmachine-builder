# Makefile for building CoreDNS
GITCOMMIT:=$(shell git describe --dirty --always)
BUILD_DATE:=$(shell date '+%Y%m%d-%H%M%S')
BINARY:=builder
BUILDOPTS:=-v
CGO_ENABLED?=0

.PHONY: all
all: build

.PHONY: clean
clean:
	rm -f builder

.PHONY: gofmt
gofmt:
	find . -name '*.go' | xargs -n1 -t go fmt

.PHONY: build
build:
	CGO_ENABLED=$(CGO_ENABLED) $(SYSTEM) go build $(BUILDOPTS) -ldflags="-s -w -X main.buildDate=$(BUILD_DATE) -X main.gitCommit=$(GITCOMMIT)" -o $(BINARY) builder.go
