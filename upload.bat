@echo off
:: =================配置区域=================
:: 设置你的 GitHub 仓库地址
set REPO_URL=https://github.com/3030606794/LittleBigMouse_zh-CN.git

:: 设置分支名称 (通常是 main)
set BRANCH=main

:: 设置代理端口 (Clash Verge 通常是 7890 或 7897，请根据实际情况修改)
set PROXY_PORT=7890
:: =========================================

echo [Step 1] Setting up Proxy to 127.0.0.1:%PROXY_PORT%...
:: 强制为当前仓库设置代理，解决连接问题
git config http.proxy http://127.0.0.1:%PROXY_PORT%
git config https.proxy http://127.0.0.1:%PROXY_PORT%
:: 关闭 SSL 验证 (防止代理证书报错)
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
echo [Step 5] Force Pushing to GitHub (using Proxy)...
:: 注意：这里加了 -f 参数，强制覆盖远程仓库，解决 [rejected] 错误
git push -f -u origin %BRANCH%

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Push Failed!
    echo Please check if your Clash port is indeed %PROXY_PORT%.
    pause
    exit
)

echo.
echo [SUCCESS] Upload Complete!
pause