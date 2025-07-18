@echo off
echo ========================================
echo ULTIMATE GIT FIX - FINAL TEST
echo ========================================
echo.

echo [INFO] This test will launch win-claude-code with:
echo   - Completely isolated Git environment
echo   - Only our fixed Git wrapper in PATH
echo   - No system Git interference
echo.

echo [INFO] In the Claude session, test these commands:
echo   /git status
echo   /git push
echo.

echo [EXPECTED] You should see:
echo   - NO 'remote-https' errors
echo   - Debug output showing proper git-remote-https.exe
echo   - Normal Git authentication flow
echo.

echo [INFO] Launching ultimate isolated win-claude-code...
pause

"C:\claude\claude-context-menu-fix\claude-code-launcher-ULTIMATE.bat" "C:\claude\persona-manager"

echo.
echo [INFO] Test completed. Check the results above.
pause
