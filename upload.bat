@echo off
:: 设置编码为 UTF-8 以支持中文显示
chcp 65001 >nul
title GitHub 一键上传脚本

echo ==========================================
echo       GitHub 自动上传工具
echo   目标仓库: LittleBigMouse_zh-CN
echo ==========================================
echo.

:: --- 1. 配置参数 ---
set REPO_URL=https://github.com/3030606794/LittleBigMouse_zh-CN.git
set BRANCH=main
:: 获取当前时间作为提交信息
set CURRENT_TIME=%date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,8%

:: --- 2. 检测 Git 是否安装 ---
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未检测到 Git，请先安装 Git for Windows！
    echo 下载地址: https://git-scm.com/download/win
    pause
    exit
)

:: --- 3. 初始化检查 ---
if not exist ".git" (
    echo [状态] 首次运行，正在初始化仓库...
    git init
    git branch -M %BRANCH%
    git remote add origin %REPO_URL%
) else (
    echo [状态] 仓库已存在，正在校准远程地址...
    git remote set-url origin %REPO_URL%
)

:: --- 4. 执行上传流程 ---
echo [状态] 正在添加所有文件...
git add .

echo [状态] 正在提交更改 (时间: %CURRENT_TIME%)...
git commit -m "Auto Update: %CURRENT_TIME%"

echo [状态] 正在推送到 GitHub (可能需要科学上网)...
echo.
:: 普通推送
git push -u origin %BRANCH%

:: --- 5. 错误处理与结束 ---
if %errorlevel% neq 0 (
    echo.
    echo ==========================================
    echo [警告] 推送失败！可能的原因：
    echo 1. 网络问题：请开启 VPN/代理。
    echo 2. 权限问题：如果是第一次，请按提示输入 Token。
    echo 3. 冲突问题：如果远程仓库不是空的，且与本地不一致。
    echo    如果你想【强制覆盖】远程仓库，请右键编辑脚本，
    echo    将 'git push' 那一行改为 'git push -f -u origin main'
    echo ==========================================
) else (
    echo.
    echo [成功] 所有文件已上传完毕！
)

pause