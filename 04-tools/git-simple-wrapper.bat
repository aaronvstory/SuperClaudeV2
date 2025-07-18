@echo off
REM Simplified Git Wrapper for win-claude-code
REM Direct execution without complex PATH manipulation

setlocal

REM Set critical Git environment variables
set "GIT_EXEC_PATH=C:\Program Files\Git\mingw64\libexec\git-core"
set "GIT_TEMPLATE_DIR=C:\Program Files\Git\share\git-core\templates"

REM Set additional environment for HTTPS
set "GIT_SSL_NO_VERIFY=false"
set "GIT_CURL_VERBOSE=0"
set "GIT_TERMINAL_PROMPT=0"

REM Set GitHub PAT for authentication (configure during setup)
if not defined GITHUB_PAT (
    echo [WARNING] GITHUB_PAT environment variable not set
    echo [INFO] Configure using: set GITHUB_PAT=your_personal_access_token
)

REM Add Git core to PATH for this session
set "PATH=%GIT_EXEC_PATH%;%PATH%"

REM Use the correct Git executable
set "GIT_EXE=C:\Program Files\Git\cmd\git.exe"

REM Verify Git executable exists
if not exist "%GIT_EXE%" (
    echo [ERROR] Git not found at: %GIT_EXE%
    exit /b 1
)

REM Verify git-remote-https exists
if not exist "%GIT_EXEC_PATH%\git-remote-https.exe" (
    echo [ERROR] git-remote-https.exe not found at: %GIT_EXEC_PATH%
    exit /b 1
)

REM Debug info for push operations
if "%1"=="push" (
    echo [DEBUG] Git executable: %GIT_EXE%
    echo [DEBUG] Git exec path: %GIT_EXEC_PATH%
    echo [DEBUG] git-remote-https: %GIT_EXEC_PATH%\git-remote-https.exe
)

REM Execute Git with proper environment using Git Bash for HTTPS operations
if "%1"=="push" (
    "C:\Program Files\Git\bin\bash.exe" -c "export GIT_EXEC_PATH='/c/Program Files/Git/mingw64/libexec/git-core' && git push"
    set "EXIT_CODE=%errorlevel%"
) else if "%1"=="pull" (
    "C:\Program Files\Git\bin\bash.exe" -c "export GIT_EXEC_PATH='/c/Program Files/Git/mingw64/libexec/git-core' && git %*"
    set "EXIT_CODE=%errorlevel%"
) else if "%1"=="fetch" (
    "C:\Program Files\Git\bin\bash.exe" -c "export GIT_EXEC_PATH='/c/Program Files/Git/mingw64/libexec/git-core' && git %*"
    set "EXIT_CODE=%errorlevel%"
) else if "%1"=="clone" (
    "C:\Program Files\Git\bin\bash.exe" -c "export GIT_EXEC_PATH='/c/Program Files/Git/mingw64/libexec/git-core' && git %*"
    set "EXIT_CODE=%errorlevel%"
) else (
    "%GIT_EXE%" %*
    set "EXIT_CODE=%errorlevel%"
)

if %EXIT_CODE% neq 0 (
    if "%1"=="push" (
        echo.
        echo [ERROR] Git push failed (Exit Code: %EXIT_CODE%)
        echo [TIP] If you see 'remote-https' error, the Git installation may need repair
    )
)

exit /b %EXIT_CODE%
