@echo off
title SuperClaude V2 - MASTER INSTALLER - Complete Enhancement Suite
chcp 65001 >nul 2>&1
color 0A

echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         SUPERCLAUDE V2 MASTER INSTALLER                      ║
echo ║                     The Ultimate Claude Code Enhancement                     ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo 🚀 WHAT YOU'RE INSTALLING:
echo    • 11 AI Personas (Auto-activating specialists)
echo    • 15 Power Commands (Complete development workflows)
echo    • 50+ Tools & Scripts (Windows optimization toolkit)
echo    • 5 MCP Server Integrations (shadcn/ui, Playwright, Memory, etc.)
echo    • Enterprise Security (Professional secret management)
echo    • Comprehensive Documentation (Complete guides & references)
echo.

REM Administrative privileges check
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo ❌ [ERROR] Administrative privileges required!
    echo.
    echo 📋 TO FIX THIS:
    echo    1. Right-click this file ^(MASTER-INSTALLER.bat^)
    echo    2. Select "Run as administrator"
    echo    3. Click "Yes" when prompted
    echo.
    pause
    exit /b 1
)

echo ✅ Administrative privileges confirmed.
echo.

REM Backup existing configuration
echo 🔄 [STEP 1/8] Creating backup of existing configuration...
if not exist "%USERPROFILE%\.claude\backup" mkdir "%USERPROFILE%\.claude\backup" >nul 2>&1
if exist "%USERPROFILE%\.claude\settings.json" (
    copy "%USERPROFILE%\.claude\settings.json" "%USERPROFILE%\.claude\backup\settings_backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.json" >nul 2>&1
    echo ✅ Existing settings backed up
) else (
    echo ℹ️  No existing configuration found
)

REM Create directory structure
echo 🔄 [STEP 2/8] Creating SuperClaude directory structure...
if not exist "%USERPROFILE%\.claude" mkdir "%USERPROFILE%\.claude" >nul 2>&1
if not exist "C:\claude" mkdir "C:\claude" >nul 2>&1
if not exist "C:\claude\tools" mkdir "C:\claude\tools" >nul 2>&1
if not exist "C:\claude\launchers" mkdir "C:\claude\launchers" >nul 2>&1
if not exist "C:\claude\documentation" mkdir "C:\claude\documentation" >nul 2>&1
echo ✅ Directory structure created

REM Install core framework
echo 🔄 [STEP 3/8] Installing SuperClaude core framework...
xcopy "03-framework\SuperClaude\Core\*" "%USERPROFILE%\.claude\" /Y >nul 2>&1
xcopy "03-framework\SuperClaude\Commands\*" "%USERPROFILE%\.claude\commands\" /E /I /Y >nul 2>&1
if errorlevel 1 (
    echo ❌ [ERROR] Core framework installation failed
    pause
    exit /b 1
)
echo ✅ Core framework installed (11 personas + 15 commands)

REM Install configurations
echo 🔄 [STEP 4/8] Installing configuration templates...
xcopy "05-configurations\*.md" "%USERPROFILE%\.claude\" /Y >nul 2>&1
xcopy "05-configurations\*.json" "%USERPROFILE%\.claude\" /Y >nul 2>&1
xcopy "05-configurations\mcp-configs\*" "%USERPROFILE%\.claude\mcp-configs\" /E /I /Y >nul 2>&1
echo ✅ Configuration templates installed

REM Install tools and utilities
echo 🔄 [STEP 5/8] Installing specialized tools and utilities...
xcopy "04-tools\*" "C:\claude\tools\" /E /I /Y >nul 2>&1
if errorlevel 1 (
    echo ❌ [ERROR] Tools installation failed
    pause
    exit /b 1
)
echo ✅ 50+ tools and utilities installed

REM Install documentation
echo 🔄 [STEP 6/8] Installing comprehensive documentation...
xcopy "06-documentation\*" "C:\claude\documentation\" /E /I /Y >nul 2>&1
xcopy "03-framework\Docs\*" "C:\claude\documentation\framework\" /E /I /Y >nul 2>&1
echo ✅ Complete documentation suite installed

REM Setup MCP servers
echo 🔄 [STEP 7/8] Configuring MCP server integrations...
if exist "05-configurations\mcp-configs\claude_desktop_config.json" (
    echo ℹ️  MCP configuration template available at:
    echo    %USERPROFILE%\.claude\mcp-configs\claude_desktop_config.json
    echo ⚠️  Manual MCP setup required - see documentation
) else (
    echo ⚠️  MCP configuration not found - manual setup required
)

REM Create quick launchers
echo 🔄 [STEP 8/8] Creating quick access launchers...
copy "01-quick-start\LAUNCH-SUPERCLAUDE.bat" "C:\claude\launchers\" >nul 2>&1
copy "04-tools\launch-claude-code-windows.bat" "C:\claude\launchers\" >nul 2>&1

REM Verify installation
echo 🔄 Running installation verification...
if exist "C:\claude\tools\verify-installation.bat" (
    call "C:\claude\tools\verify-installation.bat"
) else (
    echo ⚠️  Verification script not found
)

echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         🎉 INSTALLATION COMPLETE! 🎉                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo 🚀 SUPERCLAUDE V2 IS NOW INSTALLED!
echo.
echo 📋 WHAT YOU HAVE NOW:
echo    ✅ 11 AI Personas (Auto-activate with @frontend, @security, etc.)
echo    ✅ 15 Power Commands (Use /analyze, /improve, /troubleshoot, etc.)
echo    ✅ 50+ Specialized Tools (Git fixes, launchers, automation)
echo    ✅ MCP Server Support (shadcn/ui, Playwright, Memory, etc.)
echo    ✅ Complete Documentation (All guides and references)
echo    ✅ Enterprise Security (Safe credential management)
echo.
echo 🎯 NEXT STEPS:
echo.
echo    1. 🔧 CONFIGURE MCP SERVERS (Required for full functionality):
echo       📁 Edit: %%APPDATA%%\Claude\claude_desktop_config.json
echo       📖 Guide: C:\claude\documentation\MCP-SETUP-GUIDE.md
echo.
echo    2. 🔑 SET UP GITHUB PAT (For shadcn/ui integration):
echo       🔧 Run: C:\claude\tools\setup-github-pat.bat
echo       📖 Guide: C:\claude\documentation\GITHUB-PAT-SETUP.md
echo.
echo    3. 🚀 LAUNCH ENHANCED CLAUDE CODE:
echo       🎯 Quick: C:\claude\launchers\LAUNCH-SUPERCLAUDE.bat
echo       📋 Advanced: C:\claude\launchers\launch-claude-code-windows.bat
echo.
echo    4. 📚 LEARN THE SYSTEM:
echo       📖 Quick Start: 01-quick-start\QUICK-SETUP-GUIDE.md
echo       📋 Reference: 01-quick-start\PRINTABLE-REFERENCE.md
echo       🎥 Full Guide: C:\claude\documentation\
echo.
echo 💡 QUICK TEST:
echo    After launching Claude Code, try these commands:
echo    • @frontend "Create a login form with shadcn/ui"
echo    • /analyze your-project-folder --comprehensive
echo    • /troubleshoot "help with Windows git issues"
echo.
echo 🆘 NEED HELP?
echo    📖 Documentation: C:\claude\documentation\
echo    🐛 Issues: https://github.com/aaronvstory/SuperClaudeV2/issues
echo    💬 Discussions: https://github.com/aaronvstory/SuperClaudeV2/discussions
echo.
echo 🎉 Welcome to the enhanced Claude Code experience!
echo.
pause
