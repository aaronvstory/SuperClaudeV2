# Complete Claude Code Permission Bypass Verification

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Claude Code Permission Bypass Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$testResults = @()

# Test 1: Check main launcher has permission bypass
Write-Host "1. Checking main launcher configuration..." -ForegroundColor Yellow
$launcherPath = "C:\CLAUDE\claude-context-menu-fix\claude-code-launcher.bat"
if (Test-Path $launcherPath) {
    $content = Get-Content $launcherPath -Raw
    if ($content -like "*--dangerously-skip-permissions*") {
        Write-Host "   ✅ Main launcher has --dangerously-skip-permissions" -ForegroundColor Green
        $testResults += "Main launcher: Permission bypass ENABLED"
    } else {
        Write-Host "   ❌ Main launcher missing permission bypass" -ForegroundColor Red
        $testResults += "Main launcher: Permission bypass MISSING"
    }
} else {
    Write-Host "   ❌ Main launcher not found" -ForegroundColor Red
    $testResults += "Main launcher: NOT FOUND"
}

# Test 2: Check alternative launcher
Write-Host "2. Checking alternative launcher..." -ForegroundColor Yellow
$altLauncherPath = "C:\CLAUDE\claude-context-menu-fix\claude-code-launcher-alternative.bat"
if (Test-Path $altLauncherPath) {
    $altContent = Get-Content $altLauncherPath -Raw
    if ($altContent -like "*--permission-mode bypassPermissions*") {
        Write-Host "   ✅ Alternative launcher has --permission-mode bypassPermissions" -ForegroundColor Green
        $testResults += "Alternative launcher: Official bypass mode ENABLED"
    } else {
        Write-Host "   ❌ Alternative launcher missing permission bypass" -ForegroundColor Red
        $testResults += "Alternative launcher: Permission bypass MISSING"
    }
} else {
    Write-Host "   ❌ Alternative launcher not found" -ForegroundColor Red
    $testResults += "Alternative launcher: NOT FOUND"
}

# Test 3: Verify win-claude-code supports permission flags
Write-Host "3. Testing win-claude-code permission flags..." -ForegroundColor Yellow
try {
    $helpOutput = npx win-claude-code@latest --help 2>&1
    if ($helpOutput -like "*--dangerously-skip-permissions*") {
        Write-Host "   ✅ win-claude-code supports --dangerously-skip-permissions" -ForegroundColor Green
        $testResults += "win-claude-code: Dangerous skip flag SUPPORTED"
    } else {
        Write-Host "   ❌ win-claude-code missing --dangerously-skip-permissions" -ForegroundColor Red
        $testResults += "win-claude-code: Dangerous skip flag NOT SUPPORTED"
    }
    
    if ($helpOutput -like "*--permission-mode*") {
        Write-Host "   ✅ win-claude-code supports --permission-mode" -ForegroundColor Green
        $testResults += "win-claude-code: Permission mode flag SUPPORTED"
    } else {
        Write-Host "   ❌ win-claude-code missing --permission-mode" -ForegroundColor Red
        $testResults += "win-claude-code: Permission mode flag NOT SUPPORTED"
    }
} catch {
    Write-Host "   ❌ Error testing win-claude-code: $_" -ForegroundColor Red
    $testResults += "win-claude-code: ERROR testing flags"
}

# Test 4: Check registry entries point to updated launcher
Write-Host "4. Verifying registry integration..." -ForegroundColor Yellow
try {
    $dirCommand = Get-ItemProperty "HKLM:\SOFTWARE\Classes\Directory\shell\OpenClaudeCode\command" -Name "(default)" -ErrorAction Stop
    if ($dirCommand.'(default)' -like "*claude-code-launcher.bat*") {
        Write-Host "   ✅ Directory context menu points to updated launcher" -ForegroundColor Green
        $testResults += "Registry: Directory menu PROPERLY CONFIGURED"
    } else {
        Write-Host "   ❌ Directory context menu points to wrong launcher" -ForegroundColor Red
        $testResults += "Registry: Directory menu MISCONFIGURED"
    }
} catch {
    Write-Host "   ❌ Directory context menu not found in registry" -ForegroundColor Red
    $testResults += "Registry: Directory menu NOT FOUND"
}

try {
    $bgCommand = Get-ItemProperty "HKLM:\SOFTWARE\Classes\Directory\Background\shell\OpenClaudeCode\command" -Name "(default)" -ErrorAction Stop
    if ($bgCommand.'(default)' -like "*claude-code-launcher.bat*") {
        Write-Host "   ✅ Background context menu points to updated launcher" -ForegroundColor Green
        $testResults += "Registry: Background menu PROPERLY CONFIGURED"
    } else {
        Write-Host "   ❌ Background context menu points to wrong launcher" -ForegroundColor Red
        $testResults += "Registry: Background menu MISCONFIGURED"
    }
} catch {
    Write-Host "   ❌ Background context menu not found in registry" -ForegroundColor Red
    $testResults += "Registry: Background menu NOT FOUND"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "           TEST RESULTS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

foreach ($result in $testResults) {
    if ($result -like "*ENABLED*" -or $result -like "*SUPPORTED*" -or $result -like "*PROPERLY CONFIGURED*") {
        Write-Host "✅ $result" -ForegroundColor Green
    } else {
        Write-Host "❌ $result" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "        PERMISSION BYPASS STATUS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$passCount = ($testResults | Where-Object { $_ -like "*ENABLED*" -or $_ -like "*SUPPORTED*" -or $_ -like "*PROPERLY CONFIGURED*" }).Count
$totalTests = $testResults.Count

if ($passCount -eq $totalTests) {
    Write-Host "🎉 PERFECT! All permission bypass features are working!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your right-click menu now:" -ForegroundColor White
    Write-Host "• Launches win-claude-code with permission bypass" -ForegroundColor White
    Write-Host "• Skips all approval prompts" -ForegroundColor White
    Write-Host "• Provides seamless operation" -ForegroundColor White
    Write-Host "• Works with native Windows Git" -ForegroundColor White
} elseif ($passCount -gt ($totalTests / 2)) {
    Write-Host "⚠️  Mostly working, but some issues detected." -ForegroundColor Yellow
    Write-Host "Check the failed items above for details." -ForegroundColor White
} else {
    Write-Host "❌ Multiple issues detected. Manual intervention needed." -ForegroundColor Red
    Write-Host "Check the failed items above and run fixes." -ForegroundColor White
}

Write-Host ""
Write-Host "🚀 READY TO TEST:" -ForegroundColor Yellow
Write-Host "1. Right-click on any folder" -ForegroundColor White
Write-Host "2. Select 'Open with Claude Code'" -ForegroundColor White
Write-Host "3. Claude Code should start immediately without permission prompts" -ForegroundColor White
Write-Host "4. Try /git commands - they should work without EINVAL errors" -ForegroundColor White

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
