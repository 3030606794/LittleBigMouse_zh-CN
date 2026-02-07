cd /d "D:\谷歌下载\LittleBigMouse-5.2.3_zh-CN_CI-fix\work_lbm_patched"

git checkout -B main

git remote remove origin
git remote add origin https://github.com/3030606794/LittleBigMouse_zh-CN.git

:: 先彻底清掉旧状态（防止目录不是 submodule）
git submodule deinit -f -- HLab.Core 2>nul
git submodule deinit -f -- HLab.Avalonia 2>nul
git rm -f HLab.Core 2>nul
git rm -f HLab.Avalonia 2>nul
rmdir /s /q HLab.Core 2>nul
rmdir /s /q HLab.Avalonia 2>nul

:: 重新添加为 submodule
git submodule add https://github.com/mgth/HLab.Core.git HLab.Core
git submodule add https://github.com/mgth/HLab.Avalonia.git HLab.Avalonia

:: 锁定到 LBM 5.2.3 对应提交
git -C HLab.Core fetch --all --tags --prune
git -C HLab.Core checkout a2c8ff5

git -C HLab.Avalonia fetch --all --tags --prune
git -C HLab.Avalonia checkout dc4432e

git submodule update --init --recursive

:: 提交并强制覆盖远端 main
git add -A
git commit -m "Add & pin submodules for LBM 5.2.3" 2>nul

git push -u origin main --force
