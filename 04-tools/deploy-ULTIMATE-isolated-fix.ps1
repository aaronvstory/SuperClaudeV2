#!/usr/bin/env powershell
# FINAL SOLUTION: Create a dedicated isolated environment for win-claude-code
# This approach creates a completely isolated Git environment

Write-Host "========================================" -ForegroundColor Magenta
Write-Host "ISOLATED GIT ENVIRONMENT - FINAL FIX" -ForegroundColor Magenta  
Write-Host "Creating dedicated win-claude-code environment" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""

# Function to create isolated Git environment
function Create-IsolatedGitEnvironment {
    Write-Host "[INFO] Creating isolated Git environment..." -ForegroundColor Yellow
    
    $isolatedDir = "C:\claude\isolated-git-env"
    if (-not (Test-Path $isolatedDir)) {
        New-Item -ItemType Directory -Path $isolatedDir -Force | Out-Null
    }
    
    # Create a git.bat that will be the ONLY git in our isolated PATH
    $gitBatPath = "$isolatedDir\git.bat"
    $gitBatContent = @"
@echo off
REM Isolated Git Environment - Direct to Ultimate Wrapper
call "C:\claude\superclaude-tools\git-ultimate-wrapper.bat" %*
exit /b %errorlevel%
"@
    
    $gitBatContent | Out-File -FilePath $gitBatPath -Encoding ASCII -Force
    Write-Host "[OK] Created isolated git.bat: $gitBatPath" -ForegroundColor Green
    
    return $isolatedDir
}

# Function to create ultimate win-claude-code launcher with isolated environment
function Create-UltimateIsolatedLauncher {
    param($isolatedDir)
    
    Write-Host "[INFO] Creating ultimate isolated launcher..." -ForegroundColor Yellow
    
    $launcherPath = "C:\claude\claude-context-menu-fix\claude-code-launcher-ULTIMATE.bat"
    $launcherContent = @"
@echo off
REM ULTIMATE WIN-CLAUDE-CODE LAUNCHER WITH ISOLATED GIT
setlocal

REM Get target directory
set "TARGET_DIR=%~1"
if "%TARGET_DIR%"=="" set "TARGET_DIR=%cd%"

REM Change to target directory
cd /d "%TARGET_DIR%"

REM Set title
title ULTIMATE Claude Code (Isolated Git) - %TARGET_DIR%

echo ========================================
echo    ULTIMATE CLAUDE CODE LAUNCHER
echo    (Isolated Git Environment)
echo ========================================
echo.
echo Target Directory: %TARGET_DIR%
echo Isolated Git: $isolatedDir\git.bat
echo.

REM COMPLETELY ISOLATED PATH - ONLY our Git + essential Windows + Node.js
set "PATH=$isolatedDir;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem"

REM Add Node.js (required for win-claude-code)
if exist "C:\Program Files\nodejs" set "PATH=%PATH%;C:\Program Files\nodejs"
if exist "C:\Users\%USERNAME%\AppData\Roaming\npm" set "PATH=%PATH%;C:\Users\%USERNAME%\AppData\Roaming\npm"

REM Critical: NO system Git paths in PATH at all!
REM This forces win-claude-code to use ONLY our isolated git.bat

echo [INFO] Testing isolated Git environment...
where git >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Isolated Git not found!
    echo PATH: %PATH%
    pause
    exit /b 1
)

REM Test Git functionality
git --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Isolated Git test failed!
    pause
    exit /b 1
)

echo [OK] Isolated Git environment active.

REM Set Git environment variables
set "GIT_EXEC_PATH=C:\Program Files\Git\mingw64\libexec\git-core"
set "GIT_TEMPLATE_DIR=C:\Program Files\Git\share\git-core\templates"
set "CLAUDE_CODE_GIT_BASH_PATH=C:\Program Files\Git\bin\bash.exe"

REM Additional environment for win-claude-code
set "GIT_SSL_NO_VERIFY=false"
set "GIT_TERMINAL_PROMPT=0"

echo [INFO] Launching win-claude-code in isolated environment...
echo [INFO] Git will use: $isolatedDir\git.bat
echo [INFO] Which calls: git-ultimate-wrapper.bat
echo.

REM Launch win-claude-code with isolated environment
npx win-claude-code@latest --dangerously-skip-permissions

REM Error handling
if errorlevel 1 (
    echo.
    echo [ERROR] win-claude-code failed!
    echo [DEBUG] Isolated PATH: %PATH%
    echo [DEBUG] Git resolution:
    where git
    echo [DEBUG] Git test:
    git --version
    pause
)

