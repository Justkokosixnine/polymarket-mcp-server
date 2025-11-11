# Testing Quick Reference

Quick commands for testing the Polymarket MCP Server.

## Quick Start

```bash
# Install dependencies
pip install -e ".[dev]"

# Run smoke test (10 seconds)
python smoke_test.py

# Run all tests
pytest tests/

# Run with coverage
pytest tests/ --cov=src/polymarket_mcp --cov-report=html
```

## Common Commands

```bash
# Fast tests only (excludes slow/integration)
pytest tests/ -m "not slow and not integration"

# Integration tests only
pytest tests/ -m integration

# Parallel execution
pytest tests/ -n auto

# Stop on first failure
pytest tests/ -x

# Verbose output
pytest tests/ -v -s

# Specific test file
pytest tests/test_integration.py

# Specific test function
pytest tests/test_integration.py::test_api_connectivity
```

## Test Markers

```bash
# Filter by marker
pytest -m integration      # Only integration tests
pytest -m slow            # Only slow tests
pytest -m real_api        # Only real API tests
pytest -m performance     # Only performance tests

# Combine markers
pytest -m "integration and not slow"
pytest -m "not slow and not real_api"
```

## Coverage

```bash
# Generate HTML report
pytest tests/ --cov=src/polymarket_mcp --cov-report=html
open htmlcov/index.html

# Terminal report
pytest tests/ --cov=src/polymarket_mcp --cov-report=term-missing

# XML for CI
pytest tests/ --cov=src/polymarket_mcp --cov-report=xml

# Fail if below 80%
pytest tests/ --cov=src/polymarket_mcp --cov-fail-under=80
```

## Performance

```bash
# Run benchmarks
pytest tests/test_performance.py --benchmark-only

# Save results
pytest tests/test_performance.py --benchmark-json=results.json

# Compare with baseline
pytest tests/test_performance.py --benchmark-compare=baseline.json
```

## Pre-commit

```bash
# Install hooks
pip install pre-commit
pre-commit install

# Run manually
pre-commit run --all-files

# Skip for quick commit
SKIP=pytest-fast git commit -m "message"
```

## Environment Variables

```bash
# Required for tests
export POLYGON_PRIVATE_KEY="0000...0001"
export POLYGON_ADDRESS="0x0000...0001"

# Optional
export POLYMARKET_CHAIN_ID="137"
export POLYMARKET_DEMO_MODE="true"
```

## CI/CD

```bash
# Trigger tests (automatic)
git push origin branch-name

# Trigger release
git tag v1.0.0
git push origin v1.0.0
```

## Debugging

```bash
# Show all output
pytest tests/ -v -s

# Drop into debugger on failure
pytest tests/ --pdb

# Show locals on failure
pytest tests/ -l

# Trace execution
pytest tests/ --trace
```

## Test Categories

- **Smoke**: Quick validation (8 tests, 10s)
- **Unit**: Fast isolated tests
- **Integration**: Real API tests (20 tests)
- **E2E**: Complete workflows (18 tests)
- **Performance**: Benchmarks (15 tests)

## Quality Gates

- Minimum coverage: 80%
- All tests must pass
- No security issues
- Code formatted (black)
- Linting passed (ruff)
- Type checking passed (mypy)

## Documentation

See TESTING.md for comprehensive guide.
