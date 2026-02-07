@echo off
:: =================配置区域=================
:: 设置你的 GitHub 仓库地址
set REPO_URL=https://github.com/3030606794/LittleBigMouse_zh-CN.git

:: 设置分支名称
set BRANCH=main

:: Clash Verge 默认端口通常是 7897。
:: 如果这也不行，请点开 Clash Verge 左侧的“设置”，看一眼“混合端口”或“HTTP端口”是多少。
set PROXY_PORT=7897
:: =========================================

echo [Step 1] Setting up Proxy to 127.0.0.1:%PROXY_PORT%...
:: 设置 Git 代理
git config http.proxy http://127.0.0.1:%PROXY_PORT%
git config https.proxy http://127.0.0.1:%PROXY_PORT%
git config http.sslVerify false

echo.
echo [Step 2] Checking Git Repo...
if not exist ".git" (
    echo Initializing new repository...
    git init
    git branch -M %BRANCH%
    git remote add origin %REPO_URL%
) else (
    echo Repo exists, updating URL...
    git remote set-url origin %REPO_URL%
)

echo.
echo [Step 3] Adding files...
git add .

echo.
echo [Step 4] Committing...
set CURRENT_TIME=%date% %time%
git commit -m "Update: %CURRENT_TIME%"

echo.
echo [Step 5] Force Pushing to GitHub...
:: 使用 -f 强制推送，解决冲突
git push -f -u origin %BRANCH%

if %errorlevel% neq 0 (
    echo.
    echo =================ERROR=================
    echo 推送失败！无法连接到端口 %PROXY_PORT%。
    echo 请打开 Clash Verge 左侧的【设置】。
    echo 找到【HTTP 端口】或者【混合端口】。
    echo 如果不是 7897，请右键编辑此脚本，修改 'set PROXY_PORT=...' 那一行。
    echo =======================================
    pause
    exit
)

echo.
echo [SUCCESS] Upload Complete!
pause