# Gatekeeper-Bypass

[![Packagist](https://img.shields.io/badge/release-1.0-blue.svg)](https://github.com/HsiangHo/Gatekeeper-Bypass/releases)
[![Travis](https://img.shields.io/badge/platform-macOS-yellow.svg)]()

![Gatekeeper-Bypass](https://github.com/HsiangHo/Gatekeeper-Bypass/blob/master/gatekeeper.png "screenshot")

## 什么是 Gatekeeper
**macOS 中包含一项名为“门禁”的技术，旨在确保只有受信任的软件才能在 Mac 上运行。** [Apple Support文档](https://support.apple.com/zh-cn/HT202491)

## Gatekeeper-Bypass 有什么用
在 Status bar 中轻松查看、切换当前系统的 Gatekeeper 状态，不在需要打开终端进行繁琐的修改。
当打开某些 App 时提示 「xxx.app 已损坏，打不开。你应该将它移到废纸篓」，此时只需要关闭 Gatekeeper 即可。

## 如何使用
+ 方式1. Clone 代码到本地进行编译运行。运行 Gatekeeper-Bypass Loader 将会自动以Root方式运行 Gatekeeper-Bypass。
+ 方式2. 在 release 页面中下载编译好的 zip 文件，解压运行即可。

运行程序后，在 Status bar 会出现当前 Gatekeeper 状态。左键点击将会激活弹出菜单，右键点击直接切换 Gatekeeper 状态。
