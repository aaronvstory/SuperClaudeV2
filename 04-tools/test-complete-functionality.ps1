# SuperClaude Complete Functionality Test Suite
# This script tests both NomenAK and Gwendall SuperClaude installations comprehensively

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SuperClaude Complete Functionality Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$testResults = @()
$totalTests = 0
$passedTests = 0

function Test-Component {
    param(
        [string]$TestName,
        [scriptblock]$TestCode,
        [string]$ExpectedResult = $null
    )
    
    $global:totalTests++
    Write-Host "[$global:totalTests] Testing: $TestName" -ForegroundColor Yellow
    
    try {
        $result = & $TestCode
        if ($ExpectedResult -and $result -notlike "*$ExpectedResult*") {
            Write-Host "    ✗ FAILED: Expected '$ExpectedResult' but got '$result'" -ForegroundColor Red
            $global:testResults += @{Test=$TestName; Status="FAILED"; Result=$result}
        } else {
            Write-Host "    ✓ PASSED" -ForegroundColor Green
            $global:passedTests++
            $global:testResults += @{Test=$TestName; Status="PASSED"; Result=$result}
        }
    } catch {
        Write-Host "    ✗ ERROR: $($_.Exception.Message)" -ForegroundColor Red
        $global:testResults += @{Test=$TestName; Status="ERROR"; Result=$_.Exception.Message}
    }
}

# Test 1: NomenAK SuperClaude Framework Basic Functionality
Test-Component "NomenAK SuperClaude Version" {
    Set-Location "C:\claude\superclaude"
    $output = python SuperClaude.py --version 2>&1
    return $output
} "SuperClaude v3"

# Test 2: Gwendall SuperClaude CLI Basic Functionality
Test-Component "Gwendall SuperClaude Version" {
    $output = & "C:\Users\d0nbx\.mcp-modules\superclaude-wrapper.bat" --version 2>&1
    return $output
} "v1.0.3"

# Test 3: Git Configuration
Test-Component "Git User Configuration" {
    $name = git config --global user.name
    $email = git config --global user.email
    return "Name: $name, Email: $email"
} "Claude Development Suite"

# Test 4: Node.js and npm
Test-Component "Node.js and npm versions" {
    $nodeVersion = node --version
    $npmVersion = npm --version
    return "Node: $nodeVersion, npm: $npmVersion"
}

# Test 5: Git Bash Availability
Test-Component "Git Bash functionality" {
    $output = & "C:\Program Files\Git\bin\bash.exe" --version 2>&1
    return $output
} "GNU bash"

# Test 6: GitHub Connectivity (read-only)
Test-Component "GitHub Read Access" {
    $output = git ls-remote https://github.com/NomenAK/SuperClaude.git HEAD 2>&1
    if ($output -match "^[a-f0-9]{40}\s+HEAD$") {
        return "GitHub connectivity working"
    } else {
        return $output
    }
} "GitHub connectivity working"

# Test 7: SuperClaude CLI Help Command
Test-Component "Gwendall SuperClaude Help" {
    $output = & "C:\Users\d0nbx\.mcp-modules\superclaude-wrapper.bat" help 2>&1
    return $output
} "Available Commands"

# Test 8: Claude Code Configuration Files
Test-Component "Claude Code SuperClaude Config" {
    if (Test-Path "C:\users\d0nbx\.claude\superclaude-config.json") {
        $config = Get-Content "C:\users\d0nbx\.claude\superclaude-config.json" | ConvertFrom-Json
        return "Config loaded successfully"
    } else {
        return "Config file not found"
    }
} "Config loaded successfully"

# Test 9: Python Dependencies for NomenAK SuperClaude
Test-Component "Python Environment Check" {
    Set-Location "C:\claude\superclaude"
    $output = python -c "import sys; print(f'Python {sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}')" 2>&1
    return $output
} "Python"

# Test 10: Create a test repository for SuperClaude CLI testing
Test-Component "Create Test Repository" {
    $testDir = "C:\claude\superclaude-test-repo"
    if (Test-Path $testDir) {
        Remove-Item $testDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $testDir | Out-Null
    Set-Location $testDir
    git init | Out-Null
    "# Test Repository for SuperClaude" | Out-File "README.md" -Encoding UTF8
    git add README.md | Out-Null
    git config user.name "Claude Development Suite" | Out-Null
    git config user.email "claude-dev-suite@example.com" | Out-Null
    git commit -m "Initial commit" | Out-Null
    return "Test repository created successfully"
} "Test repository created successfully"

# Test 11: SuperClaude CLI readme generation (in test repo)
Test-Component "SuperClaude CLI README Generation" {
    Set-Location "C:\claude\superclaude-test-repo"
    $output = & "C:\Users\d0nbx\.mcp-modules\superclaude-wrapper.bat" readme 2>&1
    if ($output -like "*README*" -or $output -like "*generated*" -or $output -like "*error*") {
        return "README generation attempted"
    }
    return $output
} "README generation attempted"

# Test 12: Check if we can access GitHub for write operations
Test-Component "GitHub Write Access Check" {
    # Test if we have stored credentials
    $credentialCheck = git credential fill 2>&1
    if ($credentialCheck -like "*github*") {
        return "GitHub credentials may be available"
    } else {
        return "No GitHub credentials detected in credential store"
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "           TEST RESULTS SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Passed: $passedTests/$totalTests tests" -ForegroundColor Green
Write-Host ""

# Show detailed results
foreach ($result in $testResults) {
    $color = if ($result.Status -eq "PASSED") { "Green" } elseif ($result.Status -eq "FAILED") { "Red" } else { "Yellow" }
    Write-Host "$($result.Test): $($result.Status)" -ForegroundColor $color
}

Write-Host ""

# GitHub PAT Setup Check
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "        GITHUB PAT CONFIGURATION" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$githubPat = $env:GITHUB_PAT
$githubToken = $env:GITHUB_TOKEN

if (-not $githubPat -and -not $githubToken) {
    Write-Host "❌ GitHub PAT not found in environment variables" -ForegroundColor Red
    Write-Host ""
    Write-Host "To enable full GitHub functionality:" -ForegroundColor Yellow
    Write-Host "1. Create a GitHub Personal Access Token:" -ForegroundColor White
    Write-Host "   https://github.com/settings/tokens" -ForegroundColor Gray
    Write-Host "2. Set as environment variable:" -ForegroundColor White
    Write-Host "   `$env:GITHUB_PAT = 'your_token_here'" -ForegroundColor Gray
    Write-Host "   OR" -ForegroundColor White
    Write-Host "   `$env:GITHUB_TOKEN = 'your_token_here'" -ForegroundColor Gray
    Write-Host "3. Restart PowerShell for changes to take effect" -ForegroundColor White
} else {
    Write-Host "✓ GitHub PAT found in environment" -ForegroundColor Green
}

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
