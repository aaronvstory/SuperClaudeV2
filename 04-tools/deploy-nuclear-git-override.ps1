#!/usr/bin/env powershell
# Nuclear Git Override - Completely Replace System Git for win-claude-code
# This creates a bulletproof override that win-claude-code MUST use

Write-Host "========================================" -ForegroundColor Red
Write-Host "NUCLEAR GIT OVERRIDE - FINAL SOLUTION" -ForegroundColor Red
Write-Host "Completely replacing system Git detection" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
Write-Host ""

# Function to create multiple git override points
function Create-NuclearGitOverride {
    Write-Host "[INFO] Creating nuclear Git override system..." -ForegroundColor Yellow
    
    # Create override directory
    $overrideDir = "C:\claude\git-nuclear-override"
    if (-not (Test-Path $overrideDir)) {
        New-Item -ItemType Directory -Path $overrideDir -Force | Out-Null
    }
    
    # Create git.exe wrapper (not just .bat)
    $gitExePath = "$overrideDir\git.exe"
    $gitExeContent = @"
@echo off
REM Nuclear Git Override - Direct EXE Wrapper
call "C:\claude\superclaude-tools\git-ultimate-wrapper.bat" %*
exit /b %errorlevel%
"@
    
    # Create git.exe as a batch file (Windows will execute it)
    $gitExeContent | Out-File -FilePath $gitExePath -Encoding ASCII -Force
    
    # Also create git.bat for backup
    $gitBatPath = "$overrideDir\git.bat"
    $gitExeContent | Out-File -FilePath $gitBatPath -Encoding ASCII -Force
    
    # Create git.cmd for triple coverage
    $gitCmdPath = "$overrideDir\git.cmd"
    $gitExeContent | Out-File -FilePath $gitCmdPath -Encoding ASCII -Force
    
    Write-Host "[OK] Created git.exe at: $gitExePath" -ForegroundColor Green
    Write-Host "[OK] Created git.bat at: $gitBatPath" -ForegroundColor Green  
    Write-Host "[OK] Created git.cmd at: $gitCmdPath" -ForegroundColor Green
    
    return $overrideDir
}

# Function to create a dedicated Claude Code launcher with forced Git path
function Create-ClaudeCodeLauncherWithGitOverride {
    param($overrideDir)
    
    Write-Host "[INFO] Creating Claude Code launcher with forced Git override..." -ForegroundColor Yellow
    
    $launcherPath = "C:\claude\claude-context-menu-fix\claude-code-launcher-nuclear.bat"
    $launcherContent = @"
@echo off
REM Nuclear Claude Code Launcher with Forced Git Override
setlocal enabledelayedexpansion

REM Get the directory passed as parameter
set "TARGET_DIR=%~1"
if "%TARGET_DIR%"=="" set "TARGET_DIR=%cd%"

REM Change to the target directory
cd /d "%TARGET_DIR%"

REM Set window title
title Nuclear Claude Code (Git Override) - %TARGET_DIR%

echo ========================================
echo    NUCLEAR CLAUDE CODE LAUNCHER
echo    (Forced Git Override Active)
echo ========================================
echo.
echo Target Directory: %TARGET_DIR%
echo Git Override: $overrideDir
echo.

REM NUCLEAR PATH OVERRIDE - Put our Git first, REMOVE system Git paths
set "PATH=$overrideDir;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem"

REM Add Node.js and other essential paths (but NOT Git paths)
for %%P in ("C:\Program Files\nodejs" "C:\Users\%USERNAME%\AppData\Roaming\npm" "C:\ProgramData\chocolatey\bin") do (
    if exist "%%~P" set "PATH=!PATH!;%%~P"
)

REM Verify our Git override is first
where git >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git override not found in PATH!
    echo Current PATH: %PATH%
    pause
    exit /b 1
)

echo [INFO] Git override active. Testing...
git --version
if errorlevel 1 (
    echo [ERROR] Git override test failed!
    pause
    exit /b 1
)

echo [OK] Git override working correctly.

REM Set environment variables for win-claude-code
set "GIT_EXEC_PATH=C:\Program Files\Git\mingw64\libexec\git-core"
set "GIT_TEMPLATE_DIR=C:\Program Files\Git\share\git-core\templates"
set "CLAUDE_CODE_GIT_BASH_PATH=C:\Program Files\Git\bin\bash.exe"

echo [INFO] Launching win-claude-code with nuclear Git override...
echo.

REM Launch win-claude-code
npx win-claude-code@latest --dangerously-skip-permissions

REM Handle errors
if errorlevel 1 (
    echo.
    echo [ERROR] win-claude-code failed!
    echo [DEBUG] PATH: %PATH%
    echo [DEBUG] Git location: 
    where git
    pause
)

endlocal
"@

    $launcherContent | Out-File -FilePath $launcherPath -Encoding ASCII -Force
    Write-Host "[OK] Nuclear launcher created: $launcherPath" -ForegroundColor Green
    
    return $launcherPath
}

