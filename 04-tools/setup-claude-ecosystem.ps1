# Super Claude Ecosystem PowerShell Installer
# Complete installation and configuration script
# Version: 1.0.0

param(
    [switch]$SkipPrerequisites,
    [switch]$QuietMode
)

# Set up error handling
$ErrorActionPreference = "Stop"

# Color functions
function Write-Success { param($Message) Write-Host $Message -ForegroundColor Green }
function Write-Warning { param($Message) Write-Host $Message -ForegroundColor Yellow }
function Write-Error { param($Message) Write-Host $Message -ForegroundColor Red }
function Write-Info { param($Message) Write-Host $Message -ForegroundColor Cyan }
function Write-Step { param($Step, $Message) Write-Host "[$Step] $Message" -ForegroundColor White }

# Installation state tracking
$InstallationState = @{
    Steps = @()
    Errors = @()
    Warnings = @()
    StartTime = Get-Date
}

function Add-InstallStep {
    param($Step, $Status, $Details = "")
    $InstallationState.Steps += @{
        Step = $Step
        Status = $Status
        Details = $Details
        Timestamp = Get-Date
    }
}

function Show-Header {
    Clear-Host
    Write-Host "===============================================================================" -ForegroundColor Cyan
    Write-Host "              SUPER CLAUDE ECOSYSTEM INSTALLER v1.0.0" -ForegroundColor Cyan
    Write-Host "===============================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Installing complete Claude Code ecosystem with:" -ForegroundColor White
    Write-Host "• win-claude-code (Windows-native wrapper)" -ForegroundColor Gray
    Write-Host "• NomenAK SuperClaude Framework (15 commands + 11 personas)" -ForegroundColor Gray
    Write-Host "• Gwendall SuperClaude CLI (GitHub automation)" -ForegroundColor Gray
    Write-Host "• Right-click context menu integration" -ForegroundColor Gray
    Write-Host "• 4 MCP servers (Context7, Sequential, Magic, Playwright)" -ForegroundColor Gray
    Write-Host ""
}

Show-Header

