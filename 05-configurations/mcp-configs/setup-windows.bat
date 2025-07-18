@echo off
title MCP Configuration Setup
color 0A

REM Check admin privileges
net session >nul 2>&1
if NOT %errorLevel% == 0 (
    echo [ERROR] This script requires Administrator privileges.
    echo Right-click this file and select "Run as Administrator"
    pause
    exit /b 1
)

echo [INFO] Claude MCP Configuration Setup
echo [INFO] Setting up required directories and dependencies...

REM Create base directories
if not exist "C:\CLAUDE" mkdir "C:\CLAUDE" >nul 2>&1
if not exist "C:\Scripts" mkdir "C:\Scripts" >nul 2>&1
if not exist "C:\Projects" mkdir "C:\Projects" >nul 2>&1

echo [OK] Base directories created

REM Check Node.js installation
node --version >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Node.js is installed
) else (
    echo [ERROR] Node.js is not installed
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

REM Check Python installation
python --version >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Python is installed
) else (
    echo [ERROR] Python is not installed
    echo Please install Python from https://python.org/
    pause
    exit /b 1
)

REM Install global MCP servers
echo [INFO] Installing MCP servers globally...
call npm install -g @modelcontextprotocol/server-puppeteer >nul 2>&1
call npm install -g @modelcontextprotocol/server-memory >nul 2>&1
call npm install -g @modelcontextprotocol/server-brave-search >nul 2>&1
call npm install -g @modelcontextprotocol/server-github >nul 2>&1
call npm install -g @modelcontextprotocol/server-filesystem >nul 2>&1
call npm install -g @modelcontextprotocol/server-everything >nul 2>&1
call npm install -g @wonderwhy-er/desktop-commander >nul 2>&1

echo [OK] MCP servers installed

REM Create Claude config directory if it doesn't exist
set "CLAUDE_CONFIG_DIR=%APPDATA%\Claude"
if not exist "%CLAUDE_CONFIG_DIR%" mkdir "%CLAUDE_CONFIG_DIR%" >nul 2>&1

echo [INFO] Configuration directory ready: %CLAUDE_CONFIG_DIR%
echo [INFO] Copy claude_desktop_config.json to: %CLAUDE_CONFIG_DIR%
echo [INFO] Remember to replace placeholder API keys with real ones
echo [OK] Setup completed successfully

pause
