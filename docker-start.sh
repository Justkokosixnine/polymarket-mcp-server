#!/bin/bash
# Polymarket MCP Server - Docker Start Script
# Easy startup with environment validation and monitoring

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print banner
echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════╗
║                                                   ║
║          Polymarket MCP Server - Docker          ║
║                                                   ║
╚═══════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed!"
    print_info "Install from: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is available
if ! docker compose version &> /dev/null; then
    print_error "Docker Compose is not available!"
    print_info "Install from: https://docs.docker.com/compose/install/"
    exit 1
fi

print_success "Docker and Docker Compose are installed"

# Check if .env file exists
if [ ! -f .env ]; then
    print_warning ".env file not found! Creating from template..."

    if [ -f .env.example ]; then
        cp .env.example .env
        print_info "Created .env from .env.example"
    else
        # Create minimal .env
        cat > .env << EOF
# Polymarket MCP Server Configuration

# Required: Your Polygon wallet credentials
POLYGON_PRIVATE_KEY=your_private_key_here
POLYGON_ADDRESS=your_wallet_address_here

# Optional: Polymarket API credentials (if you have them)
POLYMARKET_API_KEY=
POLYMARKET_PASSPHRASE=

# Operating mode
DEMO_MODE=false

# Configuration
LOG_LEVEL=INFO
POLYMARKET_CHAIN_ID=137

# Safety limits
MAX_ORDER_SIZE_USD=1000
MAX_TOTAL_EXPOSURE_USD=10000
REQUIRE_CONFIRMATION_ABOVE_USD=100
EOF
        print_info "Created default .env file"
    fi

    print_warning "Please edit .env with your credentials before continuing!"
    print_info "Open .env in your text editor and add your POLYGON_PRIVATE_KEY and POLYGON_ADDRESS"
    read -p "Press Enter when ready to continue..."
fi

# Validate environment variables
print_info "Validating environment configuration..."

source .env

if [ -z "$POLYGON_PRIVATE_KEY" ] || [ "$POLYGON_PRIVATE_KEY" = "your_private_key_here" ]; then
    print_error "POLYGON_PRIVATE_KEY not set in .env!"
    print_info "Get your private key from your Polygon wallet"
    exit 1
fi

if [ -z "$POLYGON_ADDRESS" ] || [ "$POLYGON_ADDRESS" = "your_wallet_address_here" ]; then
    print_error "POLYGON_ADDRESS not set in .env!"
    print_info "Get your wallet address from your Polygon wallet"
    exit 1
fi

print_success "Environment configuration validated"

# Build Docker image
print_info "Building Docker image..."
docker compose build

print_success "Docker image built successfully"

# Start services
print_info "Starting Polymarket MCP Server..."
docker compose up -d

# Wait for container to be healthy
print_info "Waiting for server to start..."
sleep 3

# Check container status
if docker compose ps | grep -q "Up"; then
    print_success "Polymarket MCP Server is running!"

    # Show container info
    echo ""
    print_info "Container Status:"
    docker compose ps

    echo ""
    print_info "To view logs in real-time:"
    echo "  docker compose logs -f"

    echo ""
    print_info "To stop the server:"
    echo "  docker compose down"

    echo ""
    print_info "To restart the server:"
    echo "  docker compose restart"

    # Show recent logs
    echo ""
    print_info "Recent logs:"
    docker compose logs --tail=20

else
    print_error "Failed to start server!"
    print_info "Showing logs..."
    docker compose logs
    exit 1
fi

echo ""
print_success "Setup complete! Your Polymarket MCP Server is ready."
