SHELL=bash

all: clean fmt test install fixture integration

clean:
	rm -rf mocks

fmt:
	go fmt `go list ./... | grep -v vendor`
	#go fmt $(glide novendor)

test:
	#go test $(glide novendor)
	#go test `go list ./... | grep -v /vendor/`
	go test ./...

fixture:
	mockery -print -dir mockery/fixtures -name RequesterVariadic > mockery/fixtures/mocks/requester_variadic.go

install:
	#go install $(glide novendor)
	go install `go list ./... | grep -v /vendor/`

integration:
	rm -rf mocks
	${GOPATH}/bin/mockery -all -recursive -cpuprofile="mockery.prof" -dir="mockery/fixtures"
	@if [ ! -d "mocks" ]; then \
		echo "No Mock Dir Created"; \
		exit 1; \
	fi
	@if [ ! -f "mocks/AsyncProducer.go" ]; then \
		echo "AsyncProducer.go not created"; \
		echo 1; \
	fi