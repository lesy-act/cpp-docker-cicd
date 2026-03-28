FROM gcc:13 AS builder

WORKDIR /app
COPY . .

# Cập nhật và cài cmake, sử dụng --no-install-recommends để tránh cài thêm gói không cần thiết
RUN apt-get update && apt-get install -y --no-install-recommends cmake

# Kiểm tra sự tồn tại của CMakeLists.txt
RUN test -f CMakeLists.txt || (echo "CMakeLists.txt not found" && exit 1)

# Cấu hình CMake với đầu ra chi tiết (thêm --verbose nếu cần)
RUN cmake -S . -B build && echo "CMake configuration successful"

# Biên dịch với verbose để xem lỗi chi tiết
RUN cmake --build build --verbose

# Runtime stage
FROM debian:stable-slim

WORKDIR /app
COPY --from=builder /app/build/hello .

CMD ["./hello"]