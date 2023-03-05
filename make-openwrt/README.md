# Directory Description

View Chinese description  |  [查看中文说明](README.cn.md)

Some files required to make OpenWrt are stored in the relevant directory.

## openwrt-files

The files stored here are related files that need to be used when packaging OpenWrt. Among them, the `common-files` directory contains common files, the `platform-files` directory contains files for each platform, and the `different-files` directory contains differentiated files for different devices.

- The required system files will be automatically downloaded from the [ophub/amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian/armbian-files) repository into the `platform-files` and `different-files` directories.

- The required firmware will be automatically downloaded from the [ophub/firmware](https://github.com/ophub/firmware) repository to the `common-files/lib/firmware` directory.

- The required install/update scripts will be automatically downloaded from the [ophub/luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) repository to the `common-files/usr/sbin` directory .

## documents

Here is the OpenWrt usage documentation.

## kernel

The required kernel will be automatically downloaded from the [ophub/kernel](https://github.com/ophub/kernel) repository to the `kernel` directory.

## u-boot

The required u-boot will be automatically downloaded from the [ophub/amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian/u-boot) repository to` u-boot` directory.

