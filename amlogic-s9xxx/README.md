# Directory Description

View Chinese description  |  [查看中文说明](README.cn.md)

Some files needed for compilation related to amlogic-s9xxx kernel are stored in the directory.

## common-files

- rootfs: Stored here is the personalized configuration file of the OpenWrt firmware, which will be automatically integrated into your firmware when the packaging script `sudo ./make` is executed. The names of related directories and files must be exactly the same as the ROOTFS partition in OpenWrt (that is, enter in the TTYD terminal: `cd / && ls .` The directories you see and the file names in each directory).

```yaml
etc/config/amlogic
usr/sbin
```

- bootfs: This is the personalized configuration file in the `/boot` directory of the OpenWrt system.

- patches: The files in the [patches](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/common-files/patches) directory are patch files, which are integrated when build kernel files.

## Other directory descriptions

- When building an OpenWrt system, the required Armbian related files will be automatically downloaded from the [ophub/amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian) repository. Contains the following directories: `amlogic-armbian`, `amlogic-u-boot` and related files in `common-files` directory.

- The required kernels will be automatically downloaded from the [ophub/kernel](https://github.com/ophub/kernel) repository to the `amlogic-kernel` directory.

- The required install/update etc scripts will be automatically downloaded from the [ophub/luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) repository to the `common-files/rootfs/usr/sbin` directory.
