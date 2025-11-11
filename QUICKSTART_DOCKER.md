# Quick Start - Docker Edition

Get Polymarket MCP Server running in **60 seconds** with Docker - no Python installation required!

## Prerequisites

Only **Docker Desktop** is required:

- **macOS**: [Download Docker Desktop](https://www.docker.com/products/docker-desktop)
- **Windows**: [Download Docker Desktop](https://www.docker.com/products/docker-desktop)
- **Linux**: `curl -fsSL https://get.docker.com | sh`

## 3-Step Quick Start

### Step 1: Get Your Wallet Credentials

You need a Polygon wallet. If you don't have one:

1. Install [MetaMask](https://metamask.io/)
2. Add Polygon network
3. Export your private key: Settings > Security > Export Private Key
4. Copy your wallet address (0x...)

### Step 2: Configure Environment

```bash
# Copy the template
cp .env.example .env

# Edit .env with your credentials
# Required:
POLYGON_PRIVATE_KEY=0x1234...  # Your private key
POLYGON_ADDRESS=0xABCD...      # Your wallet address
```

### Step 3: Start Server

**Option A: Automated (Recommended)**
```bash
./docker-start.sh
```

**Option B: Manual**
```bash
docker compose up -d
docker compose logs -f
```

**That's it!** Your Polymarket MCP Server is now running.

## Verify It's Working

```bash
# Check status
docker compose ps

# View logs
docker compose logs polymarket-mcp

# Check health
docker inspect --format='{{.State.Health.Status}}' polymarket-mcp
```

## Common Commands

```bash
# View real-time logs
docker compose logs -f

# Restart server
docker compose restart

# Stop server
docker compose down

# Update and restart
git pull && docker compose up -d --build

# View resource usage
docker stats polymarket-mcp
```

## Using Make (Optional)

If you have `make` installed:

```bash
make help          # Show all commands
make start         # Start with checks
make logs          # View logs
make restart       # Restart
make test          # Run tests
make clean         # Clean up
```

## Integration with Claude Desktop

Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "polymarket-trading": {
      "command": "docker",
      "args": [
        "compose",
        "-f",
        "/Users/YOUR-USERNAME/polymarket-mcp/docker-compose.yml",
        "run",
        "--rm",
        "polymarket-mcp"
      ]
    }
  }
}
```

Replace `/Users/YOUR-USERNAME/` with your actual path.

## Troubleshooting

### "Permission Denied"
```bash
chmod +x docker-start.sh
```

### "Docker daemon not running"
- Start Docker Desktop application

### ".env not found"
```bash
cp .env.example .env
# Edit .env with your credentials
```

### "Container won't start"
```bash
# Check logs for errors
docker compose logs polymarket-mcp

# Verify environment
docker compose config
```

### "Out of memory"
- Increase Docker Desktop memory: Settings > Resources > Memory

## What's Running?

When you run `docker compose up`:

1. **Container**: polymarket-mcp
2. **Volumes**:
   - `./logs` - Application logs
   - `polymarket-data` - Persistent data
3. **Health Checks**: Every 30 seconds
4. **Auto-restart**: If container crashes
5. **Resource Limits**: 512MB RAM, 1 CPU core

## Advanced Usage

### Custom Configuration

Edit `.env` to customize:

```bash
# Safety limits
MAX_ORDER_SIZE_USD=1000
MAX_TOTAL_EXPOSURE_USD=10000

# Logging
LOG_LEVEL=DEBUG  # More verbose logs

# Demo mode (test without real money)
DEMO_MODE=true
```

### Access Container Shell

```bash
docker compose exec polymarket-mcp /bin/bash
```

### View Container Details

```bash
docker inspect polymarket-mcp
```

### Backup Data

```bash
make backup  # If using Make
# Or manually:
docker run --rm -v polymarket-mcp_polymarket-data:/data -v $(PWD)/backups:/backup alpine tar czf /backup/backup.tar.gz -C /data .
```

### Multi-Architecture Build

Build for both Intel and ARM:

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t polymarket-mcp:latest .
```

## Production Deployment

For production, see:

- **Docker**: [DOCKER.md](DOCKER.md) - Complete Docker guide
- **Kubernetes**: [k8s/README.md](k8s/README.md) - K8s deployment
- **CI/CD**: `.github/workflows/docker-publish.yml` - Automated builds

## What's Different from Python Install?

| Feature | Docker | Python Install |
|---------|--------|----------------|
| Python required | ❌ No | ✅ Yes (3.10+) |
| Dependencies | ❌ No (in image) | ✅ Yes (pip install) |
| Virtual env | ❌ No | ✅ Recommended |
| Isolated | ✅ Yes | ❌ No |
| Portable | ✅ Yes | ❌ Platform-specific |
| Updates | `docker compose pull` | `pip install -U` |
| Size | ~150-200MB | ~50-100MB |
| Startup time | ~2-3s | ~1s |

## Next Steps

1. **Test the server**: Run `make test` or `./test-docker.sh`
2. **Read the docs**: See [DOCKER.md](DOCKER.md) for complete guide
3. **Deploy to production**: Check [k8s/README.md](k8s/README.md)
4. **Set up CI/CD**: Configure GitHub Actions secrets

## Getting Help

- **Quick issues**: Check [DOCKER.md](DOCKER.md) troubleshooting
- **Detailed guide**: Read full [README.md](README.md)
- **Kubernetes**: See [k8s/README.md](k8s/README.md)
- **GitHub Issues**: Report bugs and get support

---

**That's it!** You're now running Polymarket MCP Server with Docker.

**Total time**: ~60 seconds
**Total steps**: 3 (credentials, configure, start)
**Total dependencies**: 1 (Docker)

Happy trading!
