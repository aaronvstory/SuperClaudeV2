# Git Remote-HTTPS Helper Fix

## Problem
Git returns error: `git: 'remote-https' is not a git command. See 'git --help'. fatal: remote helper 'https' aborted session`

## Root Cause
The `GIT_EXEC_PATH` environment variable is pointing to an incorrect or non-existent directory, preventing git from finding the remote helper executables.

## Solution

### Immediate Fix
```bash
export GIT_EXEC_PATH="/c/Program Files/Git/mingw64/libexec/git-core"
```

### Permanent Fix

#### 1. Bash/Git Bash
```bash
echo 'export GIT_EXEC_PATH="/c/Program Files/Git/mingw64/libexec/git-core"' >> ~/.bashrc
```

#### 2. Windows Environment Variable
```powershell
[Environment]::SetEnvironmentVariable("GIT_EXEC_PATH", "C:\Program Files\Git\mingw64\libexec\git-core", "User")
```

#### 3. Verification
```bash
# Check if helpers exist
ls -la "/c/Program Files/Git/mingw64/libexec/git-core/git-remote-http*"

# Test git operations
git push origin main  # Should work now
```

## Prevention
- Always check `git --exec-path` after git reinstallation
- Add GIT_EXEC_PATH to both bash profile and Windows environment variables
- This fix should be automatically applied when encountering the error

## Technical Details
- Git remote helpers are located in: `C:\Program Files\Git\mingw64\libexec\git-core`
- The incorrect path is usually: `C:\Program Files\Git\libexec\git-core` (missing mingw64)
- Required helpers: `git-remote-http.exe`, `git-remote-https.exe`