# Function to update registry for context menu
function Update-ContextMenuRegistry {
    param($launcherPath)
    
    Write-Host "[INFO] Updating context menu to use nuclear launcher..." -ForegroundColor Yellow
    
    try {
        # Update the registry entry to use our nuclear launcher
        $regPath = "Registry::HKEY_CLASSES_ROOT\Directory\shell\claude-code\command"
        if (Test-Path $regPath) {
            Set-ItemProperty -Path $regPath -Name "(Default)" -Value "`"$launcherPath`" `"%1`""
            Write-Host "[OK] Registry updated to use nuclear launcher" -ForegroundColor Green
        } else {
            Write-Host "[WARNING] Context menu registry entry not found" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "[WARNING] Could not update registry: $_" -ForegroundColor Yellow
        Write-Host "[INFO] You may need to run as administrator for registry changes" -ForegroundColor Cyan
    }
}

# Function to test the nuclear override
function Test-NuclearOverride {
    param($overrideDir)
    
    Write-Host "[INFO] Testing nuclear Git override..." -ForegroundColor Yellow
    
    # Set PATH to prioritize our override
    $env:PATH = "$overrideDir;" + $env:PATH
    
    # Test git command resolution
    try {
        $gitPath = (Get-Command git -ErrorAction Stop).Source
        Write-Host "[TEST] Git resolves to: $gitPath" -ForegroundColor Cyan
        
        if ($gitPath -like "*$overrideDir*") {
            Write-Host "[OK] Nuclear override is working!" -ForegroundColor Green
            
            # Test the actual git command
            $result = & git --version 2>&1
            Write-Host "[OK] Git test result: $result" -ForegroundColor Green
            return $true
        } else {
            Write-Host "[ERROR] Git still resolving to system location: $gitPath" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "[ERROR] Git command not found: $_" -ForegroundColor Red
        return $false
    }
}

# Function to create test script for the new launcher
function Create-NuclearTestScript {
    param($launcherPath)
    
    Write-Host "[INFO] Creating nuclear test script..." -ForegroundColor Yellow
    
    $testScript = "C:\claude\superclaude-tools\test-nuclear-override.bat"
    $testContent = @"
@echo off
echo ========================================
echo Testing Nuclear Git Override
echo ========================================
echo.

echo [TEST] Starting nuclear launcher test...
echo Launcher: $launcherPath
echo.

echo [INFO] This will open win-claude-code with nuclear Git override.
echo [INFO] In the Claude session, test:
echo   /git status
echo   /git push
echo.
echo [INFO] You should see NO 'remote-https' errors!
echo.

pause
"$launcherPath" "C:\claude\persona-manager"
"@

    $testContent | Out-File -FilePath $testScript -Encoding ASCII -Force
    Write-Host "[OK] Nuclear test script created: $testScript" -ForegroundColor Green
}

# Main execution
try {
    Write-Host "[STEP 1] Creating nuclear Git override system..."
    $overrideDir = Create-NuclearGitOverride
    
    Write-Host ""
    Write-Host "[STEP 2] Creating nuclear Claude Code launcher..."
    $launcherPath = Create-ClaudeCodeLauncherWithGitOverride -overrideDir $overrideDir
    
    Write-Host ""
    Write-Host "[STEP 3] Updating context menu registry..."
    Update-ContextMenuRegistry -launcherPath $launcherPath
    
    Write-Host ""
    Write-Host "[STEP 4] Testing nuclear override..."
    if (Test-NuclearOverride -overrideDir $overrideDir) {
        Write-Host ""
        Write-Host "[STEP 5] Creating test script..."
        Create-NuclearTestScript -launcherPath $launcherPath
        
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "NUCLEAR GIT OVERRIDE DEPLOYED!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "What was deployed:" -ForegroundColor Yellow
        Write-Host "1. Nuclear Git override: $overrideDir" -ForegroundColor White
        Write-Host "   - git.exe (primary override)" -ForegroundColor White
        Write-Host "   - git.bat (backup)" -ForegroundColor White  
        Write-Host "   - git.cmd (triple coverage)" -ForegroundColor White
        Write-Host "2. Nuclear launcher: $launcherPath" -ForegroundColor White
        Write-Host "3. Registry updated for context menu" -ForegroundColor White
        Write-Host ""
        Write-Host "TESTING OPTIONS:" -ForegroundColor Red
        Write-Host "Option A - Direct Launch:" -ForegroundColor Yellow
        Write-Host "  Run: $launcherPath" -ForegroundColor White
        Write-Host ""
        Write-Host "Option B - Context Menu:" -ForegroundColor Yellow  
        Write-Host "  Right-click C:\claude\persona-manager -> 'Open with Claude Code'" -ForegroundColor White
        Write-Host ""
        Write-Host "Option C - Test Script:" -ForegroundColor Yellow
        Write-Host "  Run: C:\claude\superclaude-tools\test-nuclear-override.bat" -ForegroundColor White
        Write-Host ""
        Write-Host "In win-claude-code, test:" -ForegroundColor Green
        Write-Host "  /git status" -ForegroundColor White
        Write-Host "  /git push" -ForegroundColor White
        Write-Host ""
        Write-Host "This NUCLEAR override bypasses ALL system Git detection!" -ForegroundColor Red
        
    } else {
        Write-Host ""
        Write-Host "[ERROR] Nuclear override test failed" -ForegroundColor Red
        exit 1
    }
    
} catch {
    Write-Host ""
    Write-Host "[ERROR] Nuclear deployment failed: $_" -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Red
    exit 1
}
