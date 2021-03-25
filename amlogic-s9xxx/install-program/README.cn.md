# 安装/升级程序说明

查看英文说明 | [View English description](README.md)

将 OpenWrt 安装在 Amlogic S9xxx 系列机顶盒中的安装/升级说明文档。

## 在编译时集成安装/升级脚本的方法

在 router_config/diy-part2.sh 文件中，添加 1. 的引入脚本，在 OpenWrt 编译界面的 `Utilities` 中选择 `install-program` 即可完成编译集成。

1. `svn co https://github.com/ophub/amlogic-s9xxx-openwrt/trunk/amlogic-s9xxx/install-program package/install-program`
2. 在执行 `menuconfig` 后，可以在 `Utilities` 目录下选择 `install-program`

```shell script
Utilities  --->  
   <*> install-program
```
💡提示: 当你使用本仓库的脚本 `./make` 打包时，脚本会自动检测 `openwrt-armvirt` 目录中的 `openwrt-armvirt-64-default-rootfs.tar.gz` 文件是否含有安装/升级脚本，如果检测到没有会自动添加，所以你在编译个性化固件时，已经不需要按照上面的方法在编译时集成了。以上方法目前可用于仅集成本仓库的安装/升级脚本，不使用本仓库的打包脚本的应用场景。

## 在 Amlogic S9xxx 系列机顶盒的 EMMC 里进行安装/升级 OpenWrt 的相关说明

选择和你的机顶盒型号相对应的 OpenWrt 固件，使用 [Rufus](https://rufus.ie/) 或者 [balenaEtcher](https://www.balena.io/etcher/) 等工具将固件写入USB里，然后把写好固件的USB插入机顶盒。此脚本通用于各型号的机顶盒，命令均相同。

### 安装 OpenWrt

- 从浏览器访问 OpenWrt 的默认 IP: 192.168.1.1 → `使用默认账户登录进入 openwrt` → `系统菜单` → `TTYD 终端` → 输入写入EMMC的命令: 

```yaml
openwrt-install
```

同一个型号的机顶盒，固件通用，比如 `openwrt_s905x3_v*.img` 固件可以用于 `x96max plus, hk1, h96` 等 `s905x3` 型号的机顶盒。在安装脚本  [openwrt-install](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/openwrt-install) 将 OpenWrt 写入 EMMC 时，会提示你选择自己的机顶盒，请根据提示正确选择安装。

除默认的 13 个型号的机顶盒是自动安装外，当你选择 0 进行自选 .dtb 文件安装时，需要填写具体的 .dtb 文件名称，你可以从这里查阅准确的文件名并填写，具体参见 [amlogic-dtb](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb)

### 升级 OpenWrt

- 从浏览器访问 OpenWrt 的 IP 如: 192.168.1.1 →  `使用账户登录进入 openwrt` → `系统菜单` → `文件传输` → 上传固件包 ***`openwrt*.img.gz (支持的后缀有: *.img.xz, *.img.gz, *.7z, *.zip)`*** 到默认的上传路径 ***`/tmp/upload/`***, 然后在 `系统菜单` → `TTYD 终端` → 输入升级命令:

```yaml
openwrt-update
```

💡提示: 升级脚本会自动从 `/mnt/mmcblk*p4/` 和 `/tmp/upload/` 两个目录中寻找各种后缀的升级文件，你可以通过 `openwrt` → `系统菜单` → `文件传输` 将升级固件的压缩包上传到默认的上传路径 `/tmp/upload/` ，也可以借助 WinSCP 等软件将升级固件手动上传至 `/mnt/mmcblk*p4/` 目录下。

如果在 `/mnt/mmcblk*p4/` 和 `/tmp/upload/` 目录下仅有一个符合要求的升级文件时，你可以直接运行升级命令 `openwrt-update` 进行升级，无需输入固件名称的参数。如果这 2 个目录中有多个符合要求的可用于升级 OpenWrt 的文件时，请在 `openwrt-update` 命令后面空格，并输入 `你指定使用的升级固件`（如 `openwrt-update  openwrt_s905x3_v5.4.105_2021.03.17.0412.img.gz` ）。升级脚本优先查找 `/mnt/mmcblk*p4/` 目录，如果该目录下没有符合要求的升级固件，将去 `/tmp/upload/` 下继续查找。这 2 个目录中的相关压缩文件，升级脚本会自动匹配进行解压，升级完成后会自动删除此升级固件文件。

- 升级脚本 `openwrt-update` 在 2 处目录中的查找顺序说明

| 目录 | `/mnt/mmcblk*p4/` 1-6 | `/tmp/upload/` 7-10 |
| ---- | ---- | ---- |
| 顺序 | `你指定使用的升级固件` → `*.img` → `*.img.xz` → `*.img.gz` → `*.7z` → `*.zip` → | `*.img.xz` → `*.img.gz` → `*.7z` → `*.zip` |

### 备份与恢复

你可以在需要的时候随时备份和恢复软件配置信息，软件清单可以根据自己的需要调整: [openwrt-backup](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/common-files/files/usr/bin/openwrt-backup) 。请根据提示进行选择，如选择 `b` 是备份，选择 `r` 是恢复。

- 从浏览器访问 OpenWrt 的默认 IP: 192.168.1.1 → `使用默认账户登录进入 openwrt` → `系统菜单` → `TTYD 终端` → 输入命令: 

```yaml
openwrt-backup
```

在使用 `openwrt-update` 命令进行软件更新时，也会咨问你是否保留当前的配置，如果选择了 `y` ，在更新完成后，将自动恢复当前软件的配置信息。如果当前版本中某个软件的配置信息和旧版有差异，可能恢复后的配置不能正常使用，请手动清空这个软件的配置信息并重新配置。

### 安装 bootloader

如果你的机顶盒是 X96-Max+ ，你在 TF 卡中使用的 OpenWrt 固件，默认支持的是百兆的网卡的 .dtb 文件，当你写入 EMMC 后，安装/升级脚本将自动改为支持千兆的网卡的 .dtb 文件，同时自动安装 HK1 的 bootloader 文件，以便支持千兆网卡正常运行。

```shell script
dd if=/lib/u-boot/hk1box-bootloader.img  of=/dev/mmcblk2 bs=1 count=442 conv=fsync 2>/dev/null
dd if=/lib/u-boot/hk1box-bootloader.img  of=/dev/mmcblk2 bs=512 skip=1 seek=1 conv=fsync 2>/dev/null
sync
reboot
```

在使用 Phicomm-n1 时，会安装此 bootloader 文件。

```shell script
dd if=/lib/u-boot/u-boot-2015-phicomm-n1.bin of=/dev/mmcblk1
sync
reboot
```

## 关于 Amlogic S9xxx 系列机顶盒 .dtb 文件对应关系等说明

| 序号 | 型号 | 说明 | DTB |
| ---- | ---- | ---- | ---- |
| 1 | X96-Max+ | S905x3: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-sm1-x96-max-plus.dtb |
| 2 | X96-Max+ | 905x3: NETWORK: 1000M / TF: 30Mtz / CPU: 2208Mtz | meson-sm1-x96-max-plus-oc.dtb |
| 3 | HK1-Box | S905x3: NETWORK: 1000M / TF: 25Mtz / CPU: 2124Mtz | meson-sm1-hk1box-vontar-x3.dtb |
| 4 | HK1-Box | S905x3: NETWORK: 1000M / TF: 25Mtz / CPU: 2184Mtz | meson-sm1-hk1box-vontar-x3-oc.dtb |
| 5 | H96-Max-X3 | S905x3: NETWORK: 1000M / TF: 50Mtz / CPU: 2124Mtz | meson-sm1-h96-max-x3.dtb |
| 6 | H96-Max-X3 | S905x3: NETWORK: 1000M / TF: 50Mtz / CPU: 2208Mtz | meson-sm1-h96-max-x3-oc.dtb |
| 7 | X96-Max-4G | S905x2: NETWORK: 1000M / TF: 50Mtz / CPU: 1944Mtz | meson-g12a-x96-max.dtb |
| 8 | X96-Max-2G | S905x2: NETWORK: 100M  / TF: 50Mtz / CPU: 1944Mtz | meson-g12a-x96-max-rmii.dtb |
| 9 | Belink GT-King | S922x: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-g12b-gtking.dtb |
| 10 | Belink GT-King Pro | S922x: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-g12b-gtking-pro.dtb |
| 11 | UGOOS AM6 Plus | S922x: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-g12b-ugoos-am6.dtb |
| 12 | Octopus-Planet | S912: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-gxm-octopus-planet.dtb |
| 13 | Phicomm-n1 | S905d: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-gxl-s905d-phicomm-n1.dtb |
| 14 | hg680p & b860h | S905x: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-gxl-s905x-p212.dtb |
| 0 | Other | - | Enter the dtb file name of your box |

 在自选 .dtb 文件进行安装时，你可以从 [dtb](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb) 库里查阅相关文件名并填写。

## 设置 Amlogic S9xxx 系列机顶盒从 USB 中启动

- 开启开发者模式: 设置 → 关于本机 → 版本号 (如: X96max plus...), 在版本号上快速连击 7 次鼠标左键, 系统将提示开启开发者模式。
- 开启 USB 调试模式: 重启后，再次进入 → 系统 → 高级选选 → 开发者选项 (设置 `开启USB调试` 为启用)
- 从 USB 启动: 拔掉电源 → 插入 USB → 使用牙签等工具插入 AV 孔并顶住里面的复位键不要放 (此位置在重置按钮上面) → 插入电源 → 等待 5 秒后松开复位键 → OpenWrt 系统将从 USB 中启动。
- 登录 OpenWrt 系统: 将你的机顶盒与电脑进行直连 → 关闭电脑的 WIFI 选项，只使用有线网卡 → 将有线网卡的网络设置为和 OpenWrt 相同的网段，如果 OpenWrt 的默认 IP 是: `192.168.1.1` ，你可以设置电脑的 IP 为 `192.168.1.2` ，子网掩码设置为 `255.255.255.0`, 除这 2 个选项外，其他选项不用设置。你就可以从浏览器进入 OpwnWrt 了，默认 IP : `192.168.1.1`, 默认账号: `root`, 默认密码: `password`

## 安装/升级失败后如何救砖

- 一般情况下，重新插入电源，如果可以从 USB 中启动，只要重新安装即可，多试几次。

- 如果接入显示器后，屏幕是黑屏状态，无法从 USB 启动，就需要进行机顶盒的短接初始化了。先将机顶盒恢复到原来的安卓系统，再重新刷入 OpenWrt 系统。

```
以 x96max+ 为例

刷机准备：

1. [ 准备一条 USB 双公头数据线 ]: https://www.ebay.com/itm/152516378334
2. [ 准备一个曲别针 ]: https://www.ebay.com/itm/133577738858
3. 下载刷机软件和机顶盒的 Android TV 固件包
   [ 安装刷机软件 USB_Burning_Tool ]: https://androidmtk.com/download-amlogic-usb-burning-tool
   [ 下载 Android TV 固件包 ]: https://xdafirmware.com/x96-max-plus-2
4. [ 在机顶盒的主板上确认短接点的位置 ]:
   https://user-images.githubusercontent.com/68696949/110590933-67785300-81b3-11eb-9860-986ef35dca7d.jpg

操作方法：

1. 使用 [ USB 双公头数据线 ] 将 [ 机顶盒 ] 与 [ 电脑 ] 进行连接。
2. 打开刷机软件 USB Burning Tool:
   [ 文件 → 导入固件包 ]: X96Max_Plus2_20191213-1457_ATV9_davietPDA_v1.5.img
   [ 选择 ]：擦除 flash
   [ 选择 ]：擦除 bootloader
   点击 [ 开始 ] 按钮
3. 使用 [ 曲别针 ] 将机顶盒主板上的 [ 两个短接点进行短接连接 ]。
   如果进度条没有走动，可以尝试插入电源。通长情况下不用电源支持供电，只 USB 双公头的供电即可满足刷机要求。
4. 当看到 [ 进度条开始走动 ] 后，拿走曲别针，不再短接。
5. 当看到 [ 进度条 100% ], 则刷机完成，机顶盒已经恢复成 Android TV 系统。
   点击 [ 停止 ] 按钮, 拔掉 [ 机顶盒 ] 和 [ 电脑 ] 之间的 [ USB 双公头数据线] 。
6. 如果以上某个步骤失败，就再来一次，直至成功。
```

当完成恢复出厂设置，机顶盒已经恢复成 Android TV 系统，其他安装 OpenWrt 系统的操作，就和你之前第一次安装系统时的要求一样了，再来一遍即可。使用写盘软件把 OpenWrt 写入 USB，将写好的 USB 插入机顶盒，使用牙签等顶住机顶盒的 AV 孔里的复位键，插入电源，等待 5 秒后松开牙签顶着的复位键，OpenWrt 将从 USB 中启动。

## 在安装了主线 u-boot 后无法启动

- 有的 Amlogic S905x3 在安装 5.10 内核时，如果选择写入主线 `u-boot` 后，可能会无法启动，在显示器中看到的提示为 `=>` 符号结尾的一段代码。这时你需要在 TTL 上焊接一个 5-10 K 的上拉或下拉电阻，解决机顶盒容易受周围电磁信号干扰而导致无法启动的问题，焊接电阻后就可以从 EMMC 启动了。
- 鉴于主线 `u-boot` 当前可能会造成无法从 EMMC 启动的问题，在安装脚本中已经默认关闭了对选择主线 `u-boot` 的提示，等 Flippy 后续升级稳定后再启用。
- 如果你想尝鲜体验主线 `u-boot` ，可以使用 `openwrt-install TEST-UBOOT` 安装命令，脚本将会在已经添加主线 `u-boot` 的相关盒子安装时出现选择提示。但是我们不推荐你这样做，除非你已经了解焊接电阻的方法，或者愿意做版本测试的志愿者。

如果你选择安装了主线 `u-boot` 并且无法启动，请将机顶盒接入屏幕，查看是否为这样的提示：

```
Net: eth0: ethernet0ff3f0000
Hit any key to stop autoboot: 0
=>
```

如果你的现象如上所示，那么你需要在 TTL 上焊接一个电阻了: [X96 Max Plus's V4.0 主板示意图](https://user-images.githubusercontent.com/68696949/110910162-ec967000-834b-11eb-8fa6-64727ccbe4af.jpg)

```
#######################################################            #####################################################
#                                                     #            #                                                   # 
#   上拉电阻: 在 TTL 的 RX 和 GND 之间焊接              #            #   下拉电阻: 在 TTL 的 3.3V 和 RX 之间焊接           #
#                                                     #            #                                                   #
#            3.3V   RX       TX       GND             #     OR     #        3.3V               RX     TX     GND       #
#                    ┖————█████████————┚              #            #         ┖————█████████————┚                       #
#                      上拉电阻（5~10K）               #            #            下拉电阻 (5~10K)                        #
#                                                     #            #                                                   #
#######################################################            #####################################################
```

