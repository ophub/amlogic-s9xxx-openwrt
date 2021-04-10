# 添加更多 Amlogic S9xxx OpenWrt 内核

查看英文说明 | [View English description](README.md)

***`Flippy`*** 分享了他的众多内核包，让我们在 Amlogic S9xxx 机顶盒中使用 OpenWrt 变的如此简单。我们珍藏了很多内核包，你可以在 [kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel) 目录里查阅。如果你想构建内核目录里没有的其他内核，可以使用仓库中的 [openwrt-kernel](openwrt-kernel) 脚本从 Flippy 分享的 Armbian/OpenWrt 固件中进行自动提取和生成。或直接将 Flippy 的原版内核放入仓库进行使用。

本仓库使用 Flippy 提供的 3 个内核文件进行 OpenWrt 固件打包，你可以自由选择喜欢的内核进行使用。

## 从 Armbian 或 OpenWrt 固件中提取内核

```shell script
Example: ~/*/amlogic-s9xxx/amlogic-kernel/build-kernel/
 ├── flippy
 │   ├── S9***_Openwrt*.img            #Support suffix: .img/.7z/.img.xz, Use Flippy's S9***_Openwrt*.img files
 │   └── OR: Armbian*Aml-s9xxx*.img    #Support suffix: .img/.7z/.img.xz, Use Flippy's Armbian*.img files
 └── sudo ./openwrt-kernel -e
```

当你只有 Flippy 的 Armbian 或 OpenWrt 固件，没有内核文件时，可以将 `Flippy` 分享的固件放入 `~/*/amlogic-s9xxx/amlogic-kernel/build-kernel/flippy` 目录下，直接运行 `sudo ./openwrt-kernel -e` 命令即可自动完成内核提取和生成，生成的 3 个内核文件（boot-${flippy_version}.tar.gz, dtb-amlogic-${flippy_version}.tar.gz & modules-${flippy_version}.tar.gz）完全执行 Flippy 的文件结构标准，与其原版内核完全一样。

此脚本在本仓库默认路径使用时，生成的文件将自动保存至内核固定存放目录 `~/*/amlogic-s9xxx/amlogic-kernel/kernel` 中。本脚本也支持单独复制到任意仓库，任意位置独立使用，生成的文件夹以内核版本号命名（如：5.4.105），存放在脚本的相同目录下。

相同内核版本号的固件，任选一个进行内核提取制作即可，从 Armbian 及 OpenWrt 提取的内核是一样的，各种不同 Amlogic S9xxx 机顶盒使用的 OpenWrt 固件中提取的内核也是一样的（例如无论你选择的是 `Armbian_20.10_Aml-s9xxx_buster_5.4.105-flippy-55+o.img.xz` ，还是选择了 `openwrt_s905x3_multi_R21.2.1_k5.4.105-flippy-55+o.7z` ，或者你选择了 `openwrt_s905d_n1_R21.2.1_k5.4.105-flippy-55+o.7z` 因为这几个固件的内核都是 `5.4.105` ，所以最终提取的内核是一样的）。

## 直接使用 Flippy 提供的原版内核

```shell script
Example: ~/*/amlogic-s9xxx/amlogic-kernel/kernel/
 └── ${kernel_version} (文件夹名称根据内核版本号进行创建)
     ├── boot-5.4.108-flippy-56+o.tar.gz
     ├── dtb-amlogic-5.4.108-flippy-56+o.tar.gz
     └── modules-5.4.108-flippy-56+o.tar.gz
```
Flippy 的一套内核包由 3 个文件共同组成： `boot-${flippy_version}.tar.gz`, `dtb-amlogic-${flippy_version}.tar.gz`, `modules-${flippy_version}.tar.gz`

将 `Flippy` 分享的一套内核包的 3 个文件直接放入 `~/*/amlogic-s9xxx/amlogic-kernel/kernel/` 目录下 `相应的版本号文件夹内` 即可使用，无需其他操作。

