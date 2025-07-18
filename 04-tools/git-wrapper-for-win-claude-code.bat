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
