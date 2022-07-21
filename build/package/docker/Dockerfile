FROM golang:1.18-alpine AS builder

# Set necessary environmet variables needed for our image
ENV GOOS=linux \
    GOARCH=amd64 \
    GOFLAGS=-buildvcs=false

WORKDIR /build

COPY . .
RUN go mod download
RUN go build -ldflags "-s -w" -o server ./cmd/server

RUN apk add upx
RUN upx --best --lzma /build/server

# Build a small image
FROM alpine:3.16 AS final

LABEL maintainer="nico.rogalski@msg-david.de"
LABEL cng-ca-hello.project="CngHelloBackend"
LABEL cng-ca-hello.version="1.0.0"

COPY --from=builder /build/server /

EXPOSE 8080
ENTRYPOINT ["/server"]