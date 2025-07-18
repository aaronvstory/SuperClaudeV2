@echo off
REM Ultimate Git Wrapper for win-claude-code
REM Ensures proper environment for git-remote-https

setlocal

REM Set critical Git environment variables
set "GIT_EXEC_PATH=C:\Program Files\Git\mingw64\libexec\git-core"
set "GIT_TEMPLATE_DIR=C:\Program Files\Git\share\git-core\templates"

REM Verify git-remote-https exists before proceeding
if not exist "%GIT_EXEC_PATH%\git-remote-https.exe" (
    echo [ERROR] git-remote-https.exe not found at: %GIT_EXEC_PATH%
    echo [INFO] Checking alternative Git installation paths...
    if exist "C:\Program Files\Git\libexec\git-core\git-remote-https.exe" (
        set "GIT_EXEC_PATH=C:\Program Files\Git\libexec\git-core"
        echo [INFO] Found alternative path: %GIT_EXEC_PATH%
    ) else (
        echo [ERROR] Git installation appears corrupted
        exit /b 1
    )
)

REM Set PATH to prioritize Git directories
set "PATH=C:\Program Files\Git\cmd;C:\Program Files\Git\mingw64\bin;C:\Program Files\Git\mingw64\libexec\git-core;%PATH%"

REM Set additional environment for HTTPS
set "GIT_SSL_NO_VERIFY=false"
set "GIT_CURL_VERBOSE=0"
set "GIT_TERMINAL_PROMPT=0"

REM Use the correct Git executable
set "GIT_EXE=C:\Program Files\Git\cmd\git.exe"

REM Verify Git executable exists
if not exist "%GIT_EXE%" (
    echo [ERROR] Git not found at: %GIT_EXE%
    exit /b 1
)

REM Debug: Show which git-remote-https we're using
if "%1"=="push" (
    echo [DEBUG] Using GIT_EXEC_PATH: %GIT_EXEC_PATH%
    if exist "%GIT_EXEC_PATH%\git-remote-https.exe" (
        echo [DEBUG] git-remote-https.exe found at: %GIT_EXEC_PATH%\git-remote-https.exe
    ) else (
        echo [ERROR] git-remote-https.exe NOT found!
        exit /b 1
    )
    echo [DEBUG] Current PATH: %PATH%
    echo [DEBUG] About to execute: "%GIT_EXE%" %*
)

REM Execute Git with proper environment
"%GIT_EXE%" %*
set "EXIT_CODE=%errorlevel%"

REM Handle specific errors
if %EXIT_CODE% neq 0 (
    if "%1"=="push" (
        echo.
        echo [ERROR] Git push failed (Exit Code: %EXIT_CODE%)
        echo [TIP] Check authentication and network connectivity
    )
)

exit /b %EXIT_CODE%
