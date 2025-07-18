#!/usr/bin/env powershell
# Direct Git Executable Override for win-claude-code
# This replaces the Git executable that win-claude-code finds with our wrapper

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Direct Git Override for win-claude-code" -ForegroundColor Cyan
Write-Host "Making our wrapper the primary Git executable" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Function to create git.bat wrapper in a high-priority PATH location
function Create-GitBatWrapper {
    Write-Host "[INFO] Creating git.bat wrapper to override system Git..." -ForegroundColor Yellow
    
    # Create a directory for our Git override
    $overrideDir = "C:\claude\git-override"
    if (-not (Test-Path $overrideDir)) {
        New-Item -ItemType Directory -Path $overrideDir -Force | Out-Null
        Write-Host "[INFO] Created override directory: $overrideDir" -ForegroundColor Cyan
    }
    
    $gitBatPath = "$overrideDir\git.bat"
    $gitBatContent = @"
@echo off
REM Git Override Wrapper for win-claude-code
REM This ensures our ultimate wrapper is used instead of system Git

REM Call our ultimate wrapper with all arguments
call "C:\claude\superclaude-tools\git-ultimate-wrapper.bat" %*
exit /b %errorlevel%
"@

    $gitBatContent | Out-File -FilePath $gitBatPath -Encoding ASCII -Force
    Write-Host "[OK] Created git.bat override: $gitBatPath" -ForegroundColor Green
    
    return $overrideDir
}

# Function to update PATH to prioritize our override
function Update-PathPriority {
    param($overrideDir)
    
    Write-Host "[INFO] Updating PATH to prioritize Git override..." -ForegroundColor Yellow
    
    # Get current PATH
    $currentPath = $env:PATH
    
    # Remove our override dir if it's already in PATH
    $pathList = $currentPath -split ';' | Where-Object { $_ -ne $overrideDir }
    
    # Add our override dir at the beginning
    $newPath = "$overrideDir;" + ($pathList -join ';')
    
    # Set for current session
    $env:PATH = $newPath
    
    # Set for user environment (persistent)
    [Environment]::SetEnvironmentVariable("PATH", $newPath, [EnvironmentVariableTarget]::User)
    
    Write-Host "[OK] PATH updated to prioritize Git override" -ForegroundColor Green
    Write-Host "[INFO] Override directory: $overrideDir" -ForegroundColor Cyan
}

# Function to update the context menu launcher
function Update-ContextMenuLauncher {
    param($overrideDir)
    
    Write-Host "[INFO] Updating context menu launcher..." -ForegroundColor Yellow
    
    $launcherPath = "C:\claude\claude-context-menu-fix\claude-code-launcher.bat"
    
    if (Test-Path $launcherPath) {
        # Read current launcher
        $launcherContent = Get-Content $launcherPath -Raw
        
        # Add our override directory to PATH at the beginning
        $pathUpdateLine = "set `"PATH=$overrideDir;%PATH%`""
        
        # Find where to insert the PATH update (after the PATH setup but before launching)
        $updatedContent = $launcherContent -replace 'set "PATH=C:\\Program Files\\Git\\cmd;C:\\Program Files\\Git\\bin;%PATH%"', 
            "set `"PATH=$overrideDir;C:\Program Files\Git\cmd;C:\Program Files\Git\bin;%PATH%`""
        
        # Save the updated launcher
        $updatedContent | Out-File -FilePath $launcherPath -Encoding ASCII -Force
        Write-Host "[OK] Context menu launcher updated" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] Context menu launcher not found at: $launcherPath" -ForegroundColor Yellow
    }
}

# Function to test the override
function Test-GitOverride {
    Write-Host "[INFO] Testing Git override..." -ForegroundColor Yellow
    
    # Test which git executable is found
    $gitPath = (Get-Command git -ErrorAction SilentlyContinue).Source
    Write-Host "[TEST] Git command resolves to: $gitPath" -ForegroundColor Cyan
    
    # Test our git.bat wrapper
    try {
        $result = & git --version 2>&1
        Write-Host "[OK] Git override test passed: $result" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "[ERROR] Git override test failed: $_" -ForegroundColor Red
        return $false
    }
}

# Function to create a test script for win-claude-code
function Create-TestScript {
    Write-Host "[INFO] Creating test script for win-claude-code..." -ForegroundColor Yellow
    
    $testScript = "C:\claude\superclaude-tools\test-win-claude-code-git.bat"
    $testContent = @"
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
"@

    $testContent | Out-File -FilePath $testScript -Encoding ASCII -Force
    Write-Host "[OK] Test script created: $testScript" -ForegroundColor Green
}

# Main execution
try {
    Write-Host "[STEP 1] Creating git.bat override wrapper..."
    $overrideDir = Create-GitBatWrapper
    
    Write-Host ""
    Write-Host "[STEP 2] Updating PATH priority..."
    Update-PathPriority -overrideDir $overrideDir
    
    Write-Host ""
    Write-Host "[STEP 3] Updating context menu launcher..."
    Update-ContextMenuLauncher -overrideDir $overrideDir
    
    Write-Host ""
    Write-Host "[STEP 4] Testing Git override..."
    if (Test-GitOverride) {
        Write-Host ""
        Write-Host "[STEP 5] Creating test script..."
        Create-TestScript
        
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "DIRECT GIT OVERRIDE COMPLETED!" -ForegroundColor Green  
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "What was done:" -ForegroundColor Yellow
        Write-Host "1. Created git.bat wrapper at: $overrideDir\git.bat" -ForegroundColor White
        Write-Host "2. Updated PATH to prioritize our wrapper" -ForegroundColor White  
        Write-Host "3. Updated context menu launcher" -ForegroundColor White
        Write-Host ""
        Write-Host "CRITICAL NEXT STEPS:" -ForegroundColor Red
        Write-Host "1. CLOSE the current win-claude-code session completely" -ForegroundColor White
        Write-Host "2. Start a NEW Command Prompt (to pick up PATH changes)" -ForegroundColor White
        Write-Host "3. Right-click C:\claude\persona-manager -> 'Open with Claude Code'" -ForegroundColor White
        Write-Host "4. Test: /git status" -ForegroundColor White
        Write-Host "5. Test: /git push" -ForegroundColor White
        Write-Host ""
        Write-Host "The win-claude-code should now use our wrapper automatically!" -ForegroundColor Green
        
    } else {
        Write-Host ""
        Write-Host "[ERROR] Git override test failed" -ForegroundColor Red
        exit 1
    }
    
} catch {
    Write-Host ""
    Write-Host "[ERROR] Script failed: $_" -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Red
    exit 1
}
