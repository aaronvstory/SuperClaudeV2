@echo off
title SuperClaude Installation Verification

echo ========================================
echo    SuperClaude Dual Installation Check
echo ========================================
echo.

set "SUCCESS_COUNT=0"
set "ERROR_COUNT=0"

REM Check 1: NomenAK SuperClaude Framework
echo [1/6] Checking NomenAK SuperClaude Framework...
if exist "C:\claude\superclaude\SuperClaude.py" (
    echo     ✅ NomenAK SuperClaude Framework: INSTALLED
    set /a SUCCESS_COUNT+=1
) else (
    echo     ❌ NomenAK SuperClaude Framework: NOT FOUND
    set /a ERROR_COUNT+=1
)

REM Check 2: Gwendall SuperClaude CLI
echo [2/6] Checking Gwendall SuperClaude CLI...
npm list -g superclaude >nul 2>&1
if %errorlevel% equ 0 (
    echo     ✅ Gwendall SuperClaude CLI: INSTALLED
    set /a SUCCESS_COUNT+=1
) else (
    echo     ❌ Gwendall SuperClaude CLI: NOT INSTALLED
    set /a ERROR_COUNT+=1
)

REM Check 3: SuperClaude Windows Wrapper
echo [3/6] Checking SuperClaude Windows Wrapper...
if exist "C:\Users\d0nbx\.mcp-modules\superclaude-wrapper.bat" (
    echo     ✅ SuperClaude Windows Wrapper: FOUND
    set /a SUCCESS_COUNT+=1
) else (
    echo     ❌ SuperClaude Windows Wrapper: NOT FOUND
    set /a ERROR_COUNT+=1
)

REM Check 4: Claude Code Configuration
echo [4/6] Checking Claude Code Configuration...
if exist "C:\users\d0nbx\.claude\superclaude-config.json" (
    echo     ✅ Claude Code SuperClaude Config: FOUND
    set /a SUCCESS_COUNT+=1
) else (
    echo     ❌ Claude Code SuperClaude Config: NOT FOUND
    set /a ERROR_COUNT+=1
)

REM Check 5: Git Bash
echo [5/6] Checking Git Bash availability...
if exist "C:\Program Files\Git\bin\bash.exe" (
    echo     ✅ Git Bash: AVAILABLE
    set /a SUCCESS_COUNT+=1
) else (
    echo     ❌ Git Bash: NOT FOUND
    set /a ERROR_COUNT+=1
)

REM Check 6: Node.js
echo [6/6] Checking Node.js...
node --version >nul 2>&1
if %errorlevel% equ 0 (
    echo     ✅ Node.js: AVAILABLE
    set /a SUCCESS_COUNT+=1
) else (
    echo     ❌ Node.js: NOT FOUND
    set /a ERROR_COUNT+=1
)

echo.
echo ========================================
echo SUMMARY: Working Components: %SUCCESS_COUNT%/6
echo ========================================
echo.

if %SUCCESS_COUNT% equ 6 (
    echo 🎉 PERFECT! Both SuperClaude installations are working!
    echo.
    echo USAGE GUIDE:
    echo.
    echo NomenAK SuperClaude Framework:
    echo   Location: C:\claude\superclaude\
    echo   Usage: Enhanced Claude Code with commands and personas
    echo.
    echo Gwendall SuperClaude CLI:
    echo   Usage: C:\Users\d0nbx\.mcp-modules\superclaude-wrapper.bat [command]
    echo   Examples:
    echo     superclaude-wrapper.bat commit --interactive
    echo     superclaude-wrapper.bat changelog
    echo     superclaude-wrapper.bat readme
    echo.
) else (
    echo ⚠️ Some components need attention.
    echo Check the failed items above for details.
)

echo ========================================
pause
