# Claude Code Windows Fix - Comprehensive Diagnostic and Repair

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Claude Code Windows Compatibility Fix" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$fixApplied = $false

Write-Host "🔍 STEP 1: Diagnosing Current Setup" -ForegroundColor Yellow
Write-Host ""

# Check what's currently installed
Write-Host "Checking installed Claude Code versions..." -ForegroundColor White

try {
    $nativeClaudeCode = npm list -g @anthropic-ai/claude-code 2>$null
    if ($nativeClaudeCode -like "*@anthropic-ai/claude-code*") {
        Write-Host "❗ Found: Native Anthropic Claude Code (CAUSES WINDOWS ISSUES)" -ForegroundColor Red
        $hasNative = $true
    } else {
        Write-Host "✓ Native Anthropic Claude Code: Not found" -ForegroundColor Green
        $hasNative = $false
    }
} catch {
    $hasNative = $false
}

try {
    $winClaudeCode = npm list -g win-claude-code 2>$null
    if ($winClaudeCode -like "*win-claude-code*") {
        Write-Host "✓ Found: win-claude-code (WINDOWS COMPATIBLE)" -ForegroundColor Green
        $hasWin = $true
    } else {
        Write-Host "❗ win-claude-code: Not found" -ForegroundColor Red
        $hasWin = $false
    }
} catch {
    $hasWin = $false
}

Write-Host ""
Write-Host "🔧 STEP 2: Problem Analysis" -ForegroundColor Yellow
Write-Host ""

if ($hasNative -and -not $hasWin) {
    Write-Host "❌ PROBLEM IDENTIFIED: You're using native Claude Code" -ForegroundColor Red
    Write-Host "   This causes the EINVAL errors you're seeing with Git commands." -ForegroundColor White
    Write-Host "   Native Claude Code expects WSL/Unix environment." -ForegroundColor White
    Write-Host ""
    Write-Host "✅ SOLUTION: Install and use win-claude-code instead" -ForegroundColor Green
    
    $install = Read-Host "Install win-claude-code now? (y/n)"
    if ($install -eq 'y' -or $install -eq 'Y') {
        Write-Host "Installing win-claude-code..." -ForegroundColor Yellow
        npm install -g win-claude-code@latest
        $hasWin = $true
        $fixApplied = $true
    }
} elseif (-not $hasNative -and $hasWin) {
    Write-Host "✅ GOOD: You only have win-claude-code installed" -ForegroundColor Green
    Write-Host "   But you might be launching it incorrectly." -ForegroundColor White
} elseif ($hasNative -and $hasWin) {
    Write-Host "⚠️  CONFLICT: You have both versions installed" -ForegroundColor Yellow
    Write-Host "   You need to make sure you're using win-claude-code" -ForegroundColor White
} else {
    Write-Host "❌ PROBLEM: No Claude Code found" -ForegroundColor Red
    
    $install = Read-Host "Install win-claude-code? (y/n)"
    if ($install -eq 'y' -or $install -eq 'Y') {
        Write-Host "Installing win-claude-code..." -ForegroundColor Yellow
        npm install -g win-claude-code@latest
        $hasWin = $true
        $fixApplied = $true
    }
}

Write-Host ""
Write-Host "🚀 STEP 3: Verification and Launch Instructions" -ForegroundColor Yellow
Write-Host ""

if ($hasWin) {
    Write-Host "✅ CORRECT LAUNCH METHOD:" -ForegroundColor Green
    Write-Host ""
    Write-Host "Method 1 - Direct npx (RECOMMENDED):" -ForegroundColor White
    Write-Host "  npx win-claude-code@latest" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Method 2 - Use our launcher script:" -ForegroundColor White
    Write-Host "  powershell -File `"C:\claude\superclaude-tools\launch-claude-code-windows.ps1`"" -ForegroundColor Gray
    Write-Host ""
    Write-Host "❌ WRONG METHODS (cause EINVAL errors):" -ForegroundColor Red
    Write-Host "  - claude-code (if it points to native version)" -ForegroundColor White
    Write-Host "  - Any method that doesn't explicitly use win-claude-code" -ForegroundColor White
    Write-Host ""
    
    # Test win-claude-code
    Write-Host "Testing win-claude-code..." -ForegroundColor Yellow
    try {
        $testOutput = npx win-claude-code@latest --version 2>&1
        Write-Host "✓ win-claude-code test successful: $testOutput" -ForegroundColor Green
    } catch {
        Write-Host "❌ win-claude-code test failed: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "❌ win-claude-code not available. Please install it first." -ForegroundColor Red
}

Write-Host ""
Write-Host "📋 STEP 4: How to Fix Your Current Issue" -ForegroundColor Yellow
Write-Host ""

Write-Host "To fix the Git EINVAL errors in your persona-manager project:" -ForegroundColor White
Write-Host ""
Write-Host "1. Close your current Claude Code session" -ForegroundColor White
Write-Host "2. Navigate to your project:" -ForegroundColor White
Write-Host "   cd C:\claude\persona-manager" -ForegroundColor Gray
Write-Host "3. Launch win-claude-code:" -ForegroundColor White
Write-Host "   npx win-claude-code@latest" -ForegroundColor Gray
Write-Host "4. Try your /git commit command again" -ForegroundColor White
Write-Host ""

Write-Host "🎯 STEP 5: Create Desktop Shortcut (Optional)" -ForegroundColor Yellow
Write-Host ""

$createShortcut = Read-Host "Create desktop shortcut for Windows Claude Code? (y/n)"
if ($createShortcut -eq 'y' -or $createShortcut -eq 'Y') {
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $shortcutPath = "$desktopPath\Windows Claude Code.lnk"
    
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = "powershell.exe"
    $shortcut.Arguments = "-ExecutionPolicy Bypass -File `"C:\claude\superclaude-tools\launch-claude-code-windows.ps1`""
    $shortcut.WorkingDirectory = "C:\claude\persona-manager"
    $shortcut.Description = "Windows-compatible Claude Code launcher"
    $shortcut.Save()
    
    Write-Host "✅ Desktop shortcut created: Windows Claude Code.lnk" -ForegroundColor Green
    $fixApplied = $true
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "              SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if ($fixApplied) {
    Write-Host "✅ FIX APPLIED: You should now be able to use Claude Code without EINVAL errors" -ForegroundColor Green
} else {
    Write-Host "⚠️  MANUAL ACTION REQUIRED: Follow the instructions above" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Key Points:" -ForegroundColor White
Write-Host "• Always use 'npx win-claude-code@latest' to launch Claude Code" -ForegroundColor White
Write-Host "• win-claude-code provides native Windows Git support" -ForegroundColor White
Write-Host "• Avoid using 'claude-code' command if it points to native version" -ForegroundColor White
Write-Host "• Your SuperClaude installations will work perfectly with win-claude-code" -ForegroundColor White

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
