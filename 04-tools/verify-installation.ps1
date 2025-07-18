# SuperClaude Installation Verification Script
# This script checks both NomenAK and Gwendall SuperClaude installations

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   SuperClaude Dual Installation Check" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$successCount = 0
$errorCount = 0

# Check 1: NomenAK SuperClaude Framework
Write-Host "[1/6] Checking NomenAK SuperClaude Framework..." -ForegroundColor Yellow
if (Test-Path "C:\claude\superclaude\SuperClaude.py") {
    Write-Host "    ✓ NomenAK SuperClaude Framework: INSTALLED" -ForegroundColor Green
    $successCount++
} else {
    Write-Host "    ✗ NomenAK SuperClaude Framework: NOT FOUND" -ForegroundColor Red
    $errorCount++
}

# Check 2: Gwendall SuperClaude CLI
Write-Host "[2/6] Checking Gwendall SuperClaude CLI..." -ForegroundColor Yellow
try {
    $null = npm list -g superclaude 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "    ✓ Gwendall SuperClaude CLI: INSTALLED" -ForegroundColor Green
        $successCount++
    } else {
        Write-Host "    ✗ Gwendall SuperClaude CLI: NOT INSTALLED" -ForegroundColor Red
        $errorCount++
    }
} catch {
    Write-Host "    ✗ Gwendall SuperClaude CLI: NOT INSTALLED" -ForegroundColor Red
    $errorCount++
}

# Check 3: SuperClaude Windows Wrapper
Write-Host "[3/6] Checking SuperClaude Windows Wrapper..." -ForegroundColor Yellow
if (Test-Path "C:\Users\d0nbx\.mcp-modules\superclaude-wrapper.bat") {
    Write-Host "    ✓ SuperClaude Windows Wrapper: FOUND" -ForegroundColor Green
    $successCount++
} else {
    Write-Host "    ✗ SuperClaude Windows Wrapper: NOT FOUND" -ForegroundColor Red
    $errorCount++
}

# Check 4: Claude Code Configuration
Write-Host "[4/6] Checking Claude Code Configuration..." -ForegroundColor Yellow
if (Test-Path "C:\users\d0nbx\.claude\superclaude-config.json") {
    Write-Host "    ✓ Claude Code SuperClaude Config: FOUND" -ForegroundColor Green
    $successCount++
} else {
    Write-Host "    ✗ Claude Code SuperClaude Config: NOT FOUND" -ForegroundColor Red
    $errorCount++
}

# Check 5: Git Bash
Write-Host "[5/6] Checking Git Bash availability..." -ForegroundColor Yellow
if (Test-Path "C:\Program Files\Git\bin\bash.exe") {
    Write-Host "    ✓ Git Bash: AVAILABLE" -ForegroundColor Green
    $successCount++
} else {
    Write-Host "    ✗ Git Bash: NOT FOUND" -ForegroundColor Red
    $errorCount++
}

# Check 6: Node.js
Write-Host "[6/6] Checking Node.js..." -ForegroundColor Yellow
try {
    $null = node --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "    ✓ Node.js: AVAILABLE" -ForegroundColor Green
        $successCount++
    } else {
        Write-Host "    ✗ Node.js: NOT FOUND" -ForegroundColor Red
        $errorCount++
    }
} catch {
    Write-Host "    ✗ Node.js: NOT FOUND" -ForegroundColor Red
    $errorCount++
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SUMMARY: Working Components: $successCount/6" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($successCount -eq 6) {
    Write-Host "🎉 PERFECT! Both SuperClaude installations are working!" -ForegroundColor Green
    Write-Host ""
    Write-Host "USAGE GUIDE:" -ForegroundColor White
    Write-Host ""
    Write-Host "NomenAK SuperClaude Framework:" -ForegroundColor Yellow
    Write-Host "  Location: C:\claude\superclaude\" -ForegroundColor White
    Write-Host "  Usage: Enhanced Claude Code with commands and personas" -ForegroundColor White
    Write-Host ""
    Write-Host "Gwendall SuperClaude CLI:" -ForegroundColor Yellow
    Write-Host "  Usage: C:\Users\d0nbx\.mcp-modules\superclaude-wrapper.bat [command]" -ForegroundColor White
    Write-Host "  Examples:" -ForegroundColor White
    Write-Host "    superclaude-wrapper.bat commit --interactive" -ForegroundColor Gray
    Write-Host "    superclaude-wrapper.bat changelog" -ForegroundColor Gray
    Write-Host "    superclaude-wrapper.bat readme" -ForegroundColor Gray
} else {
    Write-Host "⚠️ Some components need attention." -ForegroundColor Yellow
    Write-Host "Check the failed items above for details." -ForegroundColor White
}

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
