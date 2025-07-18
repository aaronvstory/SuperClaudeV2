@echo off
echo ========================================
echo Testing win-claude-code Git Integration
echo ========================================
echo.

echo [TEST] Checking which git executable is found...
where git
echo.

echo [TEST] Testing git version...
git --version
echo.

echo [TEST] Changing to persona-manager directory...
cd /d "C:\claude\persona-manager"
echo.

echo [TEST] Testing git status...
git status
echo.

echo [TEST] Testing git remote...
git remote -v
echo.

echo ========================================
echo Test completed. Check for any errors above.
echo If no 'remote-https' errors appear, the fix is working!
echo ========================================
pause
