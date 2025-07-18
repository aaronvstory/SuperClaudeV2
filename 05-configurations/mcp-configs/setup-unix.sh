#!/bin/bash

# Claude MCP Configuration Setup for macOS/Linux
echo "🔧 Claude MCP Configuration Setup"
echo "Setting up required directories and dependencies..."

# Create base directories
mkdir -p "$HOME/CLAUDE"
mkdir -p "$HOME/Scripts"
mkdir -p "$HOME/Projects"

echo "✅ Base directories created"

# Check Node.js installation
if command -v node &> /dev/null; then
    echo "✅ Node.js is installed ($(node --version))"
else
    echo "❌ Node.js is not installed"
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
fi

# Check Python installation
if command -v python3 &> /dev/null; then
    echo "✅ Python is installed ($(python3 --version))"
elif command -v python &> /dev/null; then
    echo "✅ Python is installed ($(python --version))"
else
    echo "❌ Python is not installed"
    echo "Please install Python from https://python.org/"
    exit 1
fi

# Install global MCP servers
echo "📦 Installing MCP servers globally..."
npm install -g @modelcontextprotocol/server-puppeteer
npm install -g @modelcontextprotocol/server-memory
npm install -g @modelcontextprotocol/server-brave-search
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-everything
npm install -g @wonderwhy-er/desktop-commander

echo "✅ MCP servers installed"

# Create Claude config directory
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
else
    # Linux
    CLAUDE_CONFIG_DIR="$HOME/.config/Claude"
fi

mkdir -p "$CLAUDE_CONFIG_DIR"

echo "📁 Configuration directory ready: $CLAUDE_CONFIG_DIR"
echo "📋 Copy claude_desktop_config.json to: $CLAUDE_CONFIG_DIR"
echo "🔑 Remember to replace placeholder API keys with real ones"
echo "✅ Setup completed successfully"
