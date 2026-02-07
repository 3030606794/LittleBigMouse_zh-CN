@echo off
setlocal EnableExtensions

REM ============================================================
REM LittleBigMouse one-click upload + CI workflow (ASCII only)
REM Repo URL is fixed:
REM   https://github.com/3030606794/LittleBigMouse_zh-CN.git
REM Put this .bat in the project root (same folder as LittleBigMouse.sln)
REM Run from PowerShell/CMD:
REM   .\upload_lbm_to_github_v5.bat
REM ============================================================

cd /d "%~dp0"

echo ============================================================
echo LittleBigMouse Upload Script (v5)
echo ============================================================
echo Working dir: %CD%
echo.

if not exist "LittleBigMouse.sln" goto :no_sln

where git >nul 2>&1
if errorlevel 1 goto :no_git

set "REPO_URL=https://github.com/3030606794/LittleBigMouse_zh-CN.git"
echo Repo URL: %REPO_URL%
echo.

REM ---- Init repo if needed
if exist ".git" goto :git_ok
echo [INFO] git init...
git init
if errorlevel 1 goto :fail
git branch -M main >nul 2>&1

:git_ok
REM ---- Set local identity (avoid "Please tell me who you are")
git config --local user.name  "lbm-bot" >nul 2>&1
git config --local user.email "lbm-bot@users.noreply.github.com" >nul 2>&1

REM ---- Remote origin
git remote remove origin >nul 2>&1
git remote add origin "%REPO_URL%"
if errorlevel 1 goto :fail

REM ---- Write workflow
if not exist ".github" mkdir ".github" >nul 2>&1
if not exist ".github\\workflows" mkdir ".github\\workflows" >nul 2>&1

set "WF=.github\\workflows\\windows_build.yml"
echo [INFO] Writing workflow: %WF%

> "%WF%"  echo name: Windows Build
>>"%WF%" echo.
>>"%WF%" echo on:
>>"%WF%" echo   push:
>>"%WF%" echo     branches: [ main ]
>>"%WF%" echo   workflow_dispatch:
>>"%WF%" echo.
>>"%WF%" echo jobs:
>>"%WF%" echo   build-windows:
>>"%WF%" echo     runs-on: windows-latest
>>"%WF%" echo     steps:
>>"%WF%" echo       - uses: actions/checkout@v4
>>"%WF%" echo         with:
>>"%WF%" echo           submodules: recursive
>>"%WF%" echo           fetch-depth: 0
>>"%WF%" echo       - uses: actions/setup-dotnet@v4
>>"%WF%" echo         with:
>>"%WF%" echo           dotnet-version: 8.0.x
>>"%WF%" echo       - uses: microsoft/setup-msbuild@v2
>>"%WF%" echo       - uses: NuGet/setup-nuget@v2
>>"%WF%" echo       - name: Restore
>>"%WF%" echo         run: nuget restore LittleBigMouse.sln
>>"%WF%" echo       - name: Build Release x64
>>"%WF%" echo         run: msbuild LittleBigMouse.sln /m /p:Configuration=Release /p:Platform=x64
>>"%WF%" echo       - name: Install Inno Setup
>>"%WF%" echo         run: choco install innosetup -y
>>"%WF%" echo       - name: Build installer
>>"%WF%" echo         run: iscc LittleBigMouse.Setup\\LittleBigMouse.iss
>>"%WF%" echo       - name: Upload installer
>>"%WF%" echo         uses: actions/upload-artifact@v4
>>"%WF%" echo         with:
>>"%WF%" echo           name: LittleBigMouse-Installer
>>"%WF%" echo           path: LittleBigMouse.Setup\\*.exe

REM ---- Submodules (required by LittleBigMouse)
echo.
echo [INFO] Ensuring required submodules...
if not exist "HLab.Core" (
  echo [INFO] Adding submodule: HLab.Core
  git submodule add https://github.com/mgth/HLab.Core.git HLab.Core >nul 2>&1
)
if not exist "HLab.Avalonia" (
  echo [INFO] Adding submodule: HLab.Avalonia
  git submodule add https://github.com/mgth/HLab.Avalonia.git HLab.Avalonia >nul 2>&1
)
git submodule update --init --recursive
if errorlevel 1 (
  echo [WARN] submodule update failed. If your network cannot access GitHub, please enable proxy/VPN and retry.
)

REM ---- Commit & push
echo.
echo [INFO] git add...
git add -A
if errorlevel 1 goto :fail

REM Commit may fail if nothing changed; ignore.
git commit -m "init: zh-CN + CI" >nul 2>&1

echo.
echo [INFO] Pushing to GitHub (main)...
echo       If asked for password: use a GitHub Personal Access Token (PAT), not account password.
git push -u origin main
if errorlevel 1 (
  echo.
  echo [ERROR] Push failed.
  echo - If remote already has commits, you may need force push:
  echo     git push -u origin main --force
  echo - If auth fails, use PAT or SSH.
  goto :fail_keep
)

echo.
echo [OK] Done. Open GitHub -> Actions to see the build.
echo.
pause
exit /b 0

:no_sln
echo [ERROR] LittleBigMouse.sln not found in this folder.
echo Put this .bat in the project root (same level as LittleBigMouse.sln).
echo.
pause
exit /b 1

:no_git
echo [ERROR] Git not found. Please install Git for Windows first.
echo.
pause
exit /b 1

:fail
echo.
echo [ERROR] Script failed.
echo.
pause
exit /b 1

:fail_keep
echo.
pause
exit /b 1
