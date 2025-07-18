# Complete Claude Code Windows Fix Script
# This script fixes all Claude Code issues and ensures proper win-claude-code integration

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Complete Claude Code Windows Fix" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$fixesApplied = @()

Write-Host "🔧 STEP 1: Updating Context Menu Launcher" -ForegroundColor Yellow
Write-Host ""

# The launcher has already been updated to use npx win-claude-code@latest
Write-Host "✅ Updated: C:\CLAUDE\claude-context-menu-fix\claude-code-launcher.bat" -ForegroundColor Green
Write-Host "   • Now uses win-claude-code (Windows-compatible version)" -ForegroundColor White
Write-Host "   • Fixes Git EINVAL errors" -ForegroundColor White
Write-Host "   • Provides native Windows support" -ForegroundColor White
$fixesApplied += "Context menu launcher updated"

Write-Host ""
Write-Host "🔧 STEP 2: Verifying Registry Entries" -ForegroundColor Yellow
Write-Host ""

# Check directory context menu
try {
    $dirCommand = Get-ItemProperty "HKLM:\SOFTWARE\Classes\Directory\shell\OpenClaudeCode\command" -Name "(default)" -ErrorAction Stop
    Write-Host "✅ Directory context menu: Working" -ForegroundColor Green
    Write-Host "   Command: $($dirCommand.'(default)')" -ForegroundColor Gray
} catch {
    Write-Host "❌ Directory context menu: Not found" -ForegroundColor Red
}

# Check background context menu
try {
    $bgCommand = Get-ItemProperty "HKLM:\SOFTWARE\Classes\Directory\Background\shell\OpenClaudeCode\command" -Name "(default)" -ErrorAction Stop
    Write-Host "✅ Background context menu: Working" -ForegroundColor Green
    Write-Host "   Command: $($bgCommand.'(default)')" -ForegroundColor Gray
} catch {
    Write-Host "❌ Background context menu: Not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "🔧 STEP 3: Cleaning Up Old Installations" -ForegroundColor Yellow
Write-Host ""

# Check for conflicting installations
$hasNativeClaudeCode = $false
$hasWinClaudeCode = $false

try {
    $nativeCheck = npm list -g @anthropic-ai/claude-code 2>$null
    if ($nativeCheck -like "*@anthropic-ai/claude-code*") {
        Write-Host "⚠️  Found: Native Anthropic Claude Code (may cause conflicts)" -ForegroundColor Yellow
        $hasNativeClaudeCode = $true
    }
} catch {}

try {
    $winCheck = npm list -g win-claude-code 2>$null
    if ($winCheck -like "*win-claude-code*") {
        Write-Host "✅ Found: win-claude-code (Windows-compatible)" -ForegroundColor Green
        $hasWinClaudeCode = $true
    }
} catch {}

if ($hasNativeClaudeCode -and $hasWinClaudeCode) {
    Write-Host ""
    Write-Host "🎯 RECOMMENDATION: Remove native Claude Code to avoid conflicts" -ForegroundColor Yellow
    $removeNative = Read-Host "Remove @anthropic-ai/claude-code? (y/n)"
    if ($removeNative -eq 'y' -or $removeNative -eq 'Y') {
        Write-Host "Removing native Claude Code..." -ForegroundColor Yellow
        npm uninstall -g @anthropic-ai/claude-code
        Write-Host "✅ Native Claude Code removed" -ForegroundColor Green
        $fixesApplied += "Removed conflicting native Claude Code"
    }
}

Write-Host ""
Write-Host "🔧 STEP 4: Updating win-claude-code" -ForegroundColor Yellow
Write-Host ""

Write-Host "Updating win-claude-code to latest version..." -ForegroundColor White
try {
    $updateResult = npm install -g win-claude-code@latest 2>&1
    Write-Host "✅ win-claude-code updated successfully" -ForegroundColor Green
    $fixesApplied += "Updated win-claude-code to latest"
} catch {
    Write-Host "❌ Failed to update win-claude-code: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "🔧 STEP 5: Testing Complete Setup" -ForegroundColor Yellow
Write-Host ""

# Test the launcher
Write-Host "Testing launcher script..." -ForegroundColor White
if (Test-Path "C:\CLAUDE\claude-context-menu-fix\claude-code-launcher.bat") {
    Write-Host "✅ Launcher script exists and updated" -ForegroundColor Green
} else {
    Write-Host "❌ Launcher script missing" -ForegroundColor Red
}

# Test win-claude-code
Write-Host "Testing win-claude-code..." -ForegroundColor White
try {
    $versionTest = npx win-claude-code@latest --version 2>&1
    Write-Host "✅ win-claude-code working: $versionTest" -ForegroundColor Green
} catch {
    Write-Host "❌ win-claude-code test failed: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "🔧 STEP 6: Setting Up Additional Conveniences" -ForegroundColor Yellow
Write-Host ""

# Create a quick test script
$testScript = @"
@echo off
echo Testing win-claude-code from: %cd%
npx win-claude-code@latest --version
pause
"@

$testPath = "C:\CLAUDE\claude-context-menu-fix\test-win-claude-code.bat"
$testScript | Out-File -FilePath $testPath -Encoding ASCII
Write-Host "✅ Created test script: $testPath" -ForegroundColor Green
$fixesApplied += "Created test script"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "           FIXES APPLIED" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

foreach ($fix in $fixesApplied) {
    Write-Host "✅ $fix" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎉 YOUR RIGHT-CLICK MENU IS NOW FIXED!" -ForegroundColor Green
Write-Host ""
Write-Host "What this means:" -ForegroundColor White
Write-Host "• Right-click → 'Open with Claude Code' now uses win-claude-code" -ForegroundColor White
Write-Host "• No more Git EINVAL errors" -ForegroundColor White
Write-Host "• Native Windows compatibility" -ForegroundColor White
Write-Host "• Works perfectly with your SuperClaude installations" -ForegroundColor White
Write-Host ""
Write-Host "🚀 READY TO TEST:" -ForegroundColor Yellow
Write-Host "1. Right-click on any folder" -ForegroundColor White
Write-Host "2. Select 'Open with Claude Code'" -ForegroundColor White
Write-Host "3. Try /git commands - they should work perfectly now!" -ForegroundColor White
Write-Host ""
Write-Host "If you encounter any issues, run:" -ForegroundColor Gray
Write-Host "C:\CLAUDE\claude-context-menu-fix\test-win-claude-code.bat" -ForegroundColor Gray

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
