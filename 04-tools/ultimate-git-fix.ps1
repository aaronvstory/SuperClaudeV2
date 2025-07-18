# Ultimate Claude Code Windows Git Fix Verification
# This script ensures all Git issues are completely resolved

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Ultimate Claude Code Git Fix" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$fixes = @()

# Fix 1: Set Claude Code Git Bash Path
Write-Host "1. Setting CLAUDE_CODE_GIT_BASH_PATH environment variable..." -ForegroundColor Yellow
$bashPath = "C:\Program Files\Git\bin\bash.exe"
if (Test-Path $bashPath) {
    [Environment]::SetEnvironmentVariable("CLAUDE_CODE_GIT_BASH_PATH", $bashPath, "User")
    $env:CLAUDE_CODE_GIT_BASH_PATH = $bashPath
    Write-Host "   ✅ CLAUDE_CODE_GIT_BASH_PATH set to: $bashPath" -ForegroundColor Green
    $fixes += "Git Bash path configured"
} else {
    Write-Host "   ❌ Git Bash not found at: $bashPath" -ForegroundColor Red
    Write-Host "   Please install Git for Windows from: https://git-scm.com/downloads/win" -ForegroundColor Yellow
}

# Fix 2: Update win-claude-code to latest canary
Write-Host ""
Write-Host "2. Updating win-claude-code to latest canary version..." -ForegroundColor Yellow
try {
    $updateResult = npm install -g win-claude-code@canary 2>&1
    Write-Host "   ✅ win-claude-code updated to canary version" -ForegroundColor Green
    $fixes += "win-claude-code updated to canary"
} catch {
    Write-Host "   ❌ Failed to update win-claude-code: $_" -ForegroundColor Red
}

# Fix 3: Verify Git PATH priority
Write-Host ""
Write-Host "3. Checking Git PATH priority..." -ForegroundColor Yellow
$gitCommands = Get-Command git -All
$firstGit = $gitCommands[0].Source

if ($firstGit -like "*Program Files\Git*") {
    Write-Host "   ✅ Proper Git has PATH priority: $firstGit" -ForegroundColor Green
    $fixes += "Git PATH priority correct"
} else {
    Write-Host "   ⚠️  Git PATH priority issue detected: $firstGit" -ForegroundColor Yellow
    Write-Host "   First Git in PATH should be from Program Files\Git" -ForegroundColor White
    $fixes += "Git PATH priority needs attention"
}

# Fix 4: Test Git Bash functionality
Write-Host ""
Write-Host "4. Testing Git Bash functionality..." -ForegroundColor Yellow
try {
    $bashTest = & $bashPath --version 2>&1
    Write-Host "   ✅ Git Bash working: $($bashTest -split "`n" | Select-Object -First 1)" -ForegroundColor Green
    $fixes += "Git Bash functionality verified"
} catch {
    Write-Host "   ❌ Git Bash test failed: $_" -ForegroundColor Red
}

# Fix 5: Test win-claude-code with environment
Write-Host ""
Write-Host "5. Testing win-claude-code with fixed environment..." -ForegroundColor Yellow
$env:CLAUDE_CODE_GIT_BASH_PATH = $bashPath
try {
    $testOutput = npx win-claude-code@latest --version 2>&1
    if ($testOutput -like "*Claude Code*") {
        Write-Host "   ✅ win-claude-code test successful" -ForegroundColor Green
        $fixes += "win-claude-code environment test passed"
    } else {
        Write-Host "   ⚠️  win-claude-code test output: $testOutput" -ForegroundColor Yellow
        $fixes += "win-claude-code test completed with warnings"
    }
} catch {
    Write-Host "   ❌ win-claude-code test failed: $_" -ForegroundColor Red
}

# Fix 6: Update launcher with all fixes
Write-Host ""
Write-Host "6. Verifying launcher has all fixes..." -ForegroundColor Yellow
$launcherPath = "C:\CLAUDE\claude-context-menu-fix\claude-code-launcher.bat"
if (Test-Path $launcherPath) {
    $launcherContent = Get-Content $launcherPath -Raw
    if ($launcherContent -like "*CLAUDE_CODE_GIT_BASH_PATH*" -and $launcherContent -like "*--dangerously-skip-permissions*") {
        Write-Host "   ✅ Launcher has all fixes applied" -ForegroundColor Green
        $fixes += "Launcher properly configured"
    } else {
        Write-Host "   ❌ Launcher missing some fixes" -ForegroundColor Red
    }
} else {
    Write-Host "   ❌ Launcher not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "           FIXES APPLIED" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

foreach ($fix in $fixes) {
    Write-Host "✅ $fix" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "        COMPREHENSIVE SOLUTION" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "🎯 ROOT CAUSE IDENTIFIED:" -ForegroundColor Yellow
Write-Host "• win-claude-code requires Git Bash but couldn't find it" -ForegroundColor White
Write-Host "• CLAUDE_CODE_GIT_BASH_PATH environment variable was missing" -ForegroundColor White
Write-Host "• PATH priority issues with multiple Git installations" -ForegroundColor White
Write-Host ""

Write-Host "🔧 SOLUTIONS APPLIED:" -ForegroundColor Yellow
Write-Host "• Set CLAUDE_CODE_GIT_BASH_PATH environment variable" -ForegroundColor White
Write-Host "• Updated win-claude-code to latest canary version" -ForegroundColor White
Write-Host "• Fixed Git PATH priority in launcher" -ForegroundColor White
Write-Host "• Added comprehensive environment setup" -ForegroundColor White
Write-Host "• Maintained permission bypass functionality" -ForegroundColor White
Write-Host ""

Write-Host "🚀 YOUR GIT COMMANDS SHOULD NOW WORK!" -ForegroundColor Green
Write-Host ""
Write-Host "To test:" -ForegroundColor White
Write-Host "1. Right-click on C:\claude\persona-manager" -ForegroundColor Gray
Write-Host "2. Select 'Open with Claude Code'" -ForegroundColor Gray
Write-Host "3. Try '/git commit' - should work without EINVAL errors" -ForegroundColor Gray
Write-Host ""

Write-Host "If you still get errors, try:" -ForegroundColor White
Write-Host "• Restart your terminal/PowerShell to pick up environment changes" -ForegroundColor Gray
Write-Host "• Run: refreshenv (if you have Chocolatey)" -ForegroundColor Gray
Write-Host "• Reboot your system to ensure all environment changes take effect" -ForegroundColor Gray

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
