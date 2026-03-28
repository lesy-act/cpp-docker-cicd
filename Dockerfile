FROM gcc:13 AS builder

WORKDIR /app
COPY . .

RUN apt-get update && apt-get install -y cmake \
    && cmake -S . -B build \
    && cmake --build build

# Runtime stage
FROM debian:stable-slim

WORKDIR /app
COPY --from=builder /app/build/hello .

CMD ["./hello"]