# Makefile for cross-platform Go builds and Docker image automation

APP_NAME := kbot
VERSION ?= latest
IMAGE_TAG := ghcr.io/bo3gyx19/$(APP_NAME):$(VERSION)

PLATFORMS := linux/amd64,linux/arm64,darwin/amd64,darwin/arm64,windows/amd64,windows/arm64

.PHONY: all linux arm macos windows image clean

all: linux arm macos windows

linux:
	GOOS=linux GOARCH=amd64 go build -o bin/$(APP_NAME)-linux-amd64 ./main.go
	GOOS=linux GOARCH=arm64 go build -o bin/$(APP_NAME)-linux-arm64 ./main.go

arm:
	GOOS=linux GOARCH=arm64 go build -o bin/$(APP_NAME)-linux-arm64 ./main.go

macos:
	GOOS=darwin GOARCH=amd64 go build -o bin/$(APP_NAME)-darwin-amd64 ./main.go
	GOOS=darwin GOARCH=arm64 go build -o bin/$(APP_NAME)-darwin-arm64 ./main.go

windows:
	GOOS=windows GOARCH=amd64 go build -o bin/$(APP_NAME)-windows-amd64.exe ./main.go
	GOOS=windows GOARCH=arm64 go build -o bin/$(APP_NAME)-windows-arm64.exe ./main.go

image:
	docker buildx build --platform "$(PLATFORMS)" -t $(IMAGE_TAG) --push .

clean:
	rm -rf bin
	docker rmi $(IMAGE_TAG) || true
