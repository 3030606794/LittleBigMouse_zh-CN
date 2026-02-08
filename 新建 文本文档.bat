@echo off
chcp 65001 >nul
setlocal

:: ================= 配置区域 =================
set "REPO_URL=https://github.com/3030606794/LittleBigMouse_zh-CN.git"
set "BRANCH=main"
:: ===========================================

echo.
echo ========================================================
echo   [LittleBigMouse] 一键同步脚本
echo   目标仓库: %REPO_URL%
echo   目标分支: %BRANCH%
echo ========================================================
echo.

:: 1. 检查是否初始化了 Git，没有则初始化
if not exist ".git" (
    echo [1/5] 检测到未初始化，正在执行 git init...
    git init
    git checkout -b %BRANCH%
) else (
    echo [1/5] Git 仓库已存在，继续...
)

:: 2. 重新绑定远程仓库 (防止 URL 变动或未设置)
echo [2/5] 配置远程仓库地址...
git remote remove origin >nul 2>&1
git remote add origin %REPO_URL%

:: 3. 添加当前目录所有文件
echo [3/5] 添加文件 (git add)...
git add .

:: 4. 生成带时间戳的 Commit
set "TIMESTAMP=%date:~0,10% %time:~0,8%"
echo [4/5] 提交更改: Auto-build %TIMESTAMP%
git commit -m "Auto-build trigger: %TIMESTAMP%"

:: 5. 强制推送到 GitHub
:: 注意：这里使用了 --force，这会确保远程仓库变成和本地一模一样
:: 这对于“只是想把本地文件传上去跑编译”是最省心的方式
echo [5/5] 正在强制推送 (Force Push)...
git push -u origin %BRANCH% --force

echo.
if %errorlevel% equ 0 (
    echo ========================================================
    echo   [成功] 代码已上传！GitHub Actions 编译应该已触发。
    echo   请访问仓库查看 Actions 页面。
    echo ========================================================
) else (
    echo ========================================================
    echo   [失败] 上传出错，请检查网络或代理设置。
    echo ========================================================
)

pause