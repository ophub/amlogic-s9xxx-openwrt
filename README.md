# OpenWrt for Amlogic TV Boxes

View Chinese description  |  [查看中文说明](README.cn.md)

The [OpenWrt](https://openwrt.org/) Project is a Linux router operating system targeting embedded devices. Instead of trying to create a single, static firmware, OpenWrt provides a fully writable filesystem with package management. Allows you to freely choose the software package you need to customize your router system. For developers, OpenWrt is the framework to build an application without having to build a complete firmware around it; for users this means the ability for full customization, to use the device in ways never envisioned. It has more than 3000+ standardized application packages and a very rich third-party plug-in support, so you can easily replicate the same setup on any supported device.

Now you can replace the Android TV system of the TV Boxes with the Amlogic chip with the OpenWrt system, making it a powerful router. This project supports one-stop complete compilation of github.com (compiling from custom software packages to packaging firmware, all in one stop at github.com). Support localized packaging (firmware packaging in local Ubuntu and other environments). including OpenWrt firmware install to EMMC and update related functions. Support Amlogic s9xxx TV Boxes are ***`a311d, s922x, s905x3, s905x2, s905l3a, s912, s905d, s905x, s905w, s905`***, etc. such as ***`Belink GT-King, Belink GT-King Pro, UGOOS AM6 Plus, X96-Max+, HK1-Box, H96-Max-X3, Phicomm-N1, Octopus-Planet, Fiberhome HG680P, ZTE B860H`***, etc.

The latest version of the OpenWrt firmware can be downloaded in [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases). Welcome to use `Fork` for [personalized OpenWrt firmware configuration](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/router-config/README.md). If you like it, Please click the `Star`.

## OpenWrt Firmware instructions

| SoC  | Device | [Optional kernel](https://github.com/ophub/kernel/tree/main/pub/stable) | OpenWrt Firmware |
| ---- | ---- | ---- | ---- |
| a311d | [Khadas-VIM3](https://www.gearbest.com/boards---shields/pp_3008145189226460.html) | All | openwrt_a311d_k*.img |
| s922x | [Beelink-GT-King](https://tokopedia.link/RAgZmOM41db), [Beelink-GT-King-Pro](https://www.gearbest.com/tv-box/pp_3008857542462482.html), [Ugoos-AM6-Plus](https://www.gearbest.com/tv-box/pp_3002820788090799.html), [ODROID-N2](https://www.hardkernel.com/shop/odroid-n2-with-4gbyte-ram-2/) | All | openwrt_s922x_k*.img |
| s905x3 | [X96-Max+](https://www.gearbest.com/tv-box/pp_3001768790621051.html), [HK1-Box](https://tokopedia.link/xhWeQgTuwfb), [H96-Max-X3](https://tokopedia.link/KuWvwoYuwfb), [Ugoos-X3](https://tokopedia.link/duoIXZpdGgb), [TX3](https://www.aliexpress.com/item/1005003772717802.html), [X96-Air](https://www.gearbest.com/tv-box/pp_3002885621272175.html), [A95XF3-Air](https://tokopedia.link/ByBL45jdGgb), [Tencent-Aurora-3Pro(s905x3-b)](https://item.jd.com/100009131339.html) | All | openwrt_s905x3_k*.img |
| s905x2 | [X96Max-4G](https://www.ebay.com/itm/164895650425), [X96Max-2G](https://www.alibaba.com/product-detail/Amlogic-S905X2-Android-TV-Box-X96_62210191636.html), [MECOOL-KM3-4G](https://www.gearbest.com/tv-box/pp_3008133484979616.html) | All | openwrt_s905x2_k*.img |
| s912 | [Tanix-TX8-Max](https://www.tanix-box.com/project-view/tanix-tx8-max-android-tv-box/), [Tanix-TX9-Pro](https://www.gearbest.com/tv-box/pp_759339.html), [Tanix-TX92](http://www.tanix-box.com/project-view/tanix-tx92-android-tv-box-powered-amlogic-s912/), [Nexbox-A1](https://www.gearbest.com/tv-box-mini-pc/pp_424843.html), [Nexbox-A95X-A2](https://www.cafago.com/en/p-v2979eu-2g.html),  [A95X](https://tokopedia.link/zQVlmUfgqqb), [H96-Pro-Plus](https://www.gearbest.com/tv-box-mini-pc/pp_503486.html), [VORKE-Z6-Plus](http://www.vorke.com/project/vorke-z6-2/), [Mecool-M8S-PRO-L](https://www.gearbest.com/tv-box/pp_3005746210753315.html), [Vontar-X92](https://nl.aliexpress.com/i/32734559342.html), [T95Z-Plus](https://www.ebay.com/itm/253466003975), [Octopus-Planet](https://post.smzdm.com/p/a07oer59/) | All | openwrt_s912_k*.img |
| s905d | [MECOOL-KI-Pro](https://www.gearbest.com/tv-box-mini-pc/pp_629409.html), [Phicomm-N1](https://www.cnx-software.com/2019/03/11/phicomm-n1-tv-box-linux-distributions/) | All | openwrt_s905d_k*.img |
| s905x | [HG680P](https://tokopedia.link/HbrIbqQcGgb), [B860H](https://www.zte.com.cn/global/products/cocloud/201707261551/IP-STB/ZXV10-B860H), [TBee-Box](https://www.tbee.com/product/tbee-box/) | All | openwrt_s905x_k*.img |
| s905w | [X96-Mini](https://www.gearbest.com/tv-box/pp_3008306149708795.html), [TX3-Mini](https://www.gearbest.com/tv-box/pp_009748238474.html), [W95](https://www.gearbest.com/tv-box/pp_736121.html) | 5.4.y/5.15.y | openwrt_s905w_k*.img |
| s905 | [Beelink-Mini-MX-2G](https://www.gearbest.com/tv-box-mini-pc/pp_321409.html), [MXQ-PRO+4K](https://www.gearbest.com/tv-box-mini-pc/pp_354313.html) | All | openwrt_s905_k*.img |
| s905l3a | [E900V22C/D](https://github.com/Calmact/e900v22c), [CM311-1a-YST](https://www.znds.com/tv-1216697-1-1.html), [M401A](https://blog.csdn.net/fatiaozhang9527/article/details/124157038), [M411A](https://blog.csdn.net/fatiaozhang9527/article/details/126388479), [UNT403A](https://blog.csdn.net/wjf149575296/article/details/123947681), [UNT413A](https://blog.csdn.net/fatiaozhang9527/article/details/122232733) | All | openwrt_s905l3a_k*.img |

💡Tip: The current ***`s905w`*** series of TV Boxes only support the use of the `5.4.y/5.15.y` kernel, and cannot use the 5.10.y or higher version. Other types of TV Boxes can use optional kernel versions. Currently ***`s905`*** TV Boxes can only be used in `TF/SD/USB`, other types of TV Boxes also support writing to `EMMC`. Please refer to the [instructions](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/build-armbian/armbian-docs/amlogic_model_database.md) for dtb and u-boot of each device.

## Install to EMMC and update instructions

Choose the corresponding firmware according to your box. Then write the IMG file to the USB hard disk through software such as [Rufus](https://rufus.ie/) or [balenaEtcher](https://www.balena.io/etcher/). Insert the USB hard disk into the box. Common for all `Amlogic s9xxx TV Boxes`.

- ### Install OpenWrt

Log in to the default IP: 192.168.1.1 → `Login in to openwrt` → `system menu` → `Amlogic Service` → `Install OpenWrt`, Select your box in the Supported Devices drop-down list and click the `Install OpenWrt` button to install it.

- ### Update OpenWrt

Log in to the default IP: 192.168.1.1 →  `Login in to openwrt` → `system menu` → `Amlogic Service` → `Upload updates manually / Download updates online`

If you choose `Upload Updates Manually` [OpenWrt firmware](https://github.com/ophub/amlogic-s9xxx-openwrt/releases), You can upload the corresponding OpenWrt firmware package, such as openwrt_s9xxx_k5.15.50_xxx.img.gz (It is recommended to upload the compressed package, and the system will automatically decompress it. If you upload the decompressed xxx.img file, the upload may fail because the file is too large), After the upload is complete, the interface will display the `Update firmware` operation button, click to update.

If you choose `Manually upload updates` [OpenWrt kernel](https://github.com/ophub/kernel/tree/main/pub/stable), You can upload the three kernel files `boot-xxx.tar.gz`, `dtb-amlogic-xxx.tar.gz`, `modules-xxx.tar.gz` (Other kernel files are not required. If uploading at the same time does not affect the update, the system can accurately identify the required kernel files.)，After the upload is complete, the interface will display the `Update Kernel` operation button, click to update.

If you choose `Online Download Update` OpenWrt firmware or kernel, it will be downloaded according to `Firmware download address` and `Kernel download address` in `Plugin Settings`, you can customize and modify the download source, For details, please refer to the compilation and usage instructions of [luci-app-amlogic](https://github.com/ophub/luci-app-amlogic).

Tip: Functions such as install/update are provided by [luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) to provide visual operation support. Also supports [command operations](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/router-config/README.md#8-install-the-firmware).

- ### Use OpenWrt in TF/SD/USB

Log in to the default IP: 192.168.1.1 →  `Login in to openwrt` → `system menu` → `TTYD terminal` → input command

```yaml
openwrt-tf
```

After activating the remaining space, the kernel and OpenWrt system can be upgraded in TF/SD/USB.

- ### Create swap for openwrt system

If you feel that the memory of the current box is not enough when you are using applications with a large memory footprint such as `docker`, you can create a `swap` virtual memory partition, Change the disk space of `/mnt/*4` A certain capacity is virtualized into memory for use. The unit of the input parameter of the following command is `GB`, and the default is `1`.

Log in to the default IP: 192.168.1.1 →  `Login in to openwrt` → `system menu` → `TTYD terminal` → input command

```yaml
openwrt-swap 1
```

- ### Backup/restore the original EMMC system

Supports backup/restore of the box's `EMMC` partition in `TF/SD/USB`. It is recommended that you back up the Android TV system that comes with the current box before installing the OpenWrt system in a brand new box, so that you can use it in the future when restoring the TV system.

Please start the OpenWrt system from `TF/SD/USB`, Log in to the default IP: 192.168.1.1 →  `Login in to openwrt` → `system menu` → `TTYD terminal` → input command

```yaml
openwrt-ddbr
```

According to the prompt, enter `b` to perform system backup, and enter `r` to perform system recovery.

💡Tip: You must use the `/mnt/*4/` space to store the `BACKUP-arm-64-emmc.img.gz` backup file, Users who have not created the `TF/SD/USB` extended partition must first use the `openwrt-tf` command to create the extended partition.

- ### Controlling the LED display

Log in to the default IP: 192.168.1.1 →  `Login in to openwrt` → `system menu` → `TTYD terminal` → input command

```yaml
openwrt-led
```

Debug according to [LED screen display control instructions](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/build-armbian/armbian-docs/led_screen_display_control.md).

- ### More instructions for use

Use the `firstboot` command to restore the system to its initial state. In the use of OpenWrt, please refer to [router-config](router-config) for some common problems that may be encountered.

## Local build instructions

1. Install the necessary packages (E.g Ubuntu 22.04 LTS user)
```yaml
sudo apt-get update -y
sudo apt-get full-upgrade -y
# For Ubuntu-22.04
sudo apt-get install -y $(curl -fsSL https://is.gd/depend_ubuntu2204_openwrt)
```
2. Clone the repository to the local. `git clone --depth 1 https://github.com/ophub/amlogic-s9xxx-openwrt.git`
3. Create a `openwrt-armvirt` folder, and upload the OpenWrt firmware of the ARM kernel ( Eg: `openwrt-armvirt-64-default-rootfs.tar.gz` ) to this `~/amlogic-s9xxx-openwrt/openwrt-armvirt` directory.
4. Enter the `~/amlogic-s9xxx-openwrt` root directory. And run Eg: `sudo ./make -d -b s905x3 -k 5.10.125`. The generated OpenWrt firmware is in the `out` directory under the root directory.

- ### Description of localized packaging parameters

| Parameter | Meaning | Description |
| ---- | ---- | ---- |
| -d | Defaults | Compile all cores and all firmware types. |
| -b | BuildSoC | Specify the Build firmware type. Write the build firmware name individually, such as `-b s905x3` . Multiple firmware use `_` connect such as `-b s905x3_s905d` . Use `all` for all SoC models. You can use these codes: `a311d`, `s905x3`, `s905x3-b`, `s905x2`, `s905l3a`, `s905x`, `s905w`, `s905d`, `s905d-ki`, `s905`, `s922x`, `s922x-n2`, `s912`, `s912-m8s` . Note: `s922x-reva` is `s922x-gtking-pro-rev_a`, `s922x-n2` is `s922x-odroid-n2`, `s912-m8s` is `s912-mecool-m8s-pro-l`, `s905d-ki` is `s905d-mecool-ki-pro`, `s905x2-km3` is `s905x2-mecool-km3` |
| -k | Kernel | Specify the [kernel](https://github.com/ophub/kernel/tree/main/pub/stable) name. Write the kernel name individually such as `-k 5.10.125` . Multiple kernel use `_` connection such as `-k 5.10.125_5.15.50` |
| -a | AutoKernel | Set whether to automatically adopt the latest version of the kernel of the same series. When it is `true`, it will automatically find in the kernel library whether there is an updated version of the kernel specified in `-k` such as 5.10.125 version. If there is the latest version of same series, it will automatically Replace with the latest version. When set to `false`, the specified version of the kernel will be compiled. Default value: `true` |
| -v | VersionBranch | Specify the name of the kernel [version branch](https://github.com/ophub/kernel/tree/main/pub), Such as `-v stable`. The specified name must be the same as the branch directory name. The `stable` branch version is used by default. |
| -s | Size | Set the ROOTFS partition size for firmware (MiB). The default is 960 MiB, and the specified size must be greater than 512 MiB. Such as `-s 960` |

- `sudo ./make -d`: Compile latest kernel versions of openwrt for all SoC with the default configuration.
- `sudo ./make -d -b s905x3 -k 5.10.125`: recommend. Use the default configuration, specify a kernel and a firmware for compilation.
- `sudo ./make -d -b s905x3_s905d -k 5.10.125_5.15.50`: Use the default configuration, specify multiple cores, and multiple firmware for compilation. use `_` to connect.
- `sudo ./make -d -b s905x3 -k 5.10.125 -s 960`: Using the default configuration, one kernel is specified, one model is packaged, and the firmware size is set to 960 MiB.
- `sudo ./make -d -b s905x3 -v dev -k 5.10.125`: Use the default configuration, specify the model, specify the [version branch](https://github.com/ophub/kernel/tree/main/pub), and specify the kernel for packaging.
- `sudo ./make -d -b s905x3_s905d`: Use the default configuration, specify multiple firmware, use `_` to connect. compile all kernels.
- `sudo ./make -d -k 5.10.125_5.15.50`: Use the default configuration. Specify multiple cores, use `_` to connect.
- `sudo ./make -d -k 5.10.125_5.15.50 -a true`: Use the default configuration. Specify multiple cores, use `_` to connect. Auto update to the latest kernel of the same series.
- `sudo ./make -d -s 960 -k 5.10.125`: Use the default configuration and set the partition size to 960 MiB, and only compile the openwrt firmware with the kernel version 5.10.125.

## Use GitHub Actions to build

You can modify the configuration file in the `router-config` directory and `.yml` file, customize the OpenWrt firmware, and complete the packaging online through `Actions`, and complete all the compilation of OpenWrt firmware in github.com One-stop.

1. Personalized plug-in configuration in [router-config](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/router-config) directory. Workflows configuration in [.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt-with-lede.yml) file.
2. New compilation: Select ***`Build OpenWrt`*** on the [Action](https://github.com/ophub/amlogic-s9xxx-openwrt/actions) page. Click the ***`Run workflow`*** button.
3. Compile again: If there is an `openwrt-armvirt-64-default-rootfs.tar.gz` file in [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases), you do not need to compile it completely, you can directly use this file to `build openwrt` of different soc. Select ***`Use Releases file to Packaging`*** on the [Actions](https://github.com/ophub/amlogic-s9xxx-armbian/openwrt) page. Click the ***`Run workflow`*** button.
4. More support: The compiled `openwrt-armvirt-64-default-rootfs.tar.gz` file is a common file for making various SoC firmware, and it is also suitable for making OpenWrt firmware using [unifreq's packaging script](https://github.com/unifreq/openwrt_packit). As the pioneer of using OpenWrt and Armbian system in the box, he has supported more devices, such as OpenWrt ([qemu version](https://github.com/unifreq/openwrt_packit/blob/master/files/qemu-aarch64/qemu-aarch64-readme.md)) as used by `KVM` virtual machine on [Armbian](https://github.com/ophub/amlogic-s9xxx-armbian) system, Allwinner (`V-Plus Cloud`), and Rockchip (`BeikeYun`, `Chainedbox L1 Pro`), and Amlogic series, etc. For details on the packaging method, please refer to his source code repository description. In Actions, you can use [packaging-openwrt-for-qemu-etc.yml](.github/workflows/packaging-openwrt-for-qemu-etc.yml) to call his packaging script to make more firmware.

```yaml
- name: Package Armvirt as OpenWrt
  uses: ophub/amlogic-s9xxx-openwrt@main
  with:
    openwrt_path: openwrt/bin/targets/*/*/*rootfs.tar.gz
    openwrt_soc: s905x3_s905x2_s905x_s905w_s905d_s922x_s912
    openwrt_kernel: 5.10.125_5.15.50
```

- ### GitHub Actions Input parameter description

The relevant parameters correspond to the `local packaging command`, please refer to the above description.

| Parameter          | Defaults          | Description                                                   |
|--------------------|-------------------|---------------------------------------------------------------|
| openwrt_path     | no                | Set the file path of `openwrt-armvirt-64-default-rootfs.tar.gz` , you can use a relative path such as `openwrt/bin/targets/*/*/*rootfs.tar.gz` or the network file download address. E.g `https://github.com/*/releases/*/*rootfs.tar.gz` |
| openwrt_soc        | s905d_s905x3      | Set the `SoC` of the packaging TV Boxes, function reference `-b` |
| openwrt_kernel     | 5.10.125_5.15.50   | Set the kernel version，function reference `-k` |
| auto_kernel        | true              | Set whether to automatically adopt the latest version of the kernel of the same series. function reference `-a`  |
| version_branch     | stable            | Specify the name of the kernel [version branch](https://github.com/ophub/kernel/tree/main/pub), function reference `-v` |
| openwrt_size       | 960               | Set the size of the firmware ROOTFS partition, function reference `-s` |

- ### GitHub Actions Output variable description

To upload to `Releases`, you need to add `GITHUB_TOKEN` and `GH_TOKEN` to the repository and set `Workflow read and write permissions`, see the [instructions for details](router-config#2-set-the-privacy-variable-github_token).

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

[For more instructions please see: router-config](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/router-config)

## OpenWrt firmware default information

| Name | Value |
| ---- | ---- |
| Default IP | 192.168.1.1 |
| Default username | root |
| Default password | password |
| Default WIFI name | OpenWrt |
| Default WIFI password | none |

## Compile the kernel

For the compilation method of the kernel, see [compile-kernel](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/compile-kernel)

```yaml
- name: Compile the kernel for Amlogic s9xxx
  uses: ophub/amlogic-s9xxx-armbian@main
  with:
    build_target: kernel
    kernel_version: 5.10.125_5.15.50
    kernel_auto: true
    kernel_sign: -ophub
```

## Resource Description

When making an OpenWrt system, the [kernel](https://github.com/ophub/kernel) and [u-boot](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian/amlogic-u-boot) files used are the same files used to make an [Armbian](https://github.com/ophub/amlogic-s9xxx-armbian) system. In order to avoid repeated maintenance, the relevant content is classified and placed in the corresponding resource repository, and it will be automatically downloaded from the relevant repository when it is used.

The `kernel` / `u-boot` and other resources used by this system are mainly copied from the project of [unifreq/openwrt_packit](https://github.com/unifreq/openwrt_packit), Some files are shared by users in [Pull](https://github.com/ophub/amlogic-s9xxx-openwrt/pulls) and [Issues](https://github.com/ophub/amlogic-s9xxx-openwrt/issues) of [amlogic-s9xxx-openwrt](https://github.com/ophub/amlogic-s9xxx-openwrt) / [amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian) / [luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) / [kernel](https://github.com/ophub/kernel) and other projects. `unifreq` opened the door for us to use OpenWrt in TV Boxes, and was deeply influenced by him. My firmware has inherited his consistent standards in production and use. To thank these pioneers and sharers, I have recorded them in [CONTRIBUTORS.md](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/CONTRIBUTORS.md). Thanks again everyone for giving new life and meaning to the Boxes.

## Links

- [OpenWrt](https://github.com/openwrt/openwrt)
- [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
- [unifreq/openwrt_packit](https://github.com/unifreq/openwrt_packit)

## License

The amlogic-s9xxx-openwrt © OPHUB is licensed under [GPL-2.0](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/LICENSE)

