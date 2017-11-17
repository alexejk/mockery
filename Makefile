SHELL=bash

all: clean dependencies fmt test install fixture integration

clean:
	rm -rf mocks

fmt:
	go fmt `go list ./... | grep -v vendor`

dependencies:
	dep ensure
	dep status

test:
	#go test `go list ./... | grep -v vendor`
	GO15VENDOREXPERIMENT=1 go test `go list ./... | grep -v vendor`

fixture:
	mockery -print -dir mockery/fixtures -name RequesterVariadic > mockery/fixtures/mocks/requester_variadic.go

install:
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