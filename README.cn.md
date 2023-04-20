# OpenWrt

查看英文说明 | [View English description](README.md)

[OpenWrt](https://openwrt.org/) 项目是一个针对嵌入式设备的 Linux 路由器操作系统。OpenWrt 不是一个单一且不可更改的固件，而是提供了具有软件包管理功能的完全可写的文件系统，让您可以自由选择需要的软件包来定制路由器系统。对于开发人员来说，OpenWrt 是一个无需围绕它构建完整固件就能开发应用程序的框架；对于普通用户来说，这意味着拥有了完全定制的能力，能以意想不到的方式使用该设备。它拥有超过 3000+ 个标准化应用软件包和非常丰富的第三方插件支持，让您可以轻松地将他们应用于各种支持的设备。

现在你可以将电视盒子的安卓 TV 系统更换为 OpenWrt 系统，让他成为一台功能强大的路由器。本项目为 `Amlogic`，`Rockchip` 和 `Allwinner` 盒子构建 OpenWrt 系统。支持写入 eMMC 中使用，支持更新内核等功能。使用方法详见[OpenWrt 使用文档](./make-openwrt/documents/README.cn.md)。

最新的固件可以在 [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases) 中下载。欢迎你 `Fork` 并进行个性化软件包定制。如果对你有用，可以点仓库右上角的 `Star` 表示支持。

## OpenWrt 固件说明

| 芯片  | 设备 | [可选内核](https://github.com/ophub/kernel/releases/tag/kernel_stable) | OpenWrt 固件 |
| ---- | ---- | ---- | ---- |
| a311d | [Khadas-VIM3](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/99) | 全部 | amlogic_a311d.img |
| s922x | [Beelink-GT-King](https://github.com/ophub/amlogic-s9xxx-armbian/issues/370), [Beelink-GT-King-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/707), [Ugoos-AM6-Plus](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/213), [ODROID-N2](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/201), [X88-King](https://github.com/ophub/amlogic-s9xxx-armbian/issues/988), [Ali-CT2000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1150) | 全部 | amlogic_s922x.img |
| s905x3 | [X96-Max+](https://github.com/ophub/amlogic-s9xxx-armbian/issues/351), [HK1-Box](https://github.com/ophub/amlogic-s9xxx-armbian/issues/414), [Vontar-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1006), [H96-Max-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1250), [Ugoos-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/782), [TX3(QZ)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/644), [TX3(BZ)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1077), [X96-Air](https://github.com/ophub/amlogic-s9xxx-armbian/issues/366), [X96-Max+_A100](https://github.com/ophub/amlogic-s9xxx-armbian/issues/779), [A95XF3-Air](https://github.com/ophub/amlogic-s9xxx-armbian/issues/157), [Tencent-Aurora-3Pro(s905x3-b)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/506), [X96-Max+Q1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/788), [X96-Max+100W](https://github.com/ophub/amlogic-s9xxx-armbian/issues/909), [X96-Max+_2101](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1086), [Infinity-B32](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1181) | 全部 | amlogic_s905x3.img |
| s905x2 | [X96Max-4G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/453), [X96Max-2G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/95), [MECOOL-KM3-4G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/79), [Tanix-Tx5-Max](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/351), [A95X-F2](https://github.com/ophub/amlogic-s9xxx-armbian/issues/851) | 全部 | amlogic_s905x2.img |
| s912 | [Tanix-TX8-Max](https://github.com/ophub/amlogic-s9xxx-armbian/issues/500), [Tanix-TX9-Pro(3G)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/315), [Tanix-TX9-Pro(2G)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/740), [Tanix-TX92](https://github.com/ophub/amlogic-s9xxx-armbian/issues/72#issuecomment-1012790770), [Nexbox-A1](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/260), [Nexbox-A95X-A2](https://www.cafago.com/en/p-v2979eu-2g.html),  [A95X](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/260), [H96-Pro-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/72#issuecomment-1013071513), [VORKE-Z6-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/72), [Mecool-M8S-PRO-L](https://github.com/ophub/amlogic-s9xxx-armbian/issues/158), [Vontar-X92](https://github.com/ophub/amlogic-s9xxx-armbian/issues/525), [T95Z-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/668), [Octopus-Planet](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1020), [Phicomm-T1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/522) | 全部 | amlogic_s912.img |
| s905d | [MECOOL-KI-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/59), [Phicomm-N1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/925) | 全部 | amlogic_s905d.img |
| s905x | [HG680P](https://github.com/ophub/amlogic-s9xxx-armbian/issues/368), [B860H](https://github.com/ophub/amlogic-s9xxx-armbian/issues/60), [TBee-Box](https://github.com/ophub/amlogic-s9xxx-armbian/issues/98), [T95](https://github.com/ophub/amlogic-s9xxx-armbian/issues/285), [TX9](https://github.com/ophub/amlogic-s9xxx-armbian/issues/645) | 全部 | amlogic_s905x.img |
| s905w | [X96-Mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/621), [TX3-Mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1062), [W95](https://github.com/ophub/amlogic-s9xxx-armbian/issues/570), [X96W/FunTV](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1044), [MXQ-Pro-4K](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1140) | 全部 | amlogic_s905w.img |
| s905l2 | [MGV2000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/648), [MGV3000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/921), [Wojia-TV-IPBS9505](https://github.com/ophub/amlogic-s9xxx-armbian/issues/648), [M301A](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/405), [E900v21E](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1278) | 全部 | amlogic_s905l2.img |
| s905l3 | [CM311-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/763), [HG680-LC](https://github.com/ophub/amlogic-s9xxx-armbian/issues/978), [M401A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/921#issuecomment-1453143251), [UNT400G1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1277) | 全部 | amlogic_s905l3.img |
| s905l3a | [E900V22C/D](https://github.com/Calmact/e900v22c), [CM311-1a-YST](https://github.com/ophub/amlogic-s9xxx-armbian/issues/517), [M401A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/732), [M411A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/517), [UNT403A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/970), [UNT413A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/970), [ZTE-B863AV3.2-M](https://github.com/ophub/amlogic-s9xxx-armbian/issues/741) | 全部 | amlogic_s905l3a.img |
| s905l3b | [E900V22D](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1256), [M302A/M304A](https://github.com/ophub/amlogic-s9xxx-armbian/pull/615), [E900V22E](https://github.com/ophub/amlogic-s9xxx-armbian/issues/939), [Hisense-IP103H](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1154), [CM211-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1180), [CM311-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1268) | 全部 | amlogic_s905l3b.img |
| s905lb | [Q96-mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/734), [BesTV-R3300L](https://github.com/ophub/amlogic-s9xxx-armbian/pull/993), [SumaVision-Q7](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1190) | 全部 | amlogic_s905lb.img |
| s905 | [Beelink-Mini-MX-2G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/127), [Sunvell-T95M](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/337), [MXQ-Pro+4K](https://github.com/ophub/amlogic-s9xxx-armbian/issues/715), [SumaVision-Q5](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1175) | 全部 | amlogic_s905.img |
| rk3588 | [Radxa-Rock5B](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1240), [HinLink-H88K](http://www.hinlink.com/index.php?id=151) | [rk3588](https://github.com/ophub/kernel/releases/tag/kernel_rk3588) | rockchip_boxname.img |
| rk3568 | [FastRhino-R66S](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1061), [FastRhino-R68S](https://github.com/ophub/amlogic-s9xxx-armbian/issues/774), [HinLink-H66K](http://www.hinlink.com/index.php?id=137), [HinLink-H68K](http://www.hinlink.com/index.php?id=119), [Radxa-E25](https://wiki.radxa.com/Rock3/CM/CM3I/E25), [NanoPi-R5S](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1217), [Photonicat](https://ariaboard.com/wiki/Photonicat_%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C) | [6.x.y](https://github.com/ophub/kernel/releases/tag/kernel_stable) | rockchip_boxname.img |
| rk3399 | [EAIDK-610](https://github.com/ophub/amlogic-s9xxx-armbian/pull/991), [King3399](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1080), [TN3399](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1094), [Kylin3399](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1132), [ZCube1-Max](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1247), [CRRC](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1280) | [6.x.y](https://github.com/ophub/kernel/releases/tag/kernel_stable) | rockchip_boxname.img |
| rk3328 | [BeikeYun](https://github.com/ophub/amlogic-s9xxx-armbian/issues/852), [L1-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1007) | 全部 | rockchip_boxname.img |
| h6 | [Vplus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1100), [Tanix-TX6](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1120) | 全部 | allwinner_boxname.img |

💡提示：目前 [s905 的盒子](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1173)只能在 `TF/SD/USB` 中使用，其他型号的盒子支持写入 `EMMC` 中使用。更多信息请查阅[支持的设备列表说明](make-openwrt/openwrt-files/common-files/etc/model_database.conf)。可以参考说明文档中 12.15 章节的方法[添加新的支持设备](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/build-armbian/documents/README.cn.md#1215-如何添加新的支持设备)。

## 安装及升级 OpenWrt 的相关说明

选择和你的电视盒子型号对应的 OpenWrt 固件，不同设备的使用方法查看对应的说明。

- ### 安装 OpenWrt

1. `Rockchip` 平台的安装方法请查看说明文档中的 [第 8 章节](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/build-armbian/documents/README.cn.md) 的介绍，和 Armbian 的安装方法相同。

2. `Amlogic` 和 `Allwinner` 平台，使用 [Rufus](https://rufus.ie/) 或者 [balenaEtcher](https://www.balena.io/etcher/) 等工具将固件写入 USB 里，然后把写好固件的 USB 插入盒子。从浏览器访问 OpenWrt 的默认 IP: 192.168.1.1 → `使用默认账户登录进入 OpenWrt` → `系统菜单` → `晶晨宝盒` → `安装 OpenWrt` ，在支持的设备下拉列表中选择你的盒子，点击 `安装 OpenWrt` 按钮进行安装。

- ### 升级 OpenWrt

从浏览器访问 OpenWrt 的 IP 如: 192.168.1.1 →  `使用账户登录进入 OpenWrt` → `系统菜单` → `晶晨宝盒` → `手动上传更新 / 在线下载更新`

如果选择 `手动上传更新` [OpenWrt 固件](https://github.com/ophub/amlogic-s9xxx-openwrt/releases)，可以将编译好 OpenWrt 固件压缩包，如 openwrt_xxx_k5.15.50.img.gz 进行上传（推荐上传压缩包，系统会自动解压。如果上传解压缩后的 xxx.img 格式的文件，可能会因为文件太大而上传失败），上传完成后界面将显示 `更新固件` 的操作按钮，点击即可更新。

如果选择 `手动上传更新` [OpenWrt 内核](https://github.com/ophub/kernel/releases/tag/kernel_stable)，可以将 `boot-xxx.tar.gz`, `dtb-xxx.tar.gz`, `modules-xxx.tar.gz` 这 3 个内核文件上传（其他内核文件不需要，如果同时上传也不影响更新，系统可以准确识别需要的内核文件），上传完成后界面将显示 `更新内核` 的操作按钮，点击即可更新。

如果选择 `在线下载更新` OpenWrt 固件或内核，将根据`插件设置`中的`固件下载地址`和`内核下载地址`进行下载，你可以自定义修改下载来源，具体操作方法详见 [luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) 的编译与使用说明。

- ### 为 OpenWrt 创建 swap

如果你在使用 `docker` 等内存占用较大的应用时，觉得当前盒子的内存不够使用，可以创建 `swap` 虚拟内存分区，将 `/mnt/*4` 磁盘空间的一定容量虚拟成内存来使用。下面命令输入参数的单位是 `GB`，默认为 `1`。

从浏览器访问 OpenWrt 的默认 IP: 192.168.1.1 → `使用默认账户登录进入 OpenWrt` → `系统菜单` → `TTYD 终端` → 输入命令

```yaml
openwrt-swap 1
```

- ### 备份/还原 EMMC 原系统

支持在 `TF/SD/USB` 中对盒子的 `EMMC` 分区进行备份/恢复。建议您在全新的盒子里安装 OpenWrt 系统前，先对当前盒子自带的安卓 TV 系统进行备份，以便日后在恢复电视系统等情况下使用。

请从 `TF/SD/USB` 启动 OpenWrt 系统，浏览器访问 OpenWrt 的默认 IP: 192.168.1.1 → `使用默认账户登录进入 OpenWrt` → `系统菜单` → `TTYD 终端` → 输入命令

```yaml
openwrt-ddbr
```

根据提示输入 `b` 进行系统备份，输入 `r` 进行系统恢复。

- ### 控制 LED 显示

从浏览器访问 OpenWrt 的默认 IP: 192.168.1.1 → `使用默认账户登录进入 OpenWrt` → `系统菜单` → `TTYD 终端` → 输入命令

```yaml
openwrt-openvfd
```

根据 [LED 屏显示控制说明](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/build-armbian/documents/led_screen_display_control.md) 进行调试。

- ### 更多使用说明

使用 `firstboot` 命令可以恢复系统至初始化状态。在 OpenWrt 的使用中，一些可能遇到的常见问题详见 [使用文档](./make-openwrt/documents/README.cn.md)

## 本地化打包

1. 安装必要的软件包（如 Ubuntu 22.04 LTS 用户）
```yaml
sudo apt-get update -y
sudo apt-get full-upgrade -y
# For Ubuntu-22.04
sudo apt-get install -y $(curl -fsSL https://is.gd/depend_ubuntu2204_openwrt)
```
2. Clone 仓库到本地 `git clone --depth 1 https://github.com/ophub/amlogic-s9xxx-openwrt.git`
3. 在 `~/amlogic-s9xxx-openwrt` 根目录下创建 `openwrt-armvirt` 文件夹, 并将 `openwrt-armvirt-64-default-rootfs.tar.gz` 文件上传至此目录。
4. 在 `~/amlogic-s9xxx-openwrt` 根目录中输入打包命令，如 `sudo ./make -b s905x3 -k 6.1.10`。打包完成的 OpenWrt 固件放在根目录下的 `out` 文件夹里。

- ### 本地化打包参数说明

| 参数  | 含义       | 说明               |
| ---- | ---------- | ----------------- |
| -b   | Board      | 指定电视盒子型号，如 `-b s905x3` . 多个型号使用 `_` 进行连接，如 `-b s905x3_s905d` . 使用 `all` 表示全部型号。型号代码详见 [model_database.conf](make-openwrt/openwrt-files/common-files/etc/model_database.conf) 中的 `BOARD` 设置。默认值：`all` |
| -r   | KernelRepo | 指定 github.com 内核仓库的 `<owner>/<repo>`。默认值：`ophub/kernel` |
| -u   | kernelUsage | 设置使用的内核的 `tags 后缀`，如 [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable), [flippy](https://github.com/ophub/kernel/releases/tag/kernel_flippy), [dev](https://github.com/ophub/kernel/releases/tag/kernel_dev)。默认值：`stable` |
| -k   | Kernel     | 指定 [kernel](https://github.com/ophub/kernel/releases/tag/kernel_stable) 名称，如 `-k 5.10.125` . 多个内核使用 `_` 进行连接，如 `-k 5.10.125_5.15.50` 。通过 `-k` 参数自由指定的内核版本只对使用 `stable/flippy/dev` 的内核有效。其他内核系列例如 [rk3588](https://github.com/ophub/kernel/releases/tag/kernel_rk3588) 等只能使用特定内核。  |
| -a   | AutoKernel | 设置是否自动采用同系列最新版本内核。当为 `true` 时，将自动在内核库中查找在 `-k` 中指定的内核如 5.10.125 的同系列是否有更新的版本，如有 5.10.125 之后的最新版本时，将自动更换为最新版。设置为 `false` 时将编译指定版本内核。默认值：`true` |
| -s   | Size       | 对系统的 ROOTFS 分区大小进行设置，系统大小必须大于 2048MiB. 例如： `-s 2560`。默认值：`2560` |
| -g   | GH_TOKEN   | 可选项。设置 `${{ secrets.GH_TOKEN }}`，用于 [api.github.com](https://docs.github.com/en/rest/overview/resources-in-the-rest-api?apiVersion=2022-11-28#requests-from-personal-accounts) 查询。默认值：`无` |


- `sudo ./make` : 使用默认配置，使用内核库中的最新内核包，对全部型号的电视盒子进行打包。
- `sudo ./make -b s905x3 -k 6.1.10` : 推荐使用. 使用默认配置进行相关内核打包。
- `sudo ./make -b s905x3_s905d -k 6.1.10_5.15.50` : 使用默认配置，进行多个内核同时打包。使用 `_` 进行多内核参数连接。
- `sudo ./make -b s905x3 -k 6.1.10 -s 1024` : 使用默认配置，指定一个内核，一个型号进行打包，固件大小设定为 1024 MiB。
- `sudo ./make -b s905x3_s905d`  使用默认配置，对多个型号的电视盒子进行全部内核打包, 使用 `_` 进行多型号连接。
- `sudo ./make -k 6.1.10_5.15.50` : 使用默认配置，指定多个内核，进行全部型号电视盒子进行打包, 内核包使用 `_` 进行连接。
- `sudo ./make -k 6.1.10_5.15.50 -a true` : 使用默认配置，指定多个内核，进行全部型号电视盒子进行打包, 内核包使用 `_` 进行连接。自动升级到同系列最新内核。
- `sudo ./make -s 1024 -k 6.1.10` : 使用默认配置，设置固件大小为 1024 MiB, 并指定内核为 6.1.10 ，对全部型号电视盒子进行打包。

## 使用 GitHub Actions 进行编译

你可以通过修改 [config-openwrt](config-openwrt) 目录的相关个性化固件配置文件，以及 [.yml](.github/workflows) 文件, 自定义和编译适合你的 OpenWrt 固件,  固件可以上传至 github.com 的 `Actions` 和 `Releases` 等处.

1. 你可以在 [使用文档](./make-openwrt/documents/README.cn.md) 中查看个性化固件配置说明。编译流程控制文件是 [.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt-with-lede.yml)
2. 全新编译：在 github.com 的 [Action](https://github.com/ophub/amlogic-s9xxx-openwrt/actions) 选择 ***`Build OpenWrt`*** . 点击 ***`Run workflow`*** 按钮进行固件一站式编译和打包。
3. 再次编译：如果 [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases) 中有已经编译好的 `openwrt-armvirt-64-default-rootfs.tar.gz` 文件，你只是想再次制作其他不同 board 的盒子，可以跳过 OpenWrt 源文件的编译，直接进行二次制作。在 [Actions](https://github.com/ophub/amlogic-s9xxx-openwrt/actions) 页面中选择  ***`Use Releases file to Packaging`*** ，点击 ***`Run workflow`*** 按钮即可二次编译。
4. 更多支持：编译好的 `openwrt-armvirt-64-default-rootfs.tar.gz` 文件是制作各种不同 board 固件的通用文件，也适用于使用 [unifreq](https://github.com/unifreq/openwrt_packit) 的打包脚本制作 OpenWrt 固件。他作为在盒子里使用 OpenWrt 和 Armbian 系统的开创者，对更多的设备进行了支持，如在 [Armbian](https://github.com/ophub/amlogic-s9xxx-armbian) 系统中通过 `KVM` 虚拟机使用的 OpenWrt（[QEMU 版](https://github.com/unifreq/openwrt_packit/blob/master/files/qemu-aarch64/qemu-aarch64-readme.md)）、Amlogic、Rockchip，以及 Allwinner 系列等。打包方法详见他的仓库说明，在 Actions 中通过 [packaging-openwrt-for-qemu-etc.yml](.github/workflows/packaging-openwrt-for-qemu-etc.yml) 可以调用他的打包脚本制作更多固件。

```yaml
- name: Package Armvirt as OpenWrt
  uses: ophub/amlogic-s9xxx-openwrt@main
  with:
    openwrt_path: openwrt/bin/targets/*/*/*rootfs.tar.gz
    openwrt_board: s905x3_s905x2_s905x_s905w_s905d_s922x_s912
    openwrt_kernel: 6.1.10_5.15.50
    gh_token: ${{ secrets.GH_TOKEN }}
```
- ### GitHub Actions 输入参数说明

相关参数与`本地打包命令`相对应，请参考上面的说明。

| 参数               | 默认值             | 说明                                        |
|-------------------|-------------------|-------------------------------------------|
| openwrt_path      | 无                | 设置 `openwrt-armvirt-64-default-rootfs.tar.gz` 的文件路径，可以使用相对路径如 `openwrt/bin/targets/*/*/*rootfs.tar.gz` 或网络文件下载地址如 `https://github.com/*/releases/*/*rootfs.tar.gz` |
| openwrt_board     | all               | 设置打包盒子的 `board` ，功能参考 `-b` |
| kernel_repo       | ophub/kernel      | 指定 github.com 内核仓库的 `<owner>/<repo>`，功能参考 `-r` |
| kernel_usage      | stable            | 设置使用的内核的 `tags 后缀`。功能参考 `-u` |
| openwrt_kernel    | 6.1.1_5.15.1      | 设置内核版本，功能参考 `-k` |
| auto_kernel       | true              | 设置是否自动采用同系列最新版本内核。功能参考 `-a` |
| openwrt_size      | 1024              | 设置固件 ROOTFS 分区的大小，功能参考 `-s`      |
| gh_token          | 无                | 可选项。设置 `${{ secrets.GH_TOKEN }}`。功能参考 `-g`      |


- ### GitHub Actions 输出变量说明

上传到 `Releases` 需要给仓库添加 `${{ secrets.GITHUB_TOKEN }}` 和 `${{ secrets.GH_TOKEN }}` 并设置 `Workflow 读写权限`，详见[使用说明](./make-openwrt/documents/README.cn.md#2-设置隐私变量-github_token)。

| 参数                                      | 默认值              | 说明                     |
|------------------------------------------|--------------------|--------------------------|
| ${{ env.PACKAGED_OUTPUTPATH }}           | out                | 打包后的固件所在文件夹的路径  |
| ${{ env.PACKAGED_OUTPUTDATE }}           | 04.13.1058         | 打包日期（月.日.时分）      |
| ${{ env.PACKAGED_STATUS }}               | success / failure  | 打包状态。成功 / 失败       |

## openwrt-*-rootfs.tar.gz 用于打包的文件编译选项

| Option | Value |
| ---- | ---- |
| Target System | QEMU ARM Virtual Machine |
| Subtarget | QEMU ARMv8 Virtual Machine(cortex-a53) |
| Target Profile | Default |
| Target Images | tar.gz |

更多信息请查阅 [使用文档](./make-openwrt/documents/README.cn.md)

## OpenWrt 固件默认信息

| 名称 | 值 |
| ---- | ---- |
| 默认 IP | 192.168.1.1 |
| 默认账号 | root |
| 默认密码 | password |
| 默认 WIFI 名称 | OpenWrt |
| 默认 WIFI 密码 | 无 |

## 编译内核

内核的编译方法详见 [compile-kernel](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/compile-kernel)

```yaml
- name: Compile the kernel
  uses: ophub/amlogic-s9xxx-armbian@main
  with:
    build_target: kernel
    kernel_version: 6.1.10_5.15.50
    kernel_auto: true
    kernel_sign: -yourname
```

## 资源说明

制作 OpenWrt 系统时，所使用的 [kernel](https://github.com/ophub/kernel) 和 [u-boot](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian/u-boot) 等文件，与制作 [Armbian](https://github.com/ophub/amlogic-s9xxx-armbian) 系统使用的是相同的文件。为了不重复维护，相关内容归类放在了对应的资源仓库，在使用时将自动从相关仓库进行下载。

本系统所使用的 `kernel` / `u-boot` 等资源主要从 [unifreq/openwrt_packit](https://github.com/unifreq/openwrt_packit) 的项目中复制而来，部分文件由用户在 [amlogic-s9xxx-openwrt](https://github.com/ophub/amlogic-s9xxx-openwrt) / [amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian) / [luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) / [kernel](https://github.com/ophub/kernel) 等项目的 [Pull](https://github.com/ophub/amlogic-s9xxx-openwrt/pulls) 和 [Issues](https://github.com/ophub/amlogic-s9xxx-openwrt/issues) 中提供分享。`unifreq` 为我们开启了在电视盒子中使用 OpenWrt 的大门，深受其影响，我的固件在制作和使用中继承了他一贯的标准。为感谢这些开拓者和分享者，我统一在 [CONTRIBUTORS.md](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/CONTRIBUTORS.md) 中进行了记录。再次感谢大家为盒子赋予了新的生命和意义。

## 其他发行版

- [unifreq](https://github.com/unifreq/openwrt_packit) 为晶晨、瑞芯微和全志等更多盒子制作了 `OpenWrt` 系统，属于盒子圈的标杆，推荐使用。
- [amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian) 项目提供了在盒子中使用的 `Armbian` 系统，在支持 OpenWrt 的相关设备中同样适用。

## 链接

- [unifreq](https://github.com/unifreq/openwrt_packit)
- [OpenWrt](https://github.com/openwrt/openwrt)
- [coolsnowwolf](https://github.com/coolsnowwolf/lede)
- [immortalwrt](https://github.com/immortalwrt/immortalwrt)

## License

The amlogic-s9xxx-openwrt © OPHUB is licensed under [GPL-2.0](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/LICENSE)
