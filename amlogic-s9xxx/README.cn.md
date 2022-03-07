# Amlogic s9xxx 系列相关文件说明

查看英文说明 | [View English description](README.md)

在相关目录中存储了一些与 Amlogic s9xxx 内核相关的编译 OpenWrt 所需的文件。

## amlogic-armbian

这里存放的文件是打包 OpenWrt 时需要使用的 Armbian 的相关文件。

## common-files

- files: 这里存放的是 OpenWrt 固件的个性化配置文件，将在打包脚本 `sudo ./make` 执行时自动将相关文件集成到你的固件里。相关目录及文件命名均须与 OpenWrt 中 ROOTFS 分区 ( 即在 TTYD 终端里输入： `cd / && ls .` 你所看到的目录及各目录里面的文件名称 ) 保持完全一致。

```yaml
etc/config/amlogic
usr/sbin
```

- patches: 这是补丁文件存放目录，你可以将扩展文件，魔改补丁等放置在该目录。具有详见 [patches](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/common-files/patches)

