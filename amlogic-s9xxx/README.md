# amlogic-s9xxx kernel related files

Some files needed for compilation related to amlogic-s9xxx kernel are stored in the directory.

## amlogic-dtb

For more OpenWrt firmware .dtb files are in the [amlogic-dtb](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb) directory.  When writing into EMMC through [openwrt-install](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/openwrt-install), select 0: Enter the dtb file name of your box.

## amlogic-kernel

The amlogic-s9xxx [kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel) storage directory, more kernels can be made through [build_kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/build_kernel). 

## common-files

General file storage directory, such as [boot and firmware](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/common-files) related.

## install-program

Install openwrt to emmc for Amlogic S9xxx STB. Insert the `USB hard disk` with the written `OpenWrt` firmware. Log in to the default IP: 192.168.1.1 → `Login in to openwrt` → `system menu` → `TTYD terminal` → input command: 

- Install command: `openwrt-install`

[For more instructions please see: install-program](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/install-program)


## u-boot

The [u-boot](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/u-boot) storage directory contains the mainline boot files and non-mainline boot files. 

