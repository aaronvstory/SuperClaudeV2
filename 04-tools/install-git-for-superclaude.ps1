#!/usr/bin/env powershell
# Quick Git for Windows Installation for SuperClaude
# This automates the Git installation process

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Quick Git Installation for SuperClaude" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Function to download and install Git for Windows
function Install-GitForWindows {
    Write-Host "[INFO] Downloading Git for Windows..." -ForegroundColor Yellow
    
    # Download latest Git for Windows
    $gitUrl = "https://github.com/git-for-windows/git/releases/latest/download/Git-2.50.1-64-bit.exe"
    $downloadPath = "$env:TEMP\GitForWindows-Latest.exe"
    
    try {
        Write-Host "[INFO] Downloading from: $gitUrl" -ForegroundColor Cyan
        Invoke-WebRequest -Uri $gitUrl -OutFile $downloadPath -UseBasicParsing
        Write-Host "[OK] Download completed" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Download failed: $_" -ForegroundColor Red
        Write-Host "[INFO] Please download manually from: https://gitforwindows.org/" -ForegroundColor Yellow
        return $false
    }
    
    # Install Git with optimal settings for SuperClaude
    Write-Host "[INFO] Installing Git for Windows..." -ForegroundColor Yellow
    Write-Host "[INFO] Using SuperClaude-optimized settings..." -ForegroundColor Cyan
    
    $installArgs = @(
        "/VERYSILENT",
        "/NORESTART",
        "/NOCANCEL",
        "/SP-",
        "/CLOSEAPPLICATIONS",
        "/RESTARTAPPLICATIONS",
        "/COMPONENTS=""ext,ext\shellhere,ext\guihere,gitlfs,assoc,assoc_sh""",
        "/o:PathOption=Cmd",
        "/o:BashTerminalOption=MinTTY",
        "/o:DefaultBranchOption=main",
        "/o:CRLFOption=CRLFAlways",
        "/o:SSLOption=OpenSSL",
        "/o:CURLOption=WinSSL",
        "/o:CredentialManagerOption=Core",
        "/o:PerformanceTweaksFSCache=Enabled",
        "/o:UseBuiltinRebase=Enabled",
        "/o:EnableSymlinks=Disabled",
        "/o:EnablePseudoConsoleSupport=Disabled",
        "/o:EnableFSMonitor=Disabled"
    )
    
    try {
        Start-Process -FilePath $downloadPath -ArgumentList $installArgs -Wait -NoNewWindow
        Write-Host "[OK] Git for Windows installed successfully" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Installation failed: $_" -ForegroundColor Red
        return $false
    }
    
    # Clean up download
    Remove-Item $downloadPath -ErrorAction SilentlyContinue
    
    return $true
}

# Function to configure Git for SuperClaude
function Configure-GitForSuperClaude {
    Write-Host "[INFO] Configuring Git for SuperClaude..." -ForegroundColor Yellow
    
    # Refresh environment to pick up new Git installation
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
    
    # Test Git installation
    try {
        $gitVersion = & "C:\Program Files\Git\cmd\git.exe" --version 2>$null
        Write-Host "[OK] Git installed: $gitVersion" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Git installation verification failed" -ForegroundColor Red
        return $false
    }
    
    # Configure Git for optimal SuperClaude experience
    $gitConfig = @(
        @("user.name", "Claude Development Suite"),
        @("user.email", "claude-dev-suite@example.com"),
        @("credential.helper", "manager-core"),
        @("http.sslVerify", "true"),
        @("http.sslBackend", "schannel"),
        @("core.autocrlf", "true"),
        @("core.editor", "notepad"),
        @("init.defaultBranch", "main"),
        @("pull.rebase", "false"),
        @("push.default", "simple")
    )
    
    foreach ($config in $gitConfig) {
        try {
            & "C:\Program Files\Git\cmd\git.exe" config --global $config[0] $config[1]
            Write-Host "[CONFIG] Set $($config[0]) = $($config[1])" -ForegroundColor Cyan
        } catch {
            Write-Host "[WARNING] Failed to set $($config[0])" -ForegroundColor Yellow
        }
    }
    
    Write-Host "[OK] Git configured for SuperClaude" -ForegroundColor Green
    return $true
}

# Function to test Git functionality
function Test-GitFunctionality {
    Write-Host "[INFO] Testing Git functionality..." -ForegroundColor Yellow
    
    # Test basic Git commands
    $testResults = @()
    
    # Test 1: Version
    try {
        $version = & "C:\Program Files\Git\cmd\git.exe" --version
        $testResults += "[✓] Version: $version"
    } catch {
        $testResults += "[✗] Version test failed"
    }
    
    # Test 2: Git Bash
    if (Test-Path "C:\Program Files\Git\bin\bash.exe") {
        $testResults += "[✓] Git Bash found"
    } else {
        $testResults += "[✗] Git Bash missing"
    }
    
    # Test 3: Remote helpers
    if (Test-Path "C:\Program Files\Git\mingw64\libexec\git-core\git-remote-https.exe") {
        $testResults += "[✓] HTTPS remote helper found"
    } else {
        $testResults += "[✗] HTTPS remote helper missing"
    }
    
    # Test 4: Credential manager
    try {
        $credHelper = & "C:\Program Files\Git\cmd\git.exe" config --global credential.helper
        $testResults += "[✓] Credential helper: $credHelper"
    } catch {
        $testResults += "[✗] Credential helper test failed"
    }
    
    # Display results
    Write-Host ""
    Write-Host "Git Functionality Test Results:" -ForegroundColor Yellow
    foreach ($result in $testResults) {
        if ($result -like "*✓*") {
            Write-Host "  $result" -ForegroundColor Green
        } else {
            Write-Host "  $result" -ForegroundColor Red
        }
    }
}

