@echo off
title SuperClaude V2 - Enhanced Claude Code Launcher
chcp 65001 >nul 2>&1

echo.
echo ╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                       🚀 SUPERCLAUDE V2 LAUNCHER 🚀                          ║
echo ║                     Enhanced Claude Code Experience                           ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝
echo.

echo 🔍 Checking SuperClaude V2 installation...

REM Check if SuperClaude is installed
if not exist "%USERPROFILE%\.claude\CLAUDE.md" (
    echo ❌ SuperClaude V2 not found!
    echo.
    echo 📋 TO INSTALL SUPERCLAUDE V2:
    echo    1. Run: .\02-installers\MASTER-INSTALLER.bat
    echo    2. Make sure to run as Administrator
    echo.
    pause
    exit /b 1
)

echo ✅ SuperClaude V2 installation detected
echo.

REM Check Claude Code installation
echo 🔍 Checking Claude Code installation...
claude-code --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Claude Code not found!
    echo.
    echo 📋 TO INSTALL CLAUDE CODE:
    echo    npm install -g @anthropic-ai/claude-code
    echo.
    pause
    exit /b 1
)

echo ✅ Claude Code installation detected
echo.

REM Check for git wrapper
if exist "C:\claude\tools\git-ultimate-wrapper.bat" (
    echo ✅ Git integration wrapper available
    set "GIT_WRAPPER=C:\claude\tools\git-ultimate-wrapper.bat"
) else (
    echo ⚠️  Git wrapper not found - using system git
)

REM Set enhanced environment
echo 🔧 Setting up enhanced environment...
set "SUPERCLAUDE_VERSION=2.0"
set "SUPERCLAUDE_ENHANCED=true"
set "CLAUDE_PERSONAS_ENABLED=true"
set "CLAUDE_COMMANDS_ENABLED=true"
set "CLAUDE_MCP_ENABLED=true"

REM Check MCP configuration
if exist "%APPDATA%\Claude\claude_desktop_config.json" (
    echo ✅ MCP configuration found
) else (
    echo ⚠️  MCP configuration not found
    echo    📖 See: C:\claude\documentation\MCP-SETUP-GUIDE.md
)

echo.
echo 🎯 LAUNCHING ENHANCED CLAUDE CODE...
echo.
echo 🎭 Available AI Personas:
echo    @frontend, @backend, @security, @architect, @analyzer
echo    @qa, @performance, @devops, @refactorer, @mentor, @scribe
echo.
echo 🛠️  Available Power Commands:
echo    /analyze, /build, /improve, /troubleshoot, /test, /document
echo    /design, /deploy, /task, /git, /scan, /estimate, /migrate
echo    /review, /cleanup
echo.
echo 🌐 MCP Server Integrations:
echo    shadcn-ui, playwright, memory, github, weather
echo.
echo 💡 QUICK EXAMPLES TO TRY:
echo    • @frontend "Create a login form with shadcn/ui"
echo    • /analyze components/ --comprehensive
echo    • /troubleshoot "Windows git authentication issues"
echo.

REM Launch Claude Code with enhanced environment
echo 🚀 Starting Claude Code with SuperClaude V2 enhancements...
echo.

claude-code

REM Post-execution cleanup
echo.
echo ═══════════════════════════════════════════════════════════════════════════════
echo 🎉 Thanks for using SuperClaude V2!
echo.
echo 📚 RESOURCES:
echo    • Documentation: C:\claude\documentation\
echo    • Tools: C:\claude\tools\
echo    • Quick Reference: 01-quick-start\PRINTABLE-REFERENCE.md
echo.
echo 🆘 SUPPORT:
echo    • Issues: https://github.com/aaronvstory/SuperClaudeV2/issues
echo    • Discussions: https://github.com/aaronvstory/SuperClaudeV2/discussions
echo.
pause
