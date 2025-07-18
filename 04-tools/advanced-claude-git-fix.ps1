# Advanced Claude Code Git Fix - PowerShell Version
# This completely isolates Git environment for Claude Code

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Advanced Claude Code Git Environment Fix" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

param(
    [string]$TargetDir = (Get-Location).Path
)

if (-not (Test-Path $TargetDir)) {
    $TargetDir = (Get-Location).Path
}

Write-Host "Target Directory: $TargetDir" -ForegroundColor White
Write-Host "Using: win-claude-code (Windows Native)" -ForegroundColor White
Write-Host "Git Fix: Advanced environment isolation" -ForegroundColor White
Write-Host ""

# Set location
Set-Location $TargetDir

# Check Node.js
try {
    $nodeVersion = node --version
    Write-Host "✓ Node.js version: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found. Please install from: https://nodejs.org/" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "🔧 Applying Git Environment Fixes..." -ForegroundColor Yellow

# Create a clean environment for Git
$originalPath = $env:PATH
$cleanGitPath = @(
    "C:\Program Files\Git\cmd",
    "C:\Program Files\Git\bin"
) -join ";"

# Remove problematic paths
$pathParts = $env:PATH -split ";" | Where-Object {
    $_ -notlike "*System32*" -and 
    $_ -notlike "*scoop*" -and 
    $_ -ne ""
}

# Rebuild PATH with Git first
$newPath = $cleanGitPath + ";" + ($pathParts -join ";")

# Set clean environment
$env:PATH = $newPath
$env:GIT_EXEC_PATH = "C:\Program Files\Git\libexec\git-core"
$env:GIT_TEMPLATE_DIR = "C:\Program Files\Git\share\git-core\templates"

# Test Git
Write-Host "Testing Git configuration..." -ForegroundColor White
try {
    $gitTest = & "C:\Program Files\Git\cmd\git.exe" --version 2>&1
    Write-Host "✓ Git test successful: $gitTest" -ForegroundColor Green
} catch {
    Write-Host "❌ Git test failed: $_" -ForegroundColor Red
    $env:PATH = $originalPath
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "🚀 Launching Claude Code with fixed environment..." -ForegroundColor Green
Write-Host "• Git PATH isolated and prioritized" -ForegroundColor White
Write-Host "• Permission bypass enabled" -ForegroundColor White
Write-Host "• Windows-native compatibility" -ForegroundColor White
Write-Host ""

try {
    # Launch with clean environment
    npx win-claude-code@latest --dangerously-skip-permissions
} catch {
    Write-Host ""
    Write-Host "❌ Error launching Claude Code: $_" -ForegroundColor Red
} finally {
    # Restore original PATH
    $env:PATH = $originalPath
    Write-Host ""
    Write-Host "Environment restored." -ForegroundColor Gray
}

Write-Host ""
Read-Host "Press Enter to exit"
