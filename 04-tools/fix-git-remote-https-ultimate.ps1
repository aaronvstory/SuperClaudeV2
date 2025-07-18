#!/usr/bin/env powershell
# Ultimate Git Remote HTTPS Fix for win-claude-code
# This script addresses the "git: 'remote-https' is not a git command" error

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Git Remote HTTPS Ultimate Fix" -ForegroundColor Cyan
Write-Host "Addressing git-remote-https helper issues" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Function to test Git HTTPS functionality
function Test-GitHttps {
    Write-Host "[INFO] Testing Git HTTPS functionality..." -ForegroundColor Yellow
    
    # Test git-remote-https directly
    $gitRemoteHttps = "C:\Program Files\Git\mingw64\libexec\git-core\git-remote-https.exe"
    if (Test-Path $gitRemoteHttps) {
        Write-Host "[OK] git-remote-https.exe found" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] git-remote-https.exe NOT found!" -ForegroundColor Red
        return $false
    }
    
    # Test basic git functionality
    try {
        $gitVersion = & "C:\Program Files\Git\cmd\git.exe" --version 2>$null
        Write-Host "[OK] Git version: $gitVersion" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Git command failed: $_" -ForegroundColor Red
        return $false
    }
    
    return $true
}

# Function to fix Git environment variables
function Fix-GitEnvironment {
    Write-Host "[INFO] Configuring Git environment variables..." -ForegroundColor Yellow
    
    # Set Git core path
    $env:GIT_EXEC_PATH = "C:\Program Files\Git\mingw64\libexec\git-core"
    $env:GIT_TEMPLATE_DIR = "C:\Program Files\Git\share\git-core\templates"
    
    # Ensure PATH includes Git directories in correct order
    $gitPaths = @(
        "C:\Program Files\Git\cmd",
        "C:\Program Files\Git\mingw64\bin",
        "C:\Program Files\Git\mingw64\libexec\git-core"
    )
    
    $currentPath = $env:PATH
    foreach ($gitPath in $gitPaths) {
        if ($currentPath -notlike "*$gitPath*") {
            $env:PATH = "$gitPath;$env:PATH"
            Write-Host "[INFO] Added $gitPath to PATH" -ForegroundColor Cyan
        }
    }
    
    Write-Host "[OK] Git environment configured" -ForegroundColor Green
}

# Function to create ultimate Git wrapper
function Create-UltimateGitWrapper {
    Write-Host "[INFO] Creating ultimate Git wrapper..." -ForegroundColor Yellow
    
    $wrapperPath = "C:\claude\superclaude-tools\git-ultimate-wrapper.bat"
    $wrapperContent = @"
@echo off
REM Ultimate Git Wrapper for win-claude-code
REM Ensures proper environment for git-remote-https

setlocal

REM Set critical Git environment variables
set "GIT_EXEC_PATH=C:\Program Files\Git\mingw64\libexec\git-core"
set "GIT_TEMPLATE_DIR=C:\Program Files\Git\share\git-core\templates"

REM Set PATH to prioritize Git directories
set "PATH=C:\Program Files\Git\cmd;C:\Program Files\Git\mingw64\bin;C:\Program Files\Git\mingw64\libexec\git-core;%PATH%"

REM Set additional environment for HTTPS
set "GIT_SSL_NO_VERIFY=false"
set "GIT_CURL_VERBOSE=0"
set "GIT_TERMINAL_PROMPT=0"

REM Use the correct Git executable
set "GIT_EXE=C:\Program Files\Git\cmd\git.exe"

REM Verify Git executable exists
if not exist "%GIT_EXE%" (
    echo [ERROR] Git not found at: %GIT_EXE%
    exit /b 1
)

REM Debug: Show which git-remote-https we're using
if "%1"=="push" (
    echo [DEBUG] Using GIT_EXEC_PATH: %GIT_EXEC_PATH%
    if exist "%GIT_EXEC_PATH%\git-remote-https.exe" (
        echo [DEBUG] git-remote-https.exe found at: %GIT_EXEC_PATH%\git-remote-https.exe
    ) else (
        echo [ERROR] git-remote-https.exe NOT found!
        exit /b 1
    )
)

REM Execute Git with proper environment
"%GIT_EXE%" %*
set "EXIT_CODE=%errorlevel%"

REM Handle specific errors
if %EXIT_CODE% neq 0 (
    if "%1"=="push" (
        echo.
        echo [ERROR] Git push failed (Exit Code: %EXIT_CODE%)
        echo [TIP] Check authentication and network connectivity
    )
)

exit /b %EXIT_CODE%
"@

    $wrapperContent | Out-File -FilePath $wrapperPath -Encoding ASCII -Force
    Write-Host "[OK] Ultimate Git wrapper created: $wrapperPath" -ForegroundColor Green
    
    return $wrapperPath
}

