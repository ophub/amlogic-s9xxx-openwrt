# Description of Amlogic s9xxx series related documents

View Chinese description  |  [查看中文说明](README.cn.md)

Some files needed for compilation related to amlogic-s9xxx kernel are stored in the directory.

## amlogic-armbian

The files stored here are the Armbian related files that need to be used when packaging OpenWrt.

## amlogic-dtb

For more OpenWrt firmware .dtb files are in the [amlogic-dtb](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb) directory.  When writing into EMMC through [openwrt-install-amlogic](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/common-files/files/usr/sbin/openwrt-install-amlogic), select 0: Enter the dtb file name of your box.

## amlogic-kernel

The kernel files needed to compile OpenWrt are stored in the `amlogic-kernel` directory. For usage, see [amlogic-kernel/README.md](amlogic-kernel/README.md)

## amlogic-u-boot

When you use OpenWrt with 5.10 kernel, you need to copy the u-boot file as `u-boot.ext` , when using it in EMMC, you need to copy the u-boot file as `u-boot.emmc` . These duplications are automated in the repository's packaging and install/upgrade scripts, eliminating the need for manual duplication. For the specific files corresponding to each model, see [u-boot-*.bin](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-u-boot)

## common-files

- files: Stored here is the personalized configuration file of the OpenWrt firmware, which will be automatically integrated into your firmware when the packaging script `sudo ./make` is executed. The names of related directories and files must be exactly the same as the ROOTFS partition in OpenWrt (that is, enter in the TTYD terminal: `cd / && ls .` The directories you see and the file names in each directory).

```yaml
etc/config/amlogic
usr/sbin
```

- patches: The files in the [patches](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/common-files/patches) directory are patch files, which are integrated when build kernel files.

