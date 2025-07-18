@echo off
setlocal enabledelayedexpansion
title SuperClaude Installation Verification & Setup

echo ========================================
echo    SuperClaude Dual Installation Check
echo ========================================
echo.

set "ERROR_COUNT=0"
set "SUCCESS_COUNT=0"

REM Check 1: NomenAK SuperClaude Framework
echo [1/6] Checking NomenAK SuperClaude Framework...
if exist "C:\claude\superclaude\SuperClaude.py" (
    cd /d "C:\claude\superclaude"
    python SuperClaude.py --version >nul 2>&1
    if !errorlevel! equ 0 (
        echo ✅ NomenAK SuperClaude Framework: INSTALLED and WORKING
        set /a SUCCESS_COUNT+=1
    ) else (
        echo ❌ NomenAK SuperClaude Framework: INSTALLED but NOT WORKING
        set /a ERROR_COUNT+=1
    )
) else (
    echo ❌ NomenAK SuperClaude Framework: NOT FOUND
    set /a ERROR_COUNT+=1
)

REM Check 2: Gwendall SuperClaude CLI
echo [2/6] Checking Gwendall SuperClaude CLI...
npm list -g superclaude >nul 2>&1
if !errorlevel! equ 0 (
    echo ✅ Gwendall SuperClaude CLI: INSTALLED
    set /a SUCCESS_COUNT+=1
) else (
    echo ❌ Gwendall SuperClaude CLI: NOT INSTALLED
    set /a ERROR_COUNT+=1
)

REM Check 3: SuperClaude Windows Wrapper
echo [3/6] Checking SuperClaude Windows Wrapper...
if exist "C:\Users\d0nbx\.mcp-modules\superclaude-wrapper.bat" (
    C:\Users\d0nbx\.mcp-modules\superclaude-wrapper.bat --version >nul 2>&1
    if !errorlevel! equ 0 (
        echo ✅ SuperClaude Windows Wrapper: WORKING
        set /a SUCCESS_COUNT+=1
    ) else (
        echo ❌ SuperClaude Windows Wrapper: EXISTS but NOT WORKING
        set /a ERROR_COUNT+=1
    )
) else (
    echo ❌ SuperClaude Windows Wrapper: NOT FOUND
    set /a ERROR_COUNT+=1
)

REM Check 4: Claude Code Configuration
echo [4/6] Checking Claude Code Configuration...
if exist "C:\users\d0nbx\.claude\superclaude-config.json" (
    echo ✅ Claude Code SuperClaude Config: FOUND
    set /a SUCCESS_COUNT+=1
) else (
    echo ❌ Claude Code SuperClaude Config: NOT FOUND
    set /a ERROR_COUNT+=1
)

REM Check 5: Git Bash (required for gwendall's SuperClaude)
echo [5/6] Checking Git Bash availability...
if exist "C:\Program Files\Git\bin\bash.exe" (
    "C:\Program Files\Git\bin\bash.exe" --version >nul 2>&1
    if !errorlevel! equ 0 (
        echo ✅ Git Bash: AVAILABLE
        set /a SUCCESS_COUNT+=1
    ) else (
        echo ❌ Git Bash: FOUND but NOT WORKING
        set /a ERROR_COUNT+=1
    )
) else (
    echo ❌ Git Bash: NOT FOUND
    echo     Install Git for Windows from: https://git-scm.com/download/win
    set /a ERROR_COUNT+=1
)

REM Check 6: Node.js and npm
echo [6/6] Checking Node.js and npm...
node --version >nul 2>&1
if !errorlevel! equ 0 (
    npm --version >nul 2>&1
    if !errorlevel! equ 0 (
        echo ✅ Node.js and npm: AVAILABLE
        set /a SUCCESS_COUNT+=1
    ) else (
        echo ❌ npm: NOT WORKING
        set /a ERROR_COUNT+=1
    )
) else (
    echo ❌ Node.js: NOT FOUND
    set /a ERROR_COUNT+=1
)

echo.
echo ========================================
echo           INSTALLATION SUMMARY
echo ========================================
echo ✅ Working Components: !SUCCESS_COUNT!/6
echo ❌ Issues Found: !ERROR_COUNT!/6
echo.

if !ERROR_COUNT! equ 0 (
    echo 🎉 PERFECT! Both SuperClaude installations are working flawlessly!
    echo.
    echo 📚 USAGE GUIDE:
    echo ┌─ NomenAK SuperClaude Framework:
    echo │  • Location: C:\claude\superclaude\
    echo │  • Usage: Enhanced Claude Code with commands and personas
    echo │  • Commands: /analyze, /improve, /troubleshoot, etc.
    echo │
    echo ├─ Gwendall SuperClaude CLI:
    echo │  • Usage: C:\Users\d0nbx\.mcp-modules\superclaude-wrapper.bat [command]
    echo │  • Features: AI commit messages, changelogs, documentation
    echo │  • Examples:
    echo │    - superclaude-wrapper.bat commit --interactive
    echo │    - superclaude-wrapper.bat changelog
    echo │    - superclaude-wrapper.bat readme
    echo │
    echo └─ Integration: Both work together seamlessly with Claude Code
    echo.
) else (
    echo ⚠️  Some components need attention. Check the failed items above.
    echo.
    echo 🔧 QUICK FIXES:
    if !ERROR_COUNT! gtr 0 (
        echo • For missing installations, run the setup commands provided
        echo • For working issues, check error messages in individual tools
        echo • Ensure all prerequisites (Node.js, Git, Python) are installed
    )
    echo.
)

echo ========================================
echo Press any key to exit...
pause >nul