# Function to update git-config.json for win-claude-code
function Update-GitConfig {
    param($wrapperPath)
    
    Write-Host "[INFO] Updating git-config.json for win-claude-code..." -ForegroundColor Yellow
    
    $gitConfigPath = "$env:USERPROFILE\.claude\git-config.json"
    $gitConfig = @{
        git = @{
            executable = "C:\Program Files\Git\cmd\git.exe"
            wrapper = $wrapperPath
            environment = @{
                GIT_EXEC_PATH = "C:\Program Files\Git\mingw64\libexec\git-core"
                GIT_TEMPLATE_DIR = "C:\Program Files\Git\share\git-core\templates"
                GIT_TERMINAL_PROMPT = "0"
                GIT_SSL_NO_VERIFY = "false"
                GIT_CURL_VERBOSE = "0"
            }
            credential_helper = "manager-core"
        }
    }
    
    $gitConfig | ConvertTo-Json -Depth 10 | Out-File -FilePath $gitConfigPath -Encoding UTF8 -Force
    Write-Host "[OK] git-config.json updated: $gitConfigPath" -ForegroundColor Green
}

# Function to test the fix
function Test-UltimateFix {
    param($wrapperPath)
    
    Write-Host "[INFO] Testing the ultimate fix..." -ForegroundColor Yellow
    
    # Test the wrapper directly
    Write-Host "[TEST] Testing Git wrapper..." -ForegroundColor Cyan
    try {
        $result = & $wrapperPath --version 2>&1
        Write-Host "[OK] Wrapper test passed: $result" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Wrapper test failed: $_" -ForegroundColor Red
        return $false
    }
    
    # Test git-remote-https specifically
    Write-Host "[TEST] Testing git-remote-https helper..." -ForegroundColor Cyan
    
    # Change to a git repository for testing
    $originalLocation = Get-Location
    try {
        if (Test-Path "C:\claude\persona-manager\.git") {
            Set-Location "C:\claude\persona-manager"
            
            # Test git status first
            $statusResult = & $wrapperPath status 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[OK] Git status works" -ForegroundColor Green
            } else {
                Write-Host "[ERROR] Git status failed: $statusResult" -ForegroundColor Red
            }
            
            # Test remote connectivity (without actually pushing)
            $remoteResult = & $wrapperPath remote -v 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[OK] Git remote configuration works" -ForegroundColor Green
                Write-Host $remoteResult -ForegroundColor Gray
            } else {
                Write-Host "[ERROR] Git remote failed: $remoteResult" -ForegroundColor Red
            }
        } else {
            Write-Host "[WARNING] No test repository found, skipping repository tests" -ForegroundColor Yellow
        }
    } finally {
        Set-Location $originalLocation
    }
    
    return $true
}

# Main execution
try {
    Write-Host "[STEP 1] Testing current Git HTTPS functionality..."
    if (Test-GitHttps) {
        Write-Host "[OK] Git HTTPS components are present" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Git HTTPS components missing or broken" -ForegroundColor Red
        exit 1
    }
    
    Write-Host ""
    Write-Host "[STEP 2] Fixing Git environment..."
    Fix-GitEnvironment
    
    Write-Host ""
    Write-Host "[STEP 3] Creating ultimate Git wrapper..."
    $wrapperPath = Create-UltimateGitWrapper
    
    Write-Host ""
    Write-Host "[STEP 4] Updating win-claude-code configuration..."
    Update-GitConfig -wrapperPath $wrapperPath
    
    Write-Host ""
    Write-Host "[STEP 5] Testing the ultimate fix..."
    if (Test-UltimateFix -wrapperPath $wrapperPath) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "ULTIMATE GIT FIX COMPLETED SUCCESSFULLY!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Yellow
        Write-Host "1. Right-click C:\claude\persona-manager and 'Open with Claude Code'" -ForegroundColor White
        Write-Host "2. Test: /git status" -ForegroundColor White
        Write-Host "3. Test: /git push" -ForegroundColor White
        Write-Host ""
        Write-Host "The git-remote-https error should now be resolved!" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "[ERROR] Fix verification failed" -ForegroundColor Red
        exit 1
    }
    
} catch {
    Write-Host ""
    Write-Host "[ERROR] Script failed: $_" -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Red
    exit 1
}
