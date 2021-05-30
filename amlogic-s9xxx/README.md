# amlogic-s9xxx kernel related files

View Chinese description  |  [查看中文说明](README.cn.md)

Some files needed for compilation related to amlogic-s9xxx kernel are stored in the directory.

## amlogic-armbian

Armbian files storage directory, such as [boot and firmware](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-armbian) related.

## amlogic-dtb

For more OpenWrt firmware .dtb files are in the [amlogic-dtb](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb) directory.  When writing into EMMC through [openwrt-install](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/common-files/files/usr/bin/openwrt-install), select 0: Enter the dtb file name of your box.

## amlogic-kernel

The amlogic-s9xxx [kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel) storage directory. 

## amlogic-u-boot

When using the 5.10 kernel version, you need to copy the corresponding [u-boot-*.bin](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-u-boot) file to `u-boot.ext` (TF/SD card boot file) and `u-boot.emmc` (EMMC boot file).

## common-files

- files: The files in the [files](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/common-files/files) directory are custom files, which must be completely consistent with the structure and file naming and storage under the ***`ROOTFS`*** partiton in openwrt. If there are files in this directory, they will be automatically copied to the openwrt directory during `sudo ./make`. E.g:
```yaml
etc/config/network
lib/u-boot
```
- patches: The files in the [patches](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/common-files/patches) directory are patch files, which are integrated when build kernel files.

