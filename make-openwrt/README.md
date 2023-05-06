# Directory Description

View Chinese description | [查看中文说明](README.cn.md)

Some files required for compiling OpenWrt are stored in the relevant directories.

## openwrt-files

The files stored here are the relevant files required for packaging OpenWrt. The files under the `common-files` directory are common files, those under the `platform-files` directory are platform-specific files, and those under the `different-files` directory are device-specific differential files.

- System files will be automatically downloaded from the [ophub/amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian/armbian-files) repository to the `platform-files` and `different-files` directories.

- Required firmware will be automatically downloaded from the [ophub/firmware](https://github.com/ophub/firmware) repository to the `common-files/lib/firmware` directory.

- Required installation/update scripts and other related files will be automatically downloaded from the [ophub/luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) repository to the `common-files/usr/sbin` directory.

## documents

The OpenWrt usage documents are stored here.

## kernel

The required kernel will be automatically downloaded from the [ophub/kernel](https://github.com/ophub/kernel) repository to the `kernel` directory.

## u-boot

The required u-boot will be automatically downloaded from the [ophub/amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian/u-boot) repository to the `u-boot` directory.

