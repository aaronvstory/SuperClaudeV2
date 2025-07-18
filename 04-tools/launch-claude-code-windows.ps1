# Windows Claude Code PowerShell Launcher
# This ensures you always use win-claude-code instead of native claude-code

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    Windows Claude Code Launcher" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Node.js
try {
    $nodeVersion = node --version
    Write-Host "✓ Node.js version: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found. Please install from: https://nodejs.org/" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Check win-claude-code
try {
    Write-Host "Checking win-claude-code installation..." -ForegroundColor Yellow
    $output = npm list -g win-claude-code 2>&1
    if ($output -like "*win-claude-code*") {
        Write-Host "✓ win-claude-code is installed" -ForegroundColor Green
    } else {
        Write-Host "Installing win-claude-code..." -ForegroundColor Yellow
        npm install -g win-claude-code@latest
    }
} catch {
    Write-Host "❌ Error checking win-claude-code installation" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "🚀 Starting Windows Claude Code (native Windows support)..." -ForegroundColor Green
Write-Host "This bypasses WSL and provides proper Windows Git integration." -ForegroundColor White
Write-Host ""

# Launch win-claude-code
try {
    npx win-claude-code@latest
} catch {
    Write-Host ""
    Write-Host "❌ Error launching win-claude-code" -ForegroundColor Red
    Write-Host "You might be running the native Anthropic claude-code instead." -ForegroundColor Yellow
    Write-Host "Make sure to use this launcher script to ensure Windows compatibility." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Claude Code session ended." -ForegroundColor Gray
Read-Host "Press Enter to exit"
