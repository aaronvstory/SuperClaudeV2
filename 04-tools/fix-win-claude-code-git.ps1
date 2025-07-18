# Win-Claude-Code Git Integration Fix
# This script fixes Git HTTPS issues specifically for win-claude-code

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Win-Claude-Code Git Integration Fix" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$fixesApplied = @()

# Step 1: Fix Git PATH and executable detection
Write-Host "1. Fixing Git PATH and executable detection..." -ForegroundColor Yellow

# Remove problematic git.bat from System32 if it exists
$gitBat = "C:\Windows\System32\git.bat"
if (Test-Path $gitBat) {
    Write-Host "   Removing problematic git.bat from System32..." -ForegroundColor White
    try {
        Remove-Item $gitBat -Force
        Write-Host "   ✓ Removed problematic git.bat" -ForegroundColor Green
        $fixesApplied += "Removed System32 git.bat"
    } catch {
        Write-Host "   ❌ Failed to remove git.bat (may need admin)" -ForegroundColor Red
    }
}

# Ensure proper Git is in PATH
$gitPaths = @(
    "C:\Program Files\Git\cmd",
    "C:\Program Files\Git\bin"
)

$currentPath = $env:PATH
$pathUpdated = $false

foreach ($gitPath in $gitPaths) {
    if ((Test-Path $gitPath) -and ($currentPath -notlike "*$gitPath*")) {
        $env:PATH = "$gitPath;$env:PATH"
        $pathUpdated = $true
        Write-Host "   ✓ Added $gitPath to PATH" -ForegroundColor Green
    }
}

if ($pathUpdated) {
    # Update machine PATH permanently
    $machinePath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    foreach ($gitPath in $gitPaths) {
        if ((Test-Path $gitPath) -and ($machinePath -notlike "*$gitPath*")) {
            $machinePath = "$gitPath;$machinePath"
        }
    }
    [Environment]::SetEnvironmentVariable("PATH", $machinePath, "Machine")
    $fixesApplied += "Updated system PATH for Git"
}

# Step 2: Configure Git for HTTPS operation
Write-Host "2. Configuring Git for HTTPS operation..." -ForegroundColor Yellow

# Test current Git executable
try {
    $gitVersion = & "C:\Program Files\Git\cmd\git.exe" --version 2>$null
    Write-Host "   ✓ Git executable working: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Git executable not working" -ForegroundColor Red
    exit 1
}

# Configure Git settings for win-claude-code compatibility
$gitConfigs = @{
    "credential.helper" = "manager-core"
    "http.sslBackend" = "schannel"
    "http.sslVerify" = "true"
    "core.autocrlf" = "true"
    "core.longpaths" = "true"
    "user.name" = "Claude Development Suite"
    "user.email" = "claude-dev-suite@example.com"
}

foreach ($config in $gitConfigs.GetEnumerator()) {
    try {
        & "C:\Program Files\Git\cmd\git.exe" config --global $config.Key $config.Value
        Write-Host "   ✓ Set $($config.Key) = $($config.Value)" -ForegroundColor Green
    } catch {
        Write-Host "   ❌ Failed to set $($config.Key)" -ForegroundColor Red
    }
}

$fixesApplied += "Configured Git settings"

# Step 3: Create win-claude-code Git environment wrapper
Write-Host "3. Creating win-claude-code Git environment..." -ForegroundColor Yellow

$gitWrapper = @"
@echo off
REM Git Wrapper specifically for win-claude-code
REM Ensures proper environment and authentication

setlocal

REM Set Git executable path
set "GIT_EXE=C:\Program Files\Git\cmd\git.exe"

REM Set environment for HTTPS operations
set "GIT_SSL_NO_VERIFY=false"
set "GIT_CURL_VERBOSE=0"
set "GIT_TERMINAL_PROMPT=0"

REM Ensure credential helper is available
set "GIT_CONFIG_GLOBAL=C:\Users\%USERNAME%\.gitconfig"

REM Check if Git executable exists
if not exist "%GIT_EXE%" (
    echo [ERROR] Git not found at: %GIT_EXE%
    echo Please install Git for Windows from: https://git-scm.com/download/win
    exit /b 1
)

REM Execute Git with proper environment
"%GIT_EXE%" %*
set "GIT_EXIT_CODE=%errorlevel%"

REM Handle authentication errors
if %GIT_EXIT_CODE% neq 0 (
    if "%1"=="push" (
        echo.
        echo [INFO] Git push failed. This might be an authentication issue.
        echo [TIP] Consider using the automated push script or setting up credentials.
    )
)

exit /b %GIT_EXIT_CODE%
"@

$wrapperPath = "C:\claude\superclaude-tools\git-wrapper-for-win-claude-code.bat"
$gitWrapper | Out-File -FilePath $wrapperPath -Encoding ASCII
Write-Host "   ✓ Created Git wrapper at $wrapperPath" -ForegroundColor Green
$fixesApplied += "Created Git wrapper"

# Step 4: Configure win-claude-code to use the wrapper
Write-Host "4. Configuring win-claude-code environment..." -ForegroundColor Yellow

# Check if we can find win-claude-code configuration
$winClaudeConfig = "$env:USERPROFILE\.claude"
if (Test-Path $winClaudeConfig) {
    # Create win-claude-code specific Git configuration
    $winClaudeGitConfig = @"
{
  "git": {
    "executable": "C:\\Program Files\\Git\\cmd\\git.exe",
    "wrapper": "C:\\claude\\superclaude-tools\\git-wrapper-for-win-claude-code.bat",
    "environment": {
      "GIT_TERMINAL_PROMPT": "0",
      "GIT_SSL_NO_VERIFY": "false",
      "GIT_CURL_VERBOSE": "0"
    },
    "credential_helper": "manager-core"
  }
}
"@
    
    $configPath = "$winClaudeConfig\git-config.json"
    $winClaudeGitConfig | Out-File -FilePath $configPath -Encoding UTF8
    Write-Host "   ✓ Created win-claude-code Git configuration" -ForegroundColor Green
    $fixesApplied += "Configured win-claude-code Git settings"
}

# Step 5: Test Git operations
Write-Host "5. Testing Git operations..." -ForegroundColor Yellow

# Test basic Git functionality
try {
    $gitStatus = & "C:\Program Files\Git\cmd\git.exe" --version
    Write-Host "   ✓ Basic Git command: $gitStatus" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Basic Git command failed" -ForegroundColor Red
}

# Test HTTPS connectivity
try {
    $httpsTest = & "C:\Program Files\Git\cmd\git.exe" ls-remote https://github.com/microsoft/vscode.git HEAD 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ HTTPS Git operations working" -ForegroundColor Green
        $fixesApplied += "Verified HTTPS operations"
    } else {
        Write-Host "   ⚠️  HTTPS Git operations need authentication setup" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ❌ HTTPS Git test failed" -ForegroundColor Red
}

# Step 6: Create GitHub authentication helper
Write-Host "6. Creating GitHub authentication helper..." -ForegroundColor Yellow

$githubAuthHelper = @"
# GitHub Authentication Helper for win-claude-code
# This script helps set up GitHub PAT for seamless operations

Write-Host "GitHub Authentication Setup for win-claude-code" -ForegroundColor Cyan
Write-Host ""

# Check if GitHub PAT is already configured
`$githubPat = `$env:GITHUB_PAT
`$githubToken = `$env:GITHUB_TOKEN

if (-not `$githubPat -and -not `$githubToken) {
    Write-Host "No GitHub Personal Access Token (PAT) found." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To set up GitHub authentication:" -ForegroundColor White
    Write-Host "1. Go to: https://github.com/settings/tokens" -ForegroundColor Gray
    Write-Host "2. Generate new token (classic)" -ForegroundColor Gray
    Write-Host "3. Select scopes: repo, workflow" -ForegroundColor Gray
    Write-Host "4. Copy the token" -ForegroundColor Gray
    Write-Host ""
    
    `$token = Read-Host "Paste your GitHub PAT here (or press Enter to skip)"
    
    if (`$token) {
        # Set as user environment variable
        [Environment]::SetEnvironmentVariable("GITHUB_PAT", `$token, "User")
        `$env:GITHUB_PAT = `$token
        
        Write-Host "✓ GitHub PAT configured!" -ForegroundColor Green
        Write-Host "You may need to restart applications to use the new token." -ForegroundColor Yellow
        
        # Test the token
        try {
            `$headers = @{ "Authorization" = "token `$token" }
            `$test = Invoke-RestMethod -Uri "https://api.github.com/user" -Headers `$headers
            Write-Host "✓ Token verified for user: `$(`$test.login)" -ForegroundColor Green
        } catch {
            Write-Host "❌ Token verification failed" -ForegroundColor Red
        }
    }
} else {
    `$token = if (`$githubPat) { `$githubPat } else { `$githubToken }
    Write-Host "✓ GitHub PAT already configured" -ForegroundColor Green
    
    # Test the existing token
    try {
        `$headers = @{ "Authorization" = "token `$token" }
        `$test = Invoke-RestMethod -Uri "https://api.github.com/user" -Headers `$headers
        Write-Host "✓ Token verified for user: `$(`$test.login)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Existing token verification failed" -ForegroundColor Red
        Write-Host "You may need to update your GitHub PAT" -ForegroundColor Yellow
    }
}
"@

$authHelperPath = "C:\claude\superclaude-tools\setup-github-auth.ps1"
$githubAuthHelper | Out-File -FilePath $authHelperPath -Encoding UTF8
Write-Host "   ✓ Created GitHub authentication helper" -ForegroundColor Green
$fixesApplied += "Created GitHub auth helper"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "           FIX SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

foreach ($fix in $fixesApplied) {
    Write-Host "✓ $fix" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎯 NEXT STEPS:" -ForegroundColor Yellow
Write-Host "1. Restart your terminal/PowerShell session" -ForegroundColor White
Write-Host "2. Run: C:\claude\superclaude-tools\setup-github-auth.ps1" -ForegroundColor White
Write-Host "3. Test win-claude-code with /git commands" -ForegroundColor White
Write-Host ""
Write-Host "🔧 TESTING:" -ForegroundColor Yellow
Write-Host "• Use right-click menu to launch Claude Code" -ForegroundColor White
Write-Host "• Try /git status in a repository" -ForegroundColor White
Write-Host "• Try /git commit if you have changes" -ForegroundColor White
Write-Host ""

Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