# Function to update launcher script
function Update-LauncherScript {
    Write-Host "[INFO] Updating Claude Code launcher..." -ForegroundColor Yellow
    
    $launcherPath = "C:\claude\claude-context-menu-fix\claude-code-launcher.bat"
    
    if (Test-Path $launcherPath) {
        # Create updated launcher that works with proper Git installation
        $newLauncherContent = @"
@echo off
REM Claude Code Ultimate Windows Fix - Post Git Installation
setlocal enabledelayedexpansion

set "TARGET_DIR=%~1"
if "%TARGET_DIR%"=="" set "TARGET_DIR=%cd%"
cd /d "%TARGET_DIR%"

title Windows Claude Code (Git Enabled) - %TARGET_DIR%

echo ========================================
echo    Windows Claude Code Launcher
echo    Git for Windows + SuperClaude Ready
echo ========================================
echo.
echo Target Directory: %TARGET_DIR%
echo Using: win-claude-code (Windows Native)
echo Git Status: Enabled and Configured
echo Permission Mode: Bypass all permission checks
echo.

REM Check Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js not found. Install from: https://nodejs.org/
    pause
    exit /b 1
)

REM Verify Git installation
if not exist "C:\Program Files\Git\bin\bash.exe" (
    echo [ERROR] Git Bash not found. Run git installation script.
    pause
    exit /b 1
)

REM Set Git environment
set "CLAUDE_CODE_GIT_BASH_PATH=C:\Program Files\Git\bin\bash.exe"
set "PATH=C:\Program Files\Git\cmd;C:\Program Files\Git\bin;%PATH%"

echo [INFO] Git Bash configured successfully.
echo [INFO] Starting Claude Code with full Git support...
echo.

npx win-claude-code@latest --dangerously-skip-permissions

if errorlevel 1 (
    echo.
    echo [ERROR] Claude Code encountered an error.
    pause
)
"@

        $newLauncherContent | Out-File -FilePath $launcherPath -Encoding ASCII -Force
        Write-Host "[OK] Launcher updated for Git support" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] Launcher not found at: $launcherPath" -ForegroundColor Yellow
    }
}

# Main execution
try {
    Write-Host "This script will install Git for Windows with SuperClaude-optimized settings." -ForegroundColor White
    Write-Host "Installation will take 3-5 minutes and requires internet connection." -ForegroundColor White
    Write-Host ""
    
    $confirm = Read-Host "Continue with Git installation? (y/N)"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "Installation cancelled." -ForegroundColor Yellow
        exit 0
    }
    
    Write-Host ""
    Write-Host "[STEP 1] Installing Git for Windows..."
    if (-not (Install-GitForWindows)) {
        throw "Git installation failed"
    }
    
    Write-Host ""
    Write-Host "[STEP 2] Configuring Git for SuperClaude..."
    if (-not (Configure-GitForSuperClaude)) {
        throw "Git configuration failed"
    }
    
    Write-Host ""
    Write-Host "[STEP 3] Testing Git functionality..."
    Test-GitFunctionality
    
    Write-Host ""
    Write-Host "[STEP 4] Updating launcher script..."
    Update-LauncherScript
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "GIT INSTALLATION COMPLETED!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your SuperClaude environment now has full Git support!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor White
    Write-Host "1. Right-click C:\claude\persona-manager" -ForegroundColor Cyan
    Write-Host "2. Select 'Open with Claude Code'" -ForegroundColor Cyan
    Write-Host "3. Test: /git status" -ForegroundColor Cyan
    Write-Host "4. Test: /git push (will prompt for GitHub credentials)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Git commands now work in:" -ForegroundColor Green
    Write-Host "✓ win-claude-code sessions" -ForegroundColor White
    Write-Host "✓ Command Prompt" -ForegroundColor White
    Write-Host "✓ PowerShell" -ForegroundColor White
    Write-Host "✓ SuperClaude framework" -ForegroundColor White
    
} catch {
    Write-Host ""
    Write-Host "[ERROR] Installation failed: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Manual installation option:" -ForegroundColor Yellow
    Write-Host "1. Download Git from: https://gitforwindows.org/" -ForegroundColor White
    Write-Host "2. Run installer with default settings" -ForegroundColor White
    Write-Host "3. Enable 'Git Credential Manager Core'" -ForegroundColor White
    Write-Host "4. Restart command prompt and try again" -ForegroundColor White
}
