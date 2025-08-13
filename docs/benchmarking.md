# Benchmarking Guide

This document provides detailed information about the gRPC-zig benchmarking system.

## Overview

The gRPC-zig benchmarking tool provides comprehensive performance measurements for the gRPC implementation, including:

- **Latency Metrics**: Min, max, average, P95, and P99 latency measurements
- **Throughput Metrics**: Requests per second under various load conditions
- **Error Metrics**: Success and failure rates
- **Scalability Testing**: Concurrent client simulation

## Quick Start

### Local Testing

1. **Build the project**:
   ```bash
   zig build
   ```

2. **Run benchmarks with default settings**:
   ```bash
   ./scripts/run_benchmark.sh
   ```

3. **Run benchmarks with custom parameters**:
   ```bash
   ./zig-out/bin/grpc-benchmark --requests 1000 --clients 10 --output json
   ```

### Command Line Options

| Option | Description | Default |
|--------|-------------|---------|
| `--host` | Server hostname or IP | `localhost` |
| `--port` | Server port | `50051` |
| `--requests` | Number of requests per client | `1000` |
| `--clients` | Number of concurrent clients | `10` |
| `--size` | Request payload size in bytes | `1024` |
| `--output` | Output format (`text` or `json`) | `text` |
| `--help` | Show help message | - |

### Example Usage

```bash
# Basic benchmark
./zig-out/bin/grpc-benchmark

# High-load benchmark
./zig-out/bin/grpc-benchmark --requests 5000 --clients 50 --size 2048

# JSON output for analysis
./zig-out/bin/grpc-benchmark --output json > results.json
```

## Continuous Integration

The benchmark tool is integrated into the CI/CD pipeline and runs automatically on:

- **Pull Requests**: Benchmark results are posted as PR comments
- **Main Branch Pushes**: Results are stored as artifacts for tracking
- **Performance Regression Detection**: Automatic alerts for performance degradation

### CI Configuration

The benchmark runs with reduced load in CI to ensure fast feedback:

- **Requests per client**: 100
- **Concurrent clients**: 5
- **Payload size**: 512 bytes
- **Timeout**: 60 seconds

### Performance Thresholds

The CI system checks for performance regressions using these thresholds:

- **Minimum Throughput**: 1000 requests/second
- **Maximum P95 Latency**: 100ms
- **Maximum Error Rate**: 5%

## Benchmark Output

### Text Format

```
Benchmark Results:
==================
Total Requests: 1000
Successful: 995
Failed: 5
Error Rate: 0.50%
Total Duration: 2543.21ms
Requests/sec: 391.24
Latency Stats:
  Min: 1.23ms
  Max: 45.67ms
  Avg: 12.34ms
  P95: 23.45ms
  P99: 34.56ms
```

### JSON Format

```json
{
  "total_requests": 1000,
  "successful_requests": 995,
  "failed_requests": 5,
  "total_duration_ms": 2543.21,
  "requests_per_second": 391.24,
  "latency_stats": {
    "min_ms": 1.23,
    "max_ms": 45.67,
    "avg_ms": 12.34,
    "p95_ms": 23.45,
    "p99_ms": 34.56
  },
  "error_rate": 0.005,
  "timestamp": 1640995200
}
```

## Performance Optimization Tips

1. **Payload Size**: Larger payloads generally reduce throughput but may better simulate real-world usage
2. **Concurrency**: Optimal client count depends on server resources and network conditions
3. **Warmup**: The tool includes automatic warmup requests to ensure stable measurements
4. **Environment**: Run benchmarks in consistent environments for reliable comparisons

## Interpreting Results

### Latency Metrics

- **Average Latency**: Overall response time performance
- **P95 Latency**: 95% of requests complete within this time
- **P99 Latency**: 99% of requests complete within this time (captures outliers)

### Throughput Metrics

- **Requests/Second**: Total system throughput under the given load
- **Consider both successful and failed requests when analyzing throughput**

### Error Metrics

- **Error Rate**: Percentage of failed requests
- **Low error rates (< 1%) are expected under normal conditions**
- **High error rates may indicate server overload or network issues**

## Troubleshooting

### Common Issues

1. **Connection Refused**: Ensure the gRPC server is running on the specified host/port
2. **High Error Rates**: Check server logs for errors, consider reducing load
3. **Inconsistent Results**: Ensure stable network conditions and sufficient server resources

### Debug Mode

For debugging benchmark issues, run with verbose logging:

```bash
# Enable Zig debug logging
./zig-out/bin/grpc-benchmark --requests 10 --clients 1
```

## Contributing

To add new benchmark scenarios or metrics:

1. Modify `src/benchmark.zig` to add new measurement capabilities
2. Update this documentation
3. Ensure CI thresholds remain appropriate
4. Test with various load patterns

## Related Files

- `src/benchmark.zig` - Main benchmark implementation
- `scripts/run_benchmark.sh` - Local testing script
- `.github/workflows/ci.yml` - CI/CD configuration
- `examples/basic_server.zig` - Test server with benchmark handler