@echo off
title Claude Code Right-Click Menu Test
chcp 65001 >nul 2>&1

echo ========================================
echo    Claude Code Right-Click Menu Test
echo ========================================
echo.

echo This script simulates what happens when you right-click
echo and select "Open with Claude Code"
echo.

REM Get current directory
set "TEST_DIR=%cd%"
echo Testing from directory: %TEST_DIR%
echo.

echo Calling the updated launcher...
echo.

REM Call the same launcher that the right-click menu uses
call "C:\CLAUDE\claude-context-menu-fix\claude-code-launcher.bat" "%TEST_DIR%"

echo.
echo ========================================
echo Test completed.
echo.
echo If Claude Code launched successfully with no EINVAL errors,
echo then your right-click menu is working perfectly!
echo.
pause
