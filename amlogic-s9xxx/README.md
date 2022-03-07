# Description of Amlogic s9xxx series related documents

View Chinese description  |  [查看中文说明](README.cn.md)

Some files needed for compilation related to amlogic-s9xxx kernel are stored in the directory.

## amlogic-armbian

The files stored here are the Armbian related files that need to be used when packaging OpenWrt.

## common-files

- files: Stored here is the personalized configuration file of the OpenWrt firmware, which will be automatically integrated into your firmware when the packaging script `sudo ./make` is executed. The names of related directories and files must be exactly the same as the ROOTFS partition in OpenWrt (that is, enter in the TTYD terminal: `cd / && ls .` The directories you see and the file names in each directory).

```yaml
etc/config/amlogic
usr/sbin
```

- patches: The files in the [patches](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/common-files/patches) directory are patch files, which are integrated when build kernel files.

