# Use a multi-stage build to create a lightweight final image
FROM quay.io/projectquay/golang:1.24 AS builder

WORKDIR /app
COPY . .

# Build for the target platform/arch
ARG TARGETOS
ARG TARGETARCH
RUN --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o kbot ./main.go

# Use a minimal base image for the final stage
FROM quay.io/projectquay/golang:1.24 AS test
WORKDIR /app
COPY --from=builder /app/kbot /app/kbot
COPY . .

RUN go test ./...

CMD ["/app/kbot"]