try {
    # Step 1: Prerequisites Check
    Write-Step "1/12" "Checking Prerequisites"
    
    if (-not $SkipPrerequisites) {
        # Check Windows version
        $windowsVersion = [Environment]::OSVersion.Version
        if ($windowsVersion.Major -lt 10) {
            throw "Windows 10 or later is required. Current version: $($windowsVersion)"
        }
        Write-Success "   ✓ Windows 10+ confirmed"
        
        # Check PowerShell version
        if ($PSVersionTable.PSVersion.Major -lt 5) {
            throw "PowerShell 5.0 or later is required. Current version: $($PSVersionTable.PSVersion)"
        }
        Write-Success "   ✓ PowerShell 5.0+ confirmed"
        
        # Check if running as Administrator
        $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
        if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            throw "Administrator privileges required. Please run as Administrator."
        }
        Write-Success "   ✓ Administrator privileges confirmed"
        
        # Check internet connectivity
        try {
            $null = Invoke-WebRequest -Uri "https://www.google.com" -TimeoutSec 10 -UseBasicParsing
            Write-Success "   ✓ Internet connectivity confirmed"
        } catch {
            throw "Internet connection required for downloading packages"
        }
    }
    
    Add-InstallStep "Prerequisites" "SUCCESS"
    
    # Step 2: Install Node.js (if needed)
    Write-Step "2/12" "Installing Node.js"
    
    try {
        $nodeVersion = node --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Success "   ✓ Node.js already installed: $nodeVersion"
        } else {
            throw "Node.js not found"
        }
    } catch {
        Write-Info "   Installing Node.js..."
        Write-Warning "   Node.js not found. Please install Node.js manually from: https://nodejs.org/"
        Write-Warning "   After installing Node.js, rerun this installer."
        Add-InstallStep "Node.js" "MANUAL_REQUIRED" "Please install from nodejs.org"
        throw "Node.js installation required"
    }
    
    Add-InstallStep "Node.js" "SUCCESS"
    
    # Step 3: Install Git for Windows (if needed)
    Write-Step "3/12" "Installing Git for Windows"
    
    try {
        $gitVersion = git --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Success "   ✓ Git already installed: $gitVersion"
        } else {
            throw "Git not found"
        }
    } catch {
        Write-Warning "   Git not found. Please install Git for Windows manually from: https://git-scm.com/download/win"
        Write-Warning "   After installing Git, rerun this installer."
        Add-InstallStep "Git" "MANUAL_REQUIRED" "Please install from git-scm.com"
        throw "Git installation required"
    }
    
    Add-InstallStep "Git" "SUCCESS"
    
    # Step 4: Create directory structure
    Write-Step "4/12" "Creating Directory Structure"
    
    $directories = @(
        "C:\claude",
        "C:\claude\superclaude-tools",
        "C:\claude\claude-context-menu-fix"
    )
    
    foreach ($dir in $directories) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Write-Success "   ✓ Created: $dir"
        } else {
            Write-Success "   ✓ Exists: $dir"
        }
    }
    
    Add-InstallStep "Directory Structure" "SUCCESS"
    
    # Step 5: Install Claude Code Core
    Write-Step "5/12" "Installing Claude Code Core"
    
    try {
        $existingClaude = npm list -g @anthropic-ai/claude-code 2>$null
        if ($existingClaude -like "*@anthropic-ai/claude-code*") {
            Write-Success "   ✓ Claude Code already installed"
        } else {
            Write-Info "   Installing @anthropic-ai/claude-code..."
            npm install -g @anthropic-ai/claude-code --ignore-scripts
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to install @anthropic-ai/claude-code"
            }
            Write-Success "   ✓ Claude Code core installed"
        }
    } catch {
        Add-InstallStep "Claude Code Core" "FAILED" $_.Exception.Message
        throw
    }
    
    Add-InstallStep "Claude Code Core" "SUCCESS"
    
    # Step 6: Install win-claude-code
    Write-Step "6/12" "Installing win-claude-code"
    
    try {
        $existingWinClaude = npm list -g win-claude-code 2>$null
        if ($existingWinClaude -like "*win-claude-code*") {
            Write-Info "   Updating win-claude-code to latest version..."
            npm install -g win-claude-code@latest
        } else {
            Write-Info "   Installing win-claude-code..."
            npm install -g win-claude-code@latest
        }
        
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to install win-claude-code"
        }
        
        # Test win-claude-code
        $winClaudeVersion = npx win-claude-code@latest --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Success "   ✓ win-claude-code installed and working: $winClaudeVersion"
        } else {
            throw "win-claude-code installation verification failed"
        }
    } catch {
        Add-InstallStep "win-claude-code" "FAILED" $_.Exception.Message
        throw
    }
    
    Add-InstallStep "win-claude-code" "SUCCESS"
    
    # Step 7: Install Gwendall SuperClaude CLI
    Write-Step "7/12" "Installing Gwendall SuperClaude CLI"
    
    try {
        $existingSuperclaude = npm list -g superclaude 2>$null
        if ($existingSuperclaude -like "*superclaude*") {
            Write-Info "   Updating superclaude to latest version..."
            npm install -g superclaude@latest
        } else {
            Write-Info "   Installing superclaude..."
            npm install -g superclaude@latest
        }
        
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to install superclaude"
        }
        
        Write-Success "   ✓ Gwendall SuperClaude CLI installed"
    } catch {
        Add-InstallStep "Gwendall SuperClaude" "FAILED" $_.Exception.Message
        throw
    }
    
    Add-InstallStep "Gwendall SuperClaude" "SUCCESS"
    
    # Step 8: Clone NomenAK SuperClaude Framework
    Write-Step "8/12" "Installing NomenAK SuperClaude Framework"
    
    try {
        $superclaudeDir = "C:\claude\superclaude"
        
        if (Test-Path $superclaudeDir) {
            Write-Info "   Updating existing NomenAK SuperClaude..."
            Set-Location $superclaudeDir
            git pull origin main
        } else {
            Write-Info "   Cloning NomenAK SuperClaude from GitHub..."
            Set-Location "C:\claude"
            git clone https://github.com/NomenAK/SuperClaude.git superclaude
        }
        
        if (-not (Test-Path "$superclaudeDir\SuperClaude.py")) {
            throw "NomenAK SuperClaude installation verification failed"
        }
        
        Write-Success "   ✓ NomenAK SuperClaude Framework installed"
    } catch {
        Add-InstallStep "NomenAK SuperClaude" "FAILED" $_.Exception.Message
        throw
    }
    
    Add-InstallStep "NomenAK SuperClaude" "SUCCESS"
    
    # Step 9: Create Gwendall SuperClaude Windows Wrapper
    Write-Step "9/12" "Creating SuperClaude Windows Wrapper"
    
    try {
        $wrapperPath = "$env:USERPROFILE\.mcp-modules"
        if (-not (Test-Path $wrapperPath)) {
            New-Item -ItemType Directory -Path $wrapperPath -Force | Out-Null
        }
        
        $wrapperScript = @"
@echo off
REM SuperClaude Windows Wrapper
REM This wrapper enables gwendall's SuperClaude CLI tool to work on Windows

set "SUPERCLAUDE_PATH=$env:USERPROFILE\.mcp-modules\node_modules\superclaude\bin\superclaude"
set "GIT_BASH=C:\Program Files\Git\bin\bash.exe"

REM Check if Git Bash exists
if not exist "%GIT_BASH%" (
    echo [ERROR] Git Bash not found at "%GIT_BASH%"
    echo Please install Git for Windows from: https://git-scm.com/download/win
    exit /b 1
)

REM Check if SuperClaude script exists
if not exist "%SUPERCLAUDE_PATH%" (
    echo [ERROR] SuperClaude not found. Please install with: npm install -g superclaude
    exit /b 1
)

REM Convert Windows path to Unix path for Git Bash
set "UNIX_PATH=/c/Users/$env:USERNAME/.mcp-modules/node_modules/superclaude/bin/superclaude"

REM Run SuperClaude through Git Bash
"%GIT_BASH%" -c "%UNIX_PATH% %*"
"@
        
        $wrapperScript | Out-File -FilePath "$wrapperPath\superclaude-wrapper.bat" -Encoding ASCII
        Write-Success "   ✓ SuperClaude Windows wrapper created"
    } catch {
        Add-InstallStep "SuperClaude Wrapper" "FAILED" $_.Exception.Message
        throw
    }
    
    Add-InstallStep "SuperClaude Wrapper" "SUCCESS"
    
    # Step 10: Create Context Menu Launcher
    Write-Step "10/12" "Creating Context Menu Launcher"
    
    try {
        $launcherPath = "C:\claude\claude-context-menu-fix\claude-code-launcher.bat"
        $launcherScript = @"
@echo off
REM Claude Code Windows-Compatible Launcher with Permission Bypass
REM Updated to use proper win-claude-code for native Windows support
REM This fixes Git EINVAL errors and provides full Windows compatibility
REM Includes --dangerously-skip-permissions for seamless operation

setlocal enabledelayedexpansion

REM Get the directory passed as parameter (from context menu)
set "TARGET_DIR=%~1"
if "%TARGET_DIR%"=="" set "TARGET_DIR=%cd%"

REM Change to the target directory
cd /d "%TARGET_DIR%"

REM Set window title with version info
title Windows Claude Code (Permission Bypass) - %TARGET_DIR%

echo ========================================
echo    Windows Claude Code Launcher
echo    (Permission Bypass Mode)
echo ========================================
echo.
echo Target Directory: %TARGET_DIR%
echo Using: win-claude-code (Windows Native)
echo Permission Mode: Bypass all permission checks
echo.

REM Check if Node.js is available
node --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js not found. Please install Node.js from:
    echo         https://nodejs.org/
    echo.
    pause
    exit /b 1
)

