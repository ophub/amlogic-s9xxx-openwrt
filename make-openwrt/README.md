# Directory Description

View Chinese description | [查看中文说明](README.cn.md)

In the related directories, some files needed for compiling OpenWrt are stored.

## openwrt-files

The files stored here are related files needed when packaging OpenWrt. Among them, the files under the `common-files` directory are general files, the files under the `platform-files` directory are files for each platform, and the files under the `different-files` directory are differential files for different devices.

- System files needed will be automatically downloaded from the [ophub/amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian/armbian-files) repository to the `platform-files` and `different-files` directories.

- The firmware needed will be automatically downloaded from the [ophub/firmware](https://github.com/ophub/firmware) repository to the `common-files/lib/firmware` directory.

- The necessary installation/update scripts will be automatically downloaded from the [ophub/luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) repository to the `common-files/usr/sbin` directory.

## kernel

The necessary kernel will be automatically downloaded from the [ophub/kernel](https://github.com/ophub/kernel) repository to the `kernel` directory.

## u-boot

The necessary u-boot will be automatically downloaded from the [ophub/amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian/u-boot) repository to the `u-boot` directory.
