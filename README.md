# OpenWrt

View Chinese description | [查看中文说明](README.cn.md)

[OpenWrt](https://openwrt.org/) is a Linux-based router operating system designed for embedded devices. Unlike a single, unmodifiable firmware, OpenWrt provides a fully writable file system with package management capabilities, allowing users to freely choose the software packages they need to customize their router system. For developers, OpenWrt is a framework that allows them to develop applications without having to build a complete firmware around it. For regular users, this means having the ability to fully customize and use the device in unexpected ways. It offers over 3000 standardized application software packages and extensive third-party plugin support, making it easy to apply them to various supported devices. Now you can replace the Android TV system on your TV box with OpenWrt, turning it into a powerful router.

This project relies on many [contributors](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/CONTRIBUTORS.md) to build OpenWrt systems for `Amlogic`, `Rockchip`, and `Allwinner` boxes. It supports writing to eMMC, updating the kernel, and other functions. For detailed instructions on how to use it, please refer to the [OpenWrt Documentation](./make-openwrt/documents). The latest firmware can be downloaded from [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases). You are welcome to `Fork` and customize the software package according to your needs. If it is useful to you, please click `Star` in the upper right corner of the repository to show your support.

## OpenWrt System Description

| SoC  | Device | [Kernel](https://github.com/ophub/kernel) | [OpenWrt](https://github.com/ophub/amlogic-s9xxx-openwrt/releases) |
| ---- | ---- | ---- | ---- |
| a311d | [Khadas-VIM3](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/99) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_a311d.img |
| s922x | [Beelink-GT-King](https://github.com/ophub/amlogic-s9xxx-armbian/issues/370), [Beelink-GT-King-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/707), [Ugoos-AM6-Plus](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/213), [ODROID-N2](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/201), [X88-King](https://github.com/ophub/amlogic-s9xxx-armbian/issues/988), [Ali-CT2000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1150) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s922x.img |
| s905x3 | [X96-Max+](https://github.com/ophub/amlogic-s9xxx-armbian/issues/351), [HK1-Box](https://github.com/ophub/amlogic-s9xxx-armbian/issues/414), [Vontar-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1006), [H96-Max-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1250), [Ugoos-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/782), [TX3(QZ)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/644), [TX3(BZ)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1077), [X96-Air](https://github.com/ophub/amlogic-s9xxx-armbian/issues/366), [X96-Max+_A100](https://github.com/ophub/amlogic-s9xxx-armbian/issues/779), [A95XF3-Air](https://github.com/ophub/amlogic-s9xxx-armbian/issues/157), [Tencent-Aurora-3Pro(s905x3-b)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/506), [X96-Max+Q1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/788), [X96-Max+100W](https://github.com/ophub/amlogic-s9xxx-armbian/issues/909), [X96-Max+_2101](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1086), [Infinity-B32](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1181), [Whale](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1166) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905x3.img |
| s905x2 | [X96Max-4G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/453), [X96Max-2G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/95), [MECOOL-KM3-4G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/79), [Tanix-Tx5-Max](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/351), [A95X-F2](https://github.com/ophub/amlogic-s9xxx-armbian/issues/851) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905x2.img |
| s912 | [Tanix-TX8-Max](https://github.com/ophub/amlogic-s9xxx-armbian/issues/500), [Tanix-TX9-Pro(3G)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/315), [Tanix-TX9-Pro(2G)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/740), [Tanix-TX92](https://github.com/ophub/amlogic-s9xxx-armbian/issues/72#issuecomment-1012790770), [Nexbox-A1](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/260), [Nexbox-A95X-A2](https://www.cafago.com/en/p-v2979eu-2g.html),  [A95X](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/260), [H96-Pro-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/72#issuecomment-1013071513), [VORKE-Z6-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/72), [Mecool-M8S-PRO-L](https://github.com/ophub/amlogic-s9xxx-armbian/issues/158), [Vontar-X92](https://github.com/ophub/amlogic-s9xxx-armbian/issues/525), [T95Z-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/668), [Octopus-Planet](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1020), [Phicomm-T1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/522) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s912.img |
| s905d | [MECOOL-KI-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/59), [Phicomm-N1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/925) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905d.img |
| s905x | [HG680P](https://github.com/ophub/amlogic-s9xxx-armbian/issues/368), [B860H](https://github.com/ophub/amlogic-s9xxx-armbian/issues/60), [TBee-Box](https://github.com/ophub/amlogic-s9xxx-armbian/issues/98), [T95](https://github.com/ophub/amlogic-s9xxx-armbian/issues/285), [TX9](https://github.com/ophub/amlogic-s9xxx-armbian/issues/645), [XiaoMI-3S](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1405) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905x.img |
| s905w | [X96-Mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/621), [TX3-Mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1062), [W95](https://github.com/ophub/amlogic-s9xxx-armbian/issues/570), [X96W/FunTV](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1044), [MXQ-Pro-4K](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1140) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905w.img |
| s905l2 | [MGV2000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/648), [MGV3000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/921), [Wojia-TV-IPBS9505](https://github.com/ophub/amlogic-s9xxx-armbian/issues/648), [M301A](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/405), [E900v21E](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1278) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905l2.img |
| s905l3 | [CM211-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1318), [CM311-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/763), [HG680-LC](https://github.com/ophub/amlogic-s9xxx-armbian/issues/978), [M401A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/921#issuecomment-1453143251), [UNT400G1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1277) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905l3.img |
| s905l3a | [E900V22C/D](https://github.com/Calmact/e900v22c), [CM311-1a-YST](https://github.com/ophub/amlogic-s9xxx-armbian/issues/517), [M401A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/732), [M411A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/517), [UNT403A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/970), [UNT413A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/970), [ZTE-B863AV3.2-M](https://github.com/ophub/amlogic-s9xxx-armbian/issues/741) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905l3a.img |
| s905l3b | [CM211-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1180), [CM311-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1268), [E900V22D](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1256), [E900V22E](https://github.com/ophub/amlogic-s9xxx-armbian/issues/939), [M302A/M304A](https://github.com/ophub/amlogic-s9xxx-armbian/pull/615), [Hisense-IP103H](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1154), [TY1608](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1332) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905l3b.img |
| s905lb | [Q96-mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/734), [BesTV-R3300L](https://github.com/ophub/amlogic-s9xxx-armbian/pull/993), [SumaVision-Q7](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1190) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905lb.img |
| s905 | [Beelink-Mini-MX-2G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/127), [Sunvell-T95M](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/337), [MXQ-Pro+4K](https://github.com/ophub/amlogic-s9xxx-armbian/issues/715), [SumaVision-Q5](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1175) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905.img |
| rk3588 | [Radxa-Rock5B](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1240), [HinLink-H88K](http://www.hinlink.com/index.php?id=151), [Beelink-IPC-R](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/415) | [rk3588](https://github.com/ophub/kernel/releases/tag/kernel_rk3588) | rockchip_boxname.img |
| rk3568 | [FastRhino-R66S](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1061), [FastRhino-R68S](https://github.com/ophub/amlogic-s9xxx-armbian/issues/774), [HinLink-H66K](http://www.hinlink.com/index.php?id=137), [HinLink-H68K](http://www.hinlink.com/index.php?id=119), [Radxa-E25](https://wiki.radxa.com/Rock3/CM/CM3I/E25), [NanoPi-R5S](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1217) | [6.x.y](https://github.com/ophub/kernel/releases/tag/kernel_stable) | rockchip_boxname.img |
| rk3566 | [Panther-X2](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1319) | [6.x.y](https://github.com/ophub/kernel/releases/tag/kernel_stable) | rockchip_boxname.img |
| rk3399 | [EAIDK-610](https://github.com/ophub/amlogic-s9xxx-armbian/pull/991), [King3399](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1080), [TN3399](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1094), [Kylin3399](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1132), [ZCube1-Max](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1247), [CRRC](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1280), [SMART-AM40](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1317), [SW799](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1326), [ZYSJ](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1380) | [6.x.y](https://github.com/ophub/kernel/releases/tag/kernel_stable) | rockchip_boxname.img |
| rk3328 | [BeikeYun](https://github.com/ophub/amlogic-s9xxx-armbian/issues/852), [L1-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1007), [Station-M1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1313), [Bqeel-MVR9](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1313) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | rockchip_boxname.img |
| h6 | [Vplus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1100), [Tanix-TX6](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1120) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | allwinner_boxname.img |

💡Note: Currently, [s905 boxes](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1173) can only be used with `TF/SD/USB`, while other models of boxes can support writing to `EMMC`. For more information, please refer to the [Supported Device List Description](make-openwrt/openwrt-files/common-files/etc/model_database.conf). You can refer to Chapter 12.15 of the documentation for the method on [Adding New Supported Devices](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/build-armbian/documents/README.md#1215-how-to-add-support-for-new-devices).

## Installation and Upgrade Instructions

Select the OpenWrt image that corresponds to your TV box model and refer to the corresponding instructions for usage of different devices.

- ### Install OpenWrt

1. For installation instructions on the `Rockchip` platform, please refer to Chapter 8 in the [Documentation](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian/documents#8-install-armbian-to-emmc). The installation process is the same as that for Armbian.

2. For the `Amlogic` and `Allwinner` platforms, use tools such as Rufus or balenaEtcher to write the firmware into a USB drive, then insert the USB into the device. Access OpenWrt's default IP address from your browser: 192.168.1.1 → `log in to OpenWrt using the default credentials` → `System Menu` → `Amlogic Service` → `Install OpenWrt`. Select your device from the list of supported devices, and click the `Install OpenWrt` button to start the installation process.

- ### Update OpenWrt

Access OpenWrt's IP address from your browser, such as 192.168.1.1 → `Log in to OpenWrt using the account` → `System Menu` → `Amlogic Service` → `Manually Upload Update / Download Update Online`. From there, you can choose to manually upload an update or download an update online.

If you choose to `Manually Upload Update`, you can upload the compiled OpenWrt firmware package, such as openwrt_xxx_k5.15.50.img.gz (it is recommended to upload the compressed package, as the system will automatically decompress it). If you upload a xxx.img format file that has been decompressed, the upload may fail due to its large size. Once the upload is complete, the interface will display an `Update Firmware` button. Click this button to update the firmware.

If you choose to `Manually Upload Update`, you can upload the 3 kernel files `boot-xxx.tar.gz`, `dtb-xxx.tar.gz`, and `modules-xxx.tar.gz` (other kernel files are not required, but uploading them will not affect the update, as the system can accurately identify the necessary kernel files). Once the upload is complete, the interface will display an `Update Kernel` button. Click this button to update the kernel.

If you choose to `Download Update Online` for OpenWrt firmware or kernel, it will be downloaded based on the `Firmware Download Address` and `Kernel Download Address` settings in the plugin. You can customize and modify the download source. For detailed instructions on how to do this, please refer to the compilation and usage instructions of [luci-app-amlogic](https://github.com/ophub/luci-app-amlogic).

- ### Creating swap for OpenWrt

If you are using memory-intensive applications such as `docker` and find that the current box doesn't have enough memory, you can create a `swap` virtual memory partition that virtualizes a certain capacity of `/mnt/*4` disk space to use as memory. The unit used in the following command input parameters is `GB`, and the default is `1`.

Access OpenWrt's default IP 192.168.1.1 from your browser → `Log in to OpenWrt using the default account` → `System Menu` → `TTYD Terminal` → Enter the following command:

```yaml
openwrt-swap 1
```

- ### Backing up/Restoring eMMC Original System

Support for backing up/restoring eMMC partitions using `TF/SD/USB`. Before installing OpenWrt on your box, it is recommended to backup the pre-installed Android TV system in case you need to restore it later.

Boot the OpenWrt system from `TF/SD/USB`, access OpenWrt's default IP 192.168.1.1 from your browser → `Log in to OpenWrt using the default account` → `System Menu` → `TTYD Terminal` → Enter the following command:

```yaml
openwrt-ddbr
```

Follow the prompt to enter `b` to backup the system or `r` to restore the system.

- ### Controlling the LED display

Access OpenWrt's default IP 192.168.1.1 from your browser → `Log in to OpenWrt using the default account` → `System Menu` → `TTYD Terminal` → Enter the following command:

```yaml
openwrt-openvfd
```

Follow the [LED Screen Display Control Instructions](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/build-armbian/documents/led_screen_display_control.md) for debugging.

- ### More usage instructions

Using the `firstboot` command allows you to restore the system to its initial state. For common issues that may be encountered when using OpenWrt, please refer to the [documentation](./make-openwrt/documents).

## Local build instructions

1. Installing necessary build dependencies (for Ubuntu 22.04 LTS users)
```yaml
sudo apt-get update -y
sudo apt-get full-upgrade -y
# For Ubuntu-22.04
sudo apt-get install -y $(curl -fsSL https://is.gd/depend_ubuntu2204_openwrt)
```
2. Clone the repository to your local machine using `git clone --depth 1 https://github.com/ophub/amlogic-s9xxx-openwrt.git`.
3. Create a `openwrt-armvirt` folder in the root directory of `~/amlogic-s9xxx-openwrt` and upload the `openwrt-armvirt-64-default-rootfs.tar.gz` file to this directory.
4. In the root directory of `~/amlogic-s9xxx-openwrt`, enter the packaging command, such as `sudo ./make -b s905x3 -k 6.1.10`. The OpenWrt firmware generated by the packaging process will be placed in the `out` folder in the root directory.

- ### Local packaging parameters

| Parameter | Meaning       | Description               |
| --------- | ------------- | ------------------------- |
| -b       | Board      | Specify the TV box model using `-b`, such as `-b s905x3`. Multiple models can be specified using `_`, such as `-b s905x3_s905d`. Use `all` to indicate all models. Model codes can be found in the `BOARD` setting of [model_database.conf](make-openwrt/openwrt-files/common-files/etc/model_database.conf). The default value is `all`. |
| -r       | KernelRepo | Specify the `<owner>/<repo>` of the kernel repository on github.com. The default value is `ophub/kernel`. |
| -u       | kernelUsage | Set the `tags suffix` of the kernel to be used, such as [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable), [flippy](https://github.com/ophub/kernel/releases/tag/kernel_flippy), [dev](https://github.com/ophub/kernel/releases/tag/kernel_dev). The default value is `stable`. |
| -k       | Kernel     | Specify the kernel name, such as `-k 5.10.125`. Multiple kernels can be specified using `_`, such as `-k 5.10.125_5.15.50`. The kernel version specified by the `-k` parameter is only valid for the `stable/flippy/dev` kernel series. Other kernel series such as [rk3588](https://github.com/ophub/kernel/releases/tag/kernel_rk3588) can only use specific kernels. |
| -a       | AutoKernel | Set whether to automatically use the latest version of the same series kernel. When set to `true`, it will automatically search for newer versions of the same series specified in `-k`, such as version 5.10.125, and if there is a newer version after 5.10.125, it will be replaced with the latest version automatically. When set to `false`, the specified version of the kernel will be compiled. The default value is `true`. |
| -s       | Size       | Set the size of the ROOTFS partition of the system, which must be greater than 2048MiB. For example: `-s 2560`. The default value is `2560`. |
| -g        | GH_TOKEN      | Optional. Set `${{ secrets.GH_TOKEN }}` for querying [api.github.com](https://docs.github.com/en/rest/overview/resources-in-the-rest-api?apiVersion=2022-11-28#requests-from-personal-accounts). The default value is `none`. |


- `sudo ./make`: Package for all TV box models using the latest kernel package in the kernel library with default configuration.
- `sudo ./make -b s905x3 -k 6.1.10`: Package for a specific model (`s905x3`) and kernel version (`6.1.10`) with default configuration (recommended).
- `sudo ./make -b s905x3_s905d -k 6.1.10_5.15.50`: Package for multiple models (`s905x3` and `s905d`) and kernels (`6.1.10` and `5.15.50`) simultaneously with default configuration.
- `sudo ./make -b s905x3 -k 6.1.10 -s 1024`: Package for a specific model (`s905x3`) and kernel version (`6.1.10`) with default configuration, and set the firmware size to 1024 MiB.
- `sudo ./make -b s905x3_s905d`: Package for all models (`s905x3` and `s905d`) with default configuration and all available kernels.
- `sudo ./make -k 6.1.10_5.15.50`: Package for all TV box models with multiple specified kernel versions (`6.1.10` and `5.15.50`) with default configuration.
- `sudo ./make -k 6.1.10_5.15.50 -a true`: Package for all TV box models with multiple specified kernel versions (`6.1.10` and `5.15.50`) with default configuration, and automatically upgrade to the latest version of the same series kernel if available.
- `sudo ./make -s 1024 -k 6.1.10`: Package for all TV box models with a specific kernel version (`6.1.10`) and set the firmware size to 1024 MiB with default configuration.

## Compiling with GitHub Actions

You can customize and compile OpenWrt firmware that suits you by modifying the personalized firmware configuration files in the [config-openwrt](config-openwrt) directory, as well as the [.yml](.github/workflows) files. The firmware can be uploaded to `Actions` and `Releases` on github.com.

1. You can find personalized firmware configuration instructions in the [documentation](./make-openwrt/documents). The workflow control file is [.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt-with-lede.yml).
2. Freshly compile: On github.com's [Action](https://github.com/ophub/amlogic-s9xxx-openwrt/actions) page, select ***`Build OpenWrt`***. Click the ***`Run workflow`*** button to perform one-stop firmware compilation and packaging.
3. Re-compile: If there is already a compiled `openwrt-armvirt-64-default-rootfs.tar.gz` file in [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases), and you only want to make another box of a different board, you can skip compiling the OpenWrt source file and go directly to the secondary production. On the [Actions](https://github.com/ophub/amlogic-s9xxx-openwrt/actions) page, select ***`Use Releases file to Packaging`*** and click the ***`Run workflow`*** button to re-compile.
4. More support: The compiled `openwrt-armvirt-64-default-rootfs.tar.gz` file is a universal file for making various board firmware. It is also suitable for making OpenWrt firmware using [unifreq](https://github.com/unifreq/openwrt_packit)'s packaging script. As the pioneer of using OpenWrt and Armbian systems in boxes, it supports more devices, such as OpenWrt used in [Armbian](https://github.com/ophub/amlogic-s9xxx-armbian) system through `KVM` virtual machine ([QEMU version](https://github.com/unifreq/openwrt_packit/blob/master/files/qemu-aarch64/qemu-aarch64-readme.md)), Amlogic, Rockchip, and Allwinner series. For packaging methods, please refer to its repository instructions. You can call his packaging script to make more firmware through [packaging-openwrt-for-qemu-etc.yml](.github/workflows/packaging-openwrt-for-qemu-etc.yml) in Actions.

```yaml
- name: Package Armvirt as OpenWrt
  uses: ophub/amlogic-s9xxx-openwrt@main
  with:
    openwrt_path: openwrt/bin/targets/*/*/*rootfs.tar.gz
    openwrt_board: s905x3_s905x2_s905x_s905w_s905d_s922x_s912
    openwrt_kernel: 6.1.10_5.15.50
    gh_token: ${{ secrets.GH_TOKEN }}
```

- ### GitHub Actions Input Parameter Description

The related parameters correspond to the `local packaging command`, please refer to the above instructions.

| Parameter          | Defaults         | Description                     |
| ------------------ | ---------------- | ------------------------------- |
| openwrt_path       | None             | You can set the file path of `openwrt-armvirt-64-default-rootfs.tar.gz` using a relative path such as `openwrt/bin/targets/*/*/*rootfs.tar.gz` or a network file download address such as `https://github.com/*/releases/*/*rootfs.tar.gz`. |
| openwrt_board      | all              | You can set the `board` for packaging the box, which is equivalent to using `-b` function. |
| kernel_repo        | ophub/kernel     | You can specify the `<owner>/<repo>` of the GitHub kernel repository, which is equivalent to using the `-r` function. |
| kernel_usage       | stable           | You can set the `tags suffix` of the kernel used, which is equivalent to using the `-u` function. |
| openwrt_kernel     | 6.1.1_5.15.1     | You can set the kernel version, which is equivalent to using the `-k` function. |
| auto_kernel        | true             | You can set whether to automatically use the latest kernel version in the same series, which is equivalent to using the `-a` function. |
| openwrt_size       | 1024             | You can set the size of the firmware rootfs partition, which is equivalent to using the `-s` function. |
| gh_token           | None             | This is an optional parameter. You can set `${{ secrets.GH_TOKEN }}`, which is equivalent to using the `-g` function. |

- ### GitHub Actions Output Variable Description

To upload to `Releases`, you need to add `${{ secrets.GITHUB_TOKEN }}` and `${{ secrets.GH_TOKEN }}` to the repository and set `Workflow read/write permissions`. For more information, please refer to [the usage instructions](./make-openwrt/documents/README.md#2-set-the-privacy-variable-github_token).

| Parameter                                | For example         | Description                         |
|------------------------------------------|---------------------|-------------------------------------|
| ${{ env.PACKAGED_OUTPUTPATH }}           | out                 | OpenWrt firmware storage path       |
| ${{ env.PACKAGED_OUTPUTDATE }}           | 04.13.1058          | Packing date(month.day.hour.minute) |
| ${{ env.PACKAGED_STATUS }}               | success / failure   | Package status                      |

## openwrt-*-rootfs.tar.gz Firmware compilation parameters

| Option | Value |
| ---- | ---- |
| Target System | QEMU ARM Virtual Machine |
| Subtarget | QEMU ARMv8 Virtual Machine(cortex-a53) |
| Target Profile | Default |
| Target Images | tar.gz |

For more instructions please see: [documents](./make-openwrt/documents)

## OpenWrt firmware default information

| Name | Value |
| ---- | ---- |
| Default IP | 192.168.1.1 |
| Default username | root |
| Default password | password |
| Default WIFI name | OpenWrt |
| Default WIFI password | none |

## Compile the kernel

For more information on how to compile the kernel, please refer to [compile-kernel](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/compile-kernel).

```yaml
- name: Compile the kernel
  uses: ophub/amlogic-s9xxx-armbian@main
  with:
    build_target: kernel
    kernel_version: 6.1.10_5.15.50
    kernel_auto: true
    kernel_sign: -yourname
```

## Resource Description

When making the OpenWrt system, the [kernel](https://github.com/ophub/kernel) and [u-boot](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian/u-boot) files used are the same as those used to make the [Armbian](https://github.com/ophub/amlogic-s9xxx-armbian) system. In order to avoid duplicate maintenance, the relevant content is classified and placed in the corresponding resource repository, and will be automatically downloaded from the relevant repository when used.

The `kernel` / `u-boot` and other resources used by this system are mainly copied from the [unifreq/openwrt_packit](https://github.com/unifreq/openwrt_packit) project, and some files are shared by users in the [Pulls](https://github.com/ophub/amlogic-s9xxx-openwrt/pulls) and [Issues](https://github.com/ophub/amlogic-s9xxx-openwrt/issues) of projects such as [amlogic-s9xxx-openwrt](https://github.com/ophub/amlogic-s9xxx-openwrt) / [amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian) / [luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) / [kernel](https://github.com/ophub/kernel). `Unifreq` opened the door for us to use OpenWrt on TV boxes, and my firmware inherited his consistent standards in production and use. In order to thank these pioneers and sharers, I have recorded them in [CONTRIBUTORS.md](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/CONTRIBUTORS.md). Thank you again for giving new life and meaning to the box.

## Other distributions

- [Unifreq](https://github.com/unifreq/openwrt_packit) has created `OpenWrt` systems for more boxes such as Amlogic, Rockchip, and Allwinner, which is a benchmark in the box community and recommended for use.
- The [amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian) project provides the `Armbian` system for use on boxes, which is also applicable to related devices that support OpenWrt.

## Links

- [unifreq](https://github.com/unifreq/openwrt_packit)
- [OpenWrt](https://github.com/openwrt/openwrt)
- [coolsnowwolf](https://github.com/coolsnowwolf/lede)
- [immortalwrt](https://github.com/immortalwrt/immortalwrt)

## License

The amlogic-s9xxx-openwrt © OPHUB is licensed under [GPL-2.0](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/LICENSE)

