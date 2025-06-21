#!/bin/bash

# gRPC-zig Local Benchmark Script
# This script helps run benchmarks locally with a test server

set -e

echo "🚀 gRPC-zig Local Benchmark Runner"
echo "=================================="

# Build the project
echo "Building project..."
zig build

# Start server in background
echo "Starting test server..."
./zig-out/bin/grpc-server &
SERVER_PID=$!

# Function to cleanup server on exit
cleanup() {
    echo "Stopping server..."
    kill $SERVER_PID 2>/dev/null || true
    exit
}
trap cleanup EXIT INT TERM

# Wait for server to start
echo "Waiting for server to start..."
sleep 3

# Check if server is running
if ! kill -0 $SERVER_PID 2>/dev/null; then
    echo "❌ Server failed to start"
    exit 1
fi

echo "✅ Server started successfully (PID: $SERVER_PID)"

# Run benchmark with default settings
echo ""
echo "Running benchmark..."
echo "===================="

./zig-out/bin/grpc-benchmark \
    --host localhost \
    --port 50051 \
    --requests 1000 \
    --clients 10 \
    --size 1024 \
    --output text

echo ""
echo "Running benchmark with JSON output..."
echo "===================================="

./zig-out/bin/grpc-benchmark \
    --host localhost \
    --port 50051 \
    --requests 1000 \
    --clients 10 \
    --size 1024 \
    --output json > benchmark_results.json

echo "✅ Benchmark results saved to benchmark_results.json"
echo ""
echo "Benchmark completed successfully!"