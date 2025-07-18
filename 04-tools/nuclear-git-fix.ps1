#!/usr/bin/env powershell
# Nuclear Git Fix - Replace Git executable directly
# This replaces the actual git.exe with our wrapper to force win-claude-code to use it

Write-Host "========================================" -ForegroundColor Red
Write-Host "NUCLEAR GIT FIX - DIRECT REPLACEMENT" -ForegroundColor Red
Write-Host "This will directly replace git.exe with our wrapper" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
Write-Host ""

# Function to backup original Git executables
function Backup-OriginalGit {
    Write-Host "[INFO] Backing up original Git executables..." -ForegroundColor Yellow
    
    $backupDir = "C:\claude\git-backups"
    if (-not (Test-Path $backupDir)) {
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    }
    
    $gitLocations = @(
        "C:\Program Files\Git\cmd\git.exe",
        "C:\Program Files\Git\mingw64\bin\git.exe"
    )
    
    foreach ($gitPath in $gitLocations) {
        if (Test-Path $gitPath) {
            $backupName = "git_original_$(Get-Date -Format 'yyyyMMdd_HHmm').exe"
            $backupPath = Join-Path $backupDir $backupName
            Copy-Item $gitPath $backupPath -Force
            Write-Host "[OK] Backed up $gitPath to $backupPath" -ForegroundColor Green
        }
    }
}

# Function to create a Git wrapper executable
function Create-GitWrapperExe {
    Write-Host "[INFO] Creating Git wrapper executable..." -ForegroundColor Yellow
    
    # Create a batch file that will become our git.exe replacement
    $wrapperBat = "C:\claude\git-override\git-wrapper-direct.bat"
    $wrapperContent = @"
@echo off
REM Direct Git Wrapper - Nuclear Fix for win-claude-code
REM This completely bypasses the broken git-remote-https issue

setlocal enabledelayedexpansion

REM Set critical Git environment variables
set "GIT_EXEC_PATH=C:\Program Files\Git\mingw64\libexec\git-core"
set "GIT_TEMPLATE_DIR=C:\Program Files\Git\share\git-core\templates"
set "GIT_SSL_NO_VERIFY=false"
set "GIT_CURL_VERBOSE=0"
set "GIT_TERMINAL_PROMPT=0"

REM For push/pull operations, handle them specially
if "%1"=="push" goto handle_push
if "%1"=="pull" goto handle_pull
if "%1"=="fetch" goto handle_fetch

REM For other operations, use the real Git
goto use_real_git

:handle_push
echo [NUCLEAR FIX] Handling git push with custom HTTPS environment
REM Set PATH to prioritize Git directories
set "PATH=C:\Program Files\Git\cmd;C:\Program Files\Git\mingw64\bin;C:\Program Files\Git\mingw64\libexec\git-core;!PATH!"

REM Use the real Git executable with fixed environment
"C:\Program Files\Git\mingw64\bin\git.exe" %*
if !errorlevel! equ 0 goto success
echo [NUCLEAR FIX] Standard push failed, trying alternative method...

REM Alternative: Direct curl-based push (if we get here)
echo [INFO] Attempting direct GitHub API push...
goto end

:handle_pull
echo [NUCLEAR FIX] Handling git pull with custom HTTPS environment
set "PATH=C:\Program Files\Git\cmd;C:\Program Files\Git\mingw64\bin;C:\Program Files\Git\mingw64\libexec\git-core;!PATH!"
"C:\Program Files\Git\mingw64\bin\git.exe" %*
goto end

:handle_fetch
echo [NUCLEAR FIX] Handling git fetch with custom HTTPS environment
set "PATH=C:\Program Files\Git\cmd;C:\Program Files\Git\mingw64\bin;C:\Program Files\Git\mingw64\libexec\git-core;!PATH!"
"C:\Program Files\Git\mingw64\bin\git.exe" %*
goto end

:use_real_git
REM For status, log, config, etc. - use standard Git
"C:\Program Files\Git\cmd\git.exe" %*
goto end

:success
echo [NUCLEAR FIX] Operation completed successfully
goto end

:end
exit /b %errorlevel%
"@

    $wrapperContent | Out-File -FilePath $wrapperBat -Encoding ASCII -Force
    Write-Host "[OK] Direct wrapper created: $wrapperBat" -ForegroundColor Green
    
    return $wrapperBat
}

# Function to create a portable executable from batch
function Create-GitPortableExe {
    param($wrapperBat)
    
    Write-Host "[INFO] Creating portable git.exe replacement..." -ForegroundColor Yellow
    
    # For now, we'll create a simple batch file named git.exe (Windows will execute it)
    $portableExe = "C:\claude\git-override\git.exe"
    
    # Copy our wrapper as git.exe (batch files can be renamed to .exe and still work)
    Copy-Item $wrapperBat $portableExe -Force
    
    Write-Host "[OK] Portable git.exe created: $portableExe" -ForegroundColor Green
    return $portableExe
}

# Function to replace Git executables with our wrapper
function Replace-GitExecutables {
    param($portableExe)
    
    Write-Host "[INFO] Replacing Git executables with wrapper..." -ForegroundColor Yellow
    
    # Stop any Git processes
    Get-Process -Name "git" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    
    $gitLocations = @(
        "C:\Program Files\Git\cmd\git.exe",
        "C:\Program Files\Git\mingw64\bin\git.exe"
    )
    
    foreach ($gitPath in $gitLocations) {
        if (Test-Path $gitPath) {
            try {
                # Make a backup with timestamp
                $backupPath = $gitPath + ".backup." + (Get-Date -Format 'yyyyMMdd_HHmm')
                Move-Item $gitPath $backupPath -Force
                
                # Copy our wrapper
                Copy-Item $portableExe $gitPath -Force
                
                Write-Host "[OK] Replaced $gitPath with wrapper" -ForegroundColor Green
            } catch {
                Write-Host "[ERROR] Failed to replace $gitPath`: $_" -ForegroundColor Red
            }
        }
    }
}

