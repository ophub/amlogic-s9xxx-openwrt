# 目录说明

[English Instructions](README.md) | [中文说明](README.cn.md)

相关目录中存放了编译 OpenWrt 所需的文件。

## openwrt-files

此目录存放打包 OpenWrt 时所需的相关文件。其中 `common-files` 目录下为通用文件，`platform-files` 目录下为各平台的专用文件，`different-files` 目录下为不同设备的差异化文件。

- 系统文件将从 [ophub/amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian/armbian-files) 仓库自动下载至 `platform-files` 和 `different-files` 目录。

- 固件文件将从 [ophub/firmware](https://github.com/ophub/firmware) 仓库自动下载至 `common-files/lib/firmware` 目录。

- 安装/更新等脚本将从 [ophub/luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) 仓库自动下载至 `common-files/usr/sbin` 目录。

## kernel

在 `kernel` 目录下创建与版本号对应的文件夹，如 `stable/5.10.125`。多个内核请依次创建目录并放入对应的内核文件。内核文件可从 [kernel](https://github.com/ophub/kernel) 仓库下载，也可[自定义编译](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/compile-kernel)。若未手动下载内核文件，编译时脚本会自动从 kernel 仓库下载。

## u-boot

系统启动引导文件，根据不同版本的内核，在需要时由安装/更新等相关脚本自动完成。所需的 u-boot 将从 [ophub/u-boot](https://github.com/ophub/u-boot) 仓库自动下载至 `u-boot` 目录。

## scripts

执行 `remake` 时会自动安装当前服务器环境所需的依赖软件包。其他脚本文件用于辅助编译或制作 OpenWrt 系统。
