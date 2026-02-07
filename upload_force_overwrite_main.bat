git checkout -B main

git remote remove origin
git remote add origin https://github.com/3030606794/LittleBigMouse_zh-CN.git

:: --- 重置/重建 HLab.Core 子模块并锁定到 a2c8ff5 ---
git submodule deinit -f -- HLab.Core >nul 2>&1
git rm -f HLab.Core >nul 2>&1
rmdir /s /q HLab.Core >nul 2>&1

git submodule add https://github.com/mgth/HLab.Core.git HLab.Core
git -C HLab.Core fetch --all --tags --prune
git -C HLab.Core checkout a2c8ff5

:: --- 重置/重建 HLab.Avalonia 子模块并锁定到 dc4432e ---
git submodule deinit -f -- HLab.Avalonia >nul 2>&1
git rm -f HLab.Avalonia >nul 2>&1
rmdir /s /q HLab.Avalonia >nul 2>&1

git submodule add https://github.com/mgth/HLab.Avalonia.git HLab.Avalonia
git -C HLab.Avalonia fetch --all --tags --prune
git -C HLab.Avalonia checkout dc4432e

:: --- 更新子模块 ---
git submodule update --init --recursive

:: --- 提交并强制覆盖远端 ---
git add -A
git commit -m "Pin submodules for LBM 5.2.3" >nul 2>&1

git push -u origin main --force