REM Launch win-claude-code with permission bypass (Windows-compatible version)
echo [INFO] Starting Windows Claude Code with permission bypass...
echo [INFO] This version provides native Windows Git support.
echo [INFO] All permission checks are bypassed for seamless operation.
echo.

npx win-claude-code@latest --dangerously-skip-permissions

REM Keep window open if there's an error
if errorlevel 1 (
    echo.
    echo [ERROR] Claude Code encountered an error.
    echo [INFO] You might need to update win-claude-code:
    echo         npm install -g win-claude-code@latest
    echo.
    pause
)

endlocal
"@
        
        $launcherScript | Out-File -FilePath $launcherPath -Encoding ASCII
        Write-Success "   ✓ Context menu launcher created"
    } catch {
        Add-InstallStep "Context Menu Launcher" "FAILED" $_.Exception.Message
        throw
    }
    
    Add-InstallStep "Context Menu Launcher" "SUCCESS"
    
    # Step 11: Install Registry Entries for Context Menu
    Write-Step "11/12" "Installing Registry Entries"
    
    try {
        # Find Windows Terminal path
        $wtPaths = @(
            "C:\Users\$env:USERNAME\AppData\Local\Microsoft\WindowsApps\wt.exe",
            "C:\Program Files\WindowsApps\Microsoft.WindowsTerminal*\wt.exe",
            "wt.exe"
        )
        
        $wtPath = $null
        foreach ($path in $wtPaths) {
            if ($path -eq "wt.exe") {
                try {
                    $null = Get-Command wt.exe -ErrorAction Stop
                    $wtPath = "wt.exe"
                    break
                } catch { continue }
            } elseif (Test-Path $path) {
                $wtPath = $path
                break
            }
        }
        
        if (-not $wtPath) {
            $wtPath = "cmd.exe"
            Write-Warning "   Windows Terminal not found, using cmd.exe"
        } else {
            Write-Success "   ✓ Found Windows Terminal: $wtPath"
        }
        
        # Registry entries for directory context menu
        $regCommand = if ($wtPath -eq "wt.exe" -or $wtPath -like "*wt.exe") {
            "`"$wtPath`" -d `"%1`" cmd /k `"`"`"C:\claude\claude-context-menu-fix\claude-code-launcher.bat`"`" `"`"%1`"`"`""
        } else {
            "`"$wtPath`" /k cd /d `"%1`" && `"C:\claude\claude-context-menu-fix\claude-code-launcher.bat`" `"%1`""
        }
        
        # Create registry entries
        $regPaths = @(
            "HKLM:\SOFTWARE\Classes\Directory\shell\OpenClaudeCode",
            "HKLM:\SOFTWARE\Classes\Directory\Background\shell\OpenClaudeCode"
        )
        
        foreach ($regPath in $regPaths) {
            if (-not (Test-Path $regPath)) {
                New-Item -Path $regPath -Force | Out-Null
            }
            Set-ItemProperty -Path $regPath -Name "(default)" -Value "Open with Claude Code"
            Set-ItemProperty -Path $regPath -Name "Icon" -Value "C:\Program Files\nodejs\node.exe,0"
            
            $commandPath = "$regPath\command"
            if (-not (Test-Path $commandPath)) {
                New-Item -Path $commandPath -Force | Out-Null
            }
            
            if ($regPath -like "*Background*") {
                $bgCommand = $regCommand -replace '"%1"', '"%V"'
                Set-ItemProperty -Path $commandPath -Name "(default)" -Value $bgCommand
            } else {
                Set-ItemProperty -Path $commandPath -Name "(default)" -Value $regCommand
            }
        }
        
        Write-Success "   ✓ Registry entries installed"
    } catch {
        Add-InstallStep "Registry Entries" "FAILED" $_.Exception.Message
        throw
    }
    
    Add-InstallStep "Registry Entries" "SUCCESS"
    
    # Step 12: Create Verification and Management Tools
    Write-Step "12/12" "Creating Management Tools"
    
    try {
        # Create verification script
        $verificationScript = @"
# Quick Claude Code Ecosystem Verification
Write-Host "Claude Code Ecosystem Status:" -ForegroundColor Cyan
Write-Host ""

# Check win-claude-code
try {
    `$version = npx win-claude-code@latest --version 2>`$null
    if (`$LASTEXITCODE -eq 0) {
        Write-Host "✓ win-claude-code: Working (`$version)" -ForegroundColor Green
    } else {
        Write-Host "❌ win-claude-code: Not working" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ win-claude-code: Error testing" -ForegroundColor Red
}

# Check NomenAK SuperClaude
if (Test-Path "C:\claude\superclaude\SuperClaude.py") {
    Write-Host "✓ NomenAK SuperClaude: Installed" -ForegroundColor Green
} else {
    Write-Host "❌ NomenAK SuperClaude: Missing" -ForegroundColor Red
}

# Check context menu
try {
    `$regCheck = Get-ItemProperty "HKLM:\SOFTWARE\Classes\Directory\shell\OpenClaudeCode\command" -Name "(default)" -ErrorAction Stop
    Write-Host "✓ Context Menu: Installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Context Menu: Missing" -ForegroundColor Red
}

# Check Gwendall SuperClaude
try {
    `$superclaudeCheck = npm list -g superclaude 2>`$null
    if (`$superclaudeCheck -like "*superclaude*") {
        Write-Host "✓ Gwendall SuperClaude: Installed" -ForegroundColor Green
    } else {
        Write-Host "❌ Gwendall SuperClaude: Missing" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Gwendall SuperClaude: Error checking" -ForegroundColor Red
}

Write-Host ""
Write-Host "Ready to use! Right-click any folder and select 'Open with Claude Code'" -ForegroundColor Yellow
"@
        
        $verificationScript | Out-File -FilePath "C:\claude\superclaude-tools\quick-verify.ps1" -Encoding UTF8
        
        # Create desktop shortcut
        $shell = New-Object -ComObject WScript.Shell
        $desktopPath = [Environment]::GetFolderPath("Desktop")
        $shortcut = $shell.CreateShortcut("$desktopPath\Claude Code Ecosystem.lnk")
        $shortcut.TargetPath = "powershell.exe"
        $shortcut.Arguments = "-ExecutionPolicy Bypass -File `"C:\claude\superclaude-tools\quick-verify.ps1`""
        $shortcut.Description = "Claude Code Ecosystem Status Check"
        $shortcut.Save()
        
        Write-Success "   ✓ Management tools created"
        Write-Success "   ✓ Desktop shortcut created"
    } catch {
        Add-InstallStep "Management Tools" "FAILED" $_.Exception.Message
        throw
    }
    
    Add-InstallStep "Management Tools" "SUCCESS"
    
    # Installation completed successfully
    $endTime = Get-Date
    $duration = $endTime - $InstallationState.StartTime
    
    Write-Host ""
    Write-Host "===============================================================================" -ForegroundColor Green
    Write-Host "                    INSTALLATION COMPLETED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "===============================================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎉 Super Claude Ecosystem v1.0.0 installed in $($duration.Minutes)m $($duration.Seconds)s" -ForegroundColor Green
    Write-Host ""
    Write-Host "✅ INSTALLED COMPONENTS:" -ForegroundColor White
    Write-Host "   • win-claude-code (Windows-native Claude Code)" -ForegroundColor Gray
    Write-Host "   • NomenAK SuperClaude Framework (15 commands + 11 personas)" -ForegroundColor Gray
    Write-Host "   • Gwendall SuperClaude CLI (GitHub workflow automation)" -ForegroundColor Gray
    Write-Host "   • Right-click context menu integration" -ForegroundColor Gray
    Write-Host "   • Permission bypass configuration" -ForegroundColor Gray
    Write-Host "   • Verification and management tools" -ForegroundColor Gray
    Write-Host ""
    Write-Host "🚀 READY TO USE:" -ForegroundColor Yellow
    Write-Host "   1. Right-click on any folder" -ForegroundColor White
    Write-Host "   2. Select 'Open with Claude Code'" -ForegroundColor White
    Write-Host "   3. Try commands like: /analyze, /improve, @architect" -ForegroundColor White
    Write-Host ""
    Write-Host "📁 MANAGEMENT TOOLS:" -ForegroundColor Yellow
    Write-Host "   • Desktop: 'Claude Code Ecosystem' shortcut for status check" -ForegroundColor White
    Write-Host "   • Folder: C:\claude\superclaude-tools\ for all tools" -ForegroundColor White
    Write-Host ""
    Write-Host "For documentation and troubleshooting, see the comprehensive guide." -ForegroundColor Gray
    
} catch {
    $errorMsg = $_.Exception.Message
    Write-Host ""
    Write-Host "===============================================================================" -ForegroundColor Red
    Write-Host "                         INSTALLATION FAILED" -ForegroundColor Red
    Write-Host "===============================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "❌ Error: $errorMsg" -ForegroundColor Red
    Write-Host ""
    Write-Host "📋 INSTALLATION PROGRESS:" -ForegroundColor Yellow
    foreach ($step in $InstallationState.Steps) {
        $status = switch ($step.Status) {
            "SUCCESS" { "✓" }
            "FAILED" { "❌" }
            "MANUAL_REQUIRED" { "⚠️" }
            default { "?" }
        }
        $color = switch ($step.Status) {
            "SUCCESS" { "Green" }
            "FAILED" { "Red" }
            "MANUAL_REQUIRED" { "Yellow" }
            default { "Gray" }
        }
        Write-Host "   $status $($step.Step)" -ForegroundColor $color
        if ($step.Details) {
            Write-Host "     $($step.Details)" -ForegroundColor Gray
        }
    }
    Write-Host ""
    Write-Host "💡 TROUBLESHOOTING:" -ForegroundColor Yellow
    Write-Host "   • Ensure you're running as Administrator" -ForegroundColor White
    Write-Host "   • Check internet connection" -ForegroundColor White
    Write-Host "   • Install missing prerequisites manually" -ForegroundColor White
    Write-Host "   • Rerun installer after fixing issues" -ForegroundColor White
    
    exit 1
}