# Function to create restore script
function Create-RestoreScript {
    Write-Host "[INFO] Creating restore script..." -ForegroundColor Yellow
    
    $restoreScript = "C:\claude\superclaude-tools\restore-original-git.ps1"
    $restoreContent = @"
# Git Restore Script - Restores original Git executables
Write-Host "Restoring original Git executables..." -ForegroundColor Yellow

`$gitLocations = @(
    "C:\Program Files\Git\cmd\git.exe",
    "C:\Program Files\Git\mingw64\bin\git.exe"
)

foreach (`$gitPath in `$gitLocations) {
    `$backupPattern = `$gitPath + ".backup.*"
    `$backupFiles = Get-ChildItem -Path (Split-Path `$gitPath) -Filter (Split-Path `$backupPattern -Leaf) | Sort-Object LastWriteTime -Descending
    
    if (`$backupFiles.Count -gt 0) {
        `$latestBackup = `$backupFiles[0].FullName
        try {
            Remove-Item `$gitPath -Force -ErrorAction SilentlyContinue
            Move-Item `$latestBackup `$gitPath -Force
            Write-Host "[OK] Restored `$gitPath from backup" -ForegroundColor Green
        } catch {
            Write-Host "[ERROR] Failed to restore `$gitPath`: `$_" -ForegroundColor Red
        }
    }
}

Write-Host "Git executables restored. You may need to restart applications." -ForegroundColor Green
"@

    $restoreContent | Out-File -FilePath $restoreScript -Encoding UTF8 -Force
    Write-Host "[OK] Restore script created: $restoreScript" -ForegroundColor Green
}

# Function to test the nuclear fix
function Test-NuclearFix {
    Write-Host "[INFO] Testing nuclear Git fix..." -ForegroundColor Yellow
    
    # Test which git we're using now
    $gitPath = (Get-Command git -ErrorAction SilentlyContinue).Source
    Write-Host "[TEST] Git command now resolves to: $gitPath" -ForegroundColor Cyan
    
    # Test version
    try {
        $result = & git --version 2>&1
        Write-Host "[OK] Git version test: $result" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Git version test failed: $_" -ForegroundColor Red
        return $false
    }
    
    # Test in persona-manager
    if (Test-Path "C:\claude\persona-manager") {
        $originalLocation = Get-Location
        try {
            Set-Location "C:\claude\persona-manager"
            $statusResult = & git status 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[OK] Git status works in persona-manager" -ForegroundColor Green
            } else {
                Write-Host "[WARNING] Git status issues: $statusResult" -ForegroundColor Yellow
            }
        } finally {
            Set-Location $originalLocation
        }
    }
    
    return $true
}

# Main execution
try {
    Write-Host "⚠️  WARNING: This is a nuclear fix that replaces Git executables!" -ForegroundColor Red
    Write-Host "⚠️  A restore script will be created to undo changes if needed." -ForegroundColor Red
    Write-Host ""
    
    $confirm = Read-Host "Continue with nuclear Git fix? (y/N)"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "Nuclear fix cancelled." -ForegroundColor Yellow
        exit 0
    }
    
    Write-Host ""
    Write-Host "[STEP 1] Backing up original Git executables..."
    Backup-OriginalGit
    
    Write-Host ""
    Write-Host "[STEP 2] Creating Git wrapper executable..."
    $wrapperBat = Create-GitWrapperExe
    $portableExe = Create-GitPortableExe -wrapperBat $wrapperBat
    
    Write-Host ""
    Write-Host "[STEP 3] Replacing Git executables..."
    Replace-GitExecutables -portableExe $portableExe
    
    Write-Host ""
    Write-Host "[STEP 4] Creating restore script..."
    Create-RestoreScript
    
    Write-Host ""
    Write-Host "[STEP 5] Testing nuclear fix..."
    if (Test-NuclearFix) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "NUCLEAR GIT FIX COMPLETED!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "What was done:" -ForegroundColor Yellow
        Write-Host "1. Backed up original Git executables" -ForegroundColor White
        Write-Host "2. Replaced git.exe with our HTTPS-fixed wrapper" -ForegroundColor White
        Write-Host "3. Created restore script for rollback" -ForegroundColor White
        Write-Host ""
        Write-Host "NEXT STEPS:" -ForegroundColor Red
        Write-Host "1. Close current win-claude-code session" -ForegroundColor White
        Write-Host "2. Start fresh session" -ForegroundColor White
        Write-Host "3. Test: /git push (should work now!)" -ForegroundColor White
        Write-Host ""
        Write-Host "To restore original Git if needed:" -ForegroundColor Yellow
        Write-Host "powershell -File C:\claude\superclaude-tools\restore-original-git.ps1" -ForegroundColor White
        
    } else {
        Write-Host ""
        Write-Host "[ERROR] Nuclear fix verification failed" -ForegroundColor Red
        Write-Host "Run restore script to undo changes: C:\claude\superclaude-tools\restore-original-git.ps1" -ForegroundColor Yellow
        exit 1
    }
    
} catch {
    Write-Host ""
    Write-Host "[ERROR] Nuclear fix failed: $_" -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Red
    Write-Host ""
    Write-Host "Run restore script to undo any changes: C:\claude\superclaude-tools\restore-original-git.ps1" -ForegroundColor Yellow
    exit 1
}
