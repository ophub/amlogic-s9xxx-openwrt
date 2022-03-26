# 目录说明

查看英文说明 | [View English description](README.md)

在相关目录中存储了一些与 Amlogic s9xxx 内核相关的编译 OpenWrt 所需的文件。

## common-files

- rootfs: 这里存放的是 OpenWrt 固件的个性化配置文件，将在打包脚本 `sudo ./make` 执行时自动将相关文件集成到你的固件里。相关目录及文件命名均须与 OpenWrt 中 ROOTFS 分区 ( 即在 TTYD 终端里输入： `cd / && ls .` 你所看到的目录及各目录里面的文件名称 ) 保持完全一致。

```yaml
etc/config/amlogic
usr/sbin
```

- bootfs: 这里存放的是 OpenWrt 系统中 `/boot` 目录下的个性化配置文件。

- patches: 这是补丁文件存放目录，你可以将扩展文件，魔改补丁等放置在该目录。具有详见 [patches](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/common-files/patches)

## 其他目录说明

- 制作 OpenWrt 系统时，需要的 Armbian 相关文件将从 [ophub/amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian) 仓库自动下载。包含以下目录：`amlogic-armbian`，`amlogic-u-boot` 以及 `common-files` 目录中的相关文件。

- 需要的内核将从 [ophub/kernel](https://github.com/ophub/kernel) 仓库自动下载至 `amlogic-kernel` 目录。

- 需要的安装/更新等脚本将从 [ophub/luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) 仓库自动下载至 `common-files/rootfs/usr/sbin` 目录。
