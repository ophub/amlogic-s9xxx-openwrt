# Amlogic s9xxx 系列内核相关文件说明

查看英文说明 | [View English description](README.md)

在相关目录中存储了一些与 Amlogic s9xxx 内核相关的编译 OpenWrt 所需的文件。

## amlogic-armbian

Armbian 相关文件存储目录。这里存放的文件是打包 OpenWrt 时使用的核心文件。除内核外，其他通用文件均放置于此。根据 Flippy 的打包脚本，把从 Armbian 中提取的通用文件打包存放于此。详见 [boot and firmware](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-armbian) 

## amlogic-dtb

这里收录了各种型号机顶盒使用的 .dtb 文件，当你在使用安装脚本 [openwrt-install](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/openwrt-install) 将 OpenWrt 写入 EMMC 时，除默认的13个型号的机顶盒是自动安装外，当你选择 0 进行自选 .dtb 文件安装时，需要填写具体的 .dtb 文件名称，你可以从这里查阅准确的文件名并填写，具体参见 [amlogic-dtb](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb)  

## amlogic-kernel

这是各版本内核的存放目录，集中珍藏了 Flippy 分享的众多内核。具体详见 [kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel) 。 如果目录中没有你要的内核，你可以通过内核提取工具从 Flippy 的Armbian/OpenWrt/kernel 等文件中提取生成，相关工具及使用方法查阅 [build_kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/amlogic-kernel/build_kernel/README.cn.md) 

## amlogic-u-boot

当你使用 5.10 内核的 OpenWrt 时，Flippy 提供了专用的主线 u-boot 文件。当 OpenWrt 在 TF 卡种使用时，需要将 u-boot 文件复制为 `u-boot.ext` ，在 EMMC 中使用时，需要将 u-boot 文件复制为 `u-boot.emmc` 。这些复制工作在仓库的打包和安装/升级脚本中均已自动化完成，无需在人工复制。各型号对应的具体文件详见 [u-boot-*.bin](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-u-boot)

## common-files

- files: 这里存放的是 OpenWrt 固件的个性化配置文件，将在打包脚本 `sudo ./make` 执行时自动将相关文件集成到你的固件里，俗称 files 大法。相关目录及文件命名均须与 OpenWrt 中 root 分区 ( 即在TTYD 终端里输入： `cd / && ls .` 你所看到的目录及各目录里面的文件名称 ) 保持完全一致。你的网络配置文件，广告过滤插件的配置文件等均可以通过这样的方式自动集成（推荐你将 nerwork 文件等内容格式比较固定的配置文件放置于此，但是有些插件升级变化太大，可能与最新插件不兼容，你这样放置时可能导致因为配置文件不兼容而出现奇怪的现象。files 大法虽好，但一定要熟知你添加的配置文件，在安装后若有问题，可以把相关插件的配置文件先删除，再手动重新配置）。具体的例子请查看  [files](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/common-files/files) 
```yaml
etc/config/network
lib/u-boot
```
- patches: 这是补丁文件存放目录，你可以将扩展文件，魔改补丁等放置在该目录。具有详见 [patches](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/common-files/patches)

## install-program

选择和你的机顶盒型号对应的 OpenWrt 固件，使用 [balenaEtcher](https://www.balena.io/etcher/) 等工具将固件写入USB里，然后把写好固件的USB插入机顶盒。从浏览器访问OpenWrt的默认IP: 192.168.1.1 → `使用默认账户登录进入 openwrt` → `系统菜单` → `TTYD 终端` → 输入写入EMMC的命令:  

- Install command: `openwrt-install`

更多安装/升级功能介绍详见 [install-program](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/README.cn.md)

