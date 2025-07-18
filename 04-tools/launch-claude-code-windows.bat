@echo off
title Windows Claude Code Launcher
chcp 65001 >nul 2>&1

echo ========================================
echo    Windows Claude Code Launcher
echo ========================================
echo.

REM Check if Node.js is available
node --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js not found. Please install Node.js from:
    echo         https://nodejs.org/
    pause
    exit /b 1
)

echo [INFO] Starting Windows Claude Code (win-claude-code wrapper)...
echo [INFO] This bypasses WSL and provides native Windows support.
echo.

REM Launch win-claude-code instead of native claude-code
npx win-claude-code@latest

echo.
echo [INFO] Claude Code session ended.
pause
