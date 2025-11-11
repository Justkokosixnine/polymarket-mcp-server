#!/bin/bash
#
# Polymarket MCP Web Dashboard Launcher
# Quick start script for the web dashboard
#

set -e

echo "=================================="
echo "Polymarket MCP Web Dashboard"
echo "=================================="
echo ""

# Check if virtual environment exists
if [ -d "venv" ]; then
    echo "Activating virtual environment..."
    source venv/bin/activate
else
    echo "WARNING: Virtual environment not found at ./venv"
    echo "Creating virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
fi

# Check if dependencies are installed
if ! python -c "import fastapi" 2>/dev/null; then
    echo "Installing web dashboard dependencies..."
    pip install fastapi uvicorn jinja2
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "ERROR: .env file not found!"
    echo "Please copy .env.example to .env and configure your credentials."
    exit 1
fi

echo "Starting web dashboard..."
echo "URL: http://localhost:8080"
echo ""
echo "Press Ctrl+C to stop"
echo ""

# Start the web dashboard
polymarket-web
