# 目录说明

查看英文说明 | [View English description](README.md)

在相关目录中存储了一些编译 OpenWrt 所需的文件。

## openwrt-files

这里存放的文件是打包 OpenWrt 时需要使用的相关文件。其中 `common-files` 目录下的是通用文件，`platform-files` 目录下是各平台的文件，`different-files` 目录下是针对不同设备的差异化文件。

- 需要系统文件将从 [ophub/amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian/armbian-files) 仓库自动下载至 `platform-files` 和 `different-files` 目录。

- 需要的固件将从 [ophub/firmware](https://github.com/ophub/firmware) 仓库自动下载至 `common-files/lib/firmware` 目录。

- 需要的安装/更新等脚本将从 [ophub/luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) 仓库自动下载至 `common-files/usr/sbin` 目录。

## documents

这里存放的是 OpenWrt 使用文档。

## kernel

需要的内核将从 [ophub/kernel](https://github.com/ophub/kernel) 仓库自动下载至 `kernel` 目录。

## u-boot

需要的 u-boot 将从 [ophub/amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian/u-boot) 仓库自动下载至 `u-boot` 目录。