endlocal
"@

    $launcherContent | Out-File -FilePath $launcherPath -Encoding ASCII -Force
    Write-Host "[OK] Ultimate isolated launcher created: $launcherPath" -ForegroundColor Green
    
    return $launcherPath
}

# Function to test isolated environment
function Test-IsolatedEnvironment {
    param($isolatedDir, $launcherPath)
    
    Write-Host "[INFO] Testing isolated Git environment..." -ForegroundColor Yellow
    
    # Create a test environment similar to what the launcher will use
    $originalPath = $env:PATH
    try {
        # Set isolated PATH
        $env:PATH = "$isolatedDir;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem"
        
        # Add Node.js if it exists
        if (Test-Path "C:\Program Files\nodejs") {
            $env:PATH += ";C:\Program Files\nodejs"
        }
        
        # Test git resolution
        $gitPath = (Get-Command git -ErrorAction SilentlyContinue).Source
        if ($gitPath -and ($gitPath -like "*$isolatedDir*")) {
            Write-Host "[OK] Isolated Git found at: $gitPath" -ForegroundColor Green
            
            # Test git execution
            try {
                $result = & git --version 2>&1
                Write-Host "[OK] Isolated Git test: $result" -ForegroundColor Green
                return $true
            } catch {
                Write-Host "[ERROR] Isolated Git execution failed: $_" -ForegroundColor Red
                return $false
            }
        } else {
            Write-Host "[ERROR] Isolated Git not found. Git resolves to: $gitPath" -ForegroundColor Red
            return $false
        }
    } finally {
        # Restore original PATH
        $env:PATH = $originalPath
    }
}

# Function to create final test script
function Create-FinalTestScript {
    param($launcherPath)
    
    Write-Host "[INFO] Creating final test script..." -ForegroundColor Yellow
    
    $testScript = "C:\claude\superclaude-tools\test-ULTIMATE-fix.bat"
    $testContent = @"
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

"$launcherPath" "C:\claude\persona-manager"

echo.
echo [INFO] Test completed. Check the results above.
pause
"@

    $testContent | Out-File -FilePath $testScript -Encoding ASCII -Force
    Write-Host "[OK] Final test script created: $testScript" -ForegroundColor Green
}

# Main execution
try {
    Write-Host "[STEP 1] Creating isolated Git environment..."
    $isolatedDir = Create-IsolatedGitEnvironment
    
    Write-Host ""
    Write-Host "[STEP 2] Creating ultimate isolated launcher..."
    $launcherPath = Create-UltimateIsolatedLauncher -isolatedDir $isolatedDir
    
    Write-Host ""
    Write-Host "[STEP 3] Testing isolated environment..."
    if (Test-IsolatedEnvironment -isolatedDir $isolatedDir -launcherPath $launcherPath) {
        Write-Host ""
        Write-Host "[STEP 4] Creating final test script..."
        Create-FinalTestScript -launcherPath $launcherPath
        
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "ULTIMATE ISOLATED ENVIRONMENT READY!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "What was created:" -ForegroundColor Yellow
        Write-Host "1. Isolated Git environment: $isolatedDir" -ForegroundColor White
        Write-Host "2. Ultimate launcher: $launcherPath" -ForegroundColor White
        Write-Host "3. Final test script: C:\claude\superclaude-tools\test-ULTIMATE-fix.bat" -ForegroundColor White
        Write-Host ""
        Write-Host "HOW IT WORKS:" -ForegroundColor Cyan
        Write-Host "- Creates completely isolated PATH with ONLY our Git" -ForegroundColor White
        Write-Host "- win-claude-code cannot find any system Git" -ForegroundColor White
        Write-Host "- Forces use of our working Git wrapper" -ForegroundColor White
        Write-Host "- Eliminates ALL system Git interference" -ForegroundColor White
        Write-Host ""
        Write-Host "TO TEST:" -ForegroundColor Red
        Write-Host "Run: $launcherPath" -ForegroundColor White
        Write-Host "Or: C:\claude\superclaude-tools\test-ULTIMATE-fix.bat" -ForegroundColor White
        Write-Host ""
        Write-Host "This is the FINAL SOLUTION - it MUST work!" -ForegroundColor Green
        
    } else {
        Write-Host ""
        Write-Host "[ERROR] Isolated environment test failed" -ForegroundColor Red
        exit 1
    }
    
} catch {
    Write-Host ""
    Write-Host "[ERROR] Ultimate deployment failed: $_" -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Red
    exit 1
}
