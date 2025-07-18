@echo off
REM Claude Code Ecosystem Complete Installer
REM This script sets up the exact same Claude Code configuration
REM Version: 1.0.0

title Claude Code Ecosystem Installer
chcp 65001 >nul 2>&1
color 0A

echo.
echo ████████╗██╗  ██╗███████╗    ███████╗██╗   ██╗██████╗ ███████╗██████╗ 
echo ╚══██╔══╝██║  ██║██╔════╝    ██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗
echo    ██║   ███████║█████╗      ███████╗██║   ██║██████╔╝█████╗  ██████╔╝
echo    ██║   ██╔══██║██╔══╝      ╚════██║██║   ██║██╔═══╝ ██╔══╝  ██╔══██╗
echo    ██║   ██║  ██║███████╗    ███████║╚██████╔╝██║     ███████╗██║  ██║
echo    ╚═╝   ╚═╝  ╚═╝╚══════╝    ╚══════╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝
echo.
echo     ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗
echo    ██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝
echo    ██║     ██║     ███████║██║   ██║██║  ██║█████╗  
echo    ██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝  
echo    ╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗
echo     ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝
echo.
echo    ███████╗ ██████╗ ██████╗ ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗
echo    ██╔════╝██╔════╝██╔═══██╗██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║
echo    █████╗  ██║     ██║   ██║███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║
echo    ██╔══╝  ██║     ██║   ██║╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║
echo    ███████╗╚██████╗╚██████╔╝███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║
echo    ╚══════╝ ╚═════╝ ╚═════╝ ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝
echo.
echo ===============================================================================
echo   Complete Claude Code + SuperClaude + Win-Claude-Code Installation
echo ===============================================================================
echo.
echo This installer will set up the EXACT configuration from the reference system:
echo.
echo • win-claude-code (Windows-native Claude Code wrapper)
echo • NomenAK SuperClaude Framework (15 commands + 11 personas)
echo • Gwendall SuperClaude CLI (GitHub workflow automation)
echo • Right-click context menu integration
echo • Permission bypass configuration
echo • 4 MCP servers (Context7, Sequential, Magic, Playwright)
echo • Complete verification and testing tools
echo.
echo ===============================================================================

echo.
echo [PREREQUISITES CHECK]
echo.

REM Check if running as Administrator
net session >nul 2>&1
if errorlevel 1 (
    echo [ERROR] This installer requires Administrator privileges.
    echo Please right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo ✓ Administrator privileges confirmed
echo.

echo [IMPORTANT NOTES]
echo.
echo • This installer will download and install approximately 200MB of software
echo • Internet connection is required for npm packages and GitHub repositories
echo • The installation will take 10-15 minutes depending on your internet speed
echo • All existing Claude Code configurations will be backed up
echo • You can safely run this installer multiple times
echo.

set /p CONFIRM="Do you want to proceed with the installation? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo Installation cancelled by user.
    pause
    exit /b 0
)

echo.
echo ===============================================================================
echo [LAUNCHING POWERSHELL INSTALLER]
echo ===============================================================================
echo.

REM Launch the PowerShell installer with elevated privileges
powershell -ExecutionPolicy Bypass -File "%~dp0setup-claude-ecosystem.ps1"

REM Check if PowerShell installer succeeded
if errorlevel 1 (
    echo.
    echo [ERROR] PowerShell installer encountered an error.
    echo Please check the error messages above and try again.
    echo.
    pause
    exit /b 1
)

echo.
echo ===============================================================================
echo [INSTALLATION COMPLETE]
echo ===============================================================================
echo.
echo 🎉 The Super Claude Ecosystem has been successfully installed!
echo.
echo Next steps:
echo 1. Right-click on any folder
echo 2. Select "Open with Claude Code"
echo 3. Try commands like /analyze, /improve, @architect
echo.
echo For troubleshooting and verification, check:
echo • C:\claude\superclaude-tools\
echo.
pause
