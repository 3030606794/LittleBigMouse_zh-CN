# 构建说明（修复版）

你当前仓库是从“Source code zip”解压后再 git init 推送的，因此 **HLab.Core / HLab.Avalonia 子模块不会自动存在**，
GitHub Actions 编译会报大量 “project file not found / type not found”。

解决方法：
- 推荐：使用本次提供的“一键上传GitHub.bat（修复版）”，它会自动把缺失的子模块拉取到本地后再提交/推送。
- 或者：你自己在本地执行：
  - git submodule add https://github.com/mgth/HLab.Core.git HLab.Core
  - git submodule add https://github.com/mgth/HLab.Avalonia.git HLab.Avalonia
  - git submodule update --init --recursive

本仓库自带的 `.github/workflows/windows_build.yml` 会在 Actions 中构建 Release x64 并用 Inno Setup 打包安装器。
