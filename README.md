# OpenWrt

View Chinese description  |  [查看中文说明](README.cn.md)

The [OpenWrt](https://openwrt.org/) Project is a Linux router operating system targeting embedded devices. Instead of trying to create a single, static firmware, OpenWrt provides a fully writable filesystem with package management. Allows you to freely choose the software package you need to customize your router system. For developers, OpenWrt is the framework to build an application without having to build a complete firmware around it; for users this means the ability for full customization, to use the device in ways never envisioned. It has more than 3000+ standardized application packages and a very rich third-party plug-in support, so you can easily replicate the same setup on any supported device.

Now you can replace the Android TV system of the TV box with the OpenWrt system, making it a powerful router. This project builds OpenWrt system for `Amlogic`, `Rockchip` and `Allwinner` boxes. including install to eMMC and update kernel related functions. Please refer to the [OpenWrt Documentation](./make-openwrt/documents) for the usage method.

The latest version of the OpenWrt firmware can be downloaded in [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases). Welcome to use `Fork` for personalized OpenWrt firmware configuration. If you like it, Please click the `Star`.

## OpenWrt Firmware instructions

| SoC  | Device | [Optional kernel](https://github.com/ophub/kernel/releases/tag/kernel_stable) | OpenWrt Firmware |
| ---- | ---- | ---- | ---- |
| a311d | [Khadas-VIM3](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/99) | All | amlogic_a311d.img |
| s922x | [Beelink-GT-King](https://github.com/ophub/amlogic-s9xxx-armbian/issues/370), [Beelink-GT-King-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/707), [Ugoos-AM6-Plus](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/213), [ODROID-N2](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/201), [X88-King](https://github.com/ophub/amlogic-s9xxx-armbian/issues/988), [Ali-CT2000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1150) | All | amlogic_s922x.img |
| s905x3 | [X96-Max+](https://github.com/ophub/amlogic-s9xxx-armbian/issues/351), [HK1-Box](https://github.com/ophub/amlogic-s9xxx-armbian/issues/414), [Vontar-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1006), [H96-Max-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1250), [Ugoos-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/782), [TX3(QZ)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/644), [TX3(BZ)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1077), [X96-Air](https://github.com/ophub/amlogic-s9xxx-armbian/issues/366), [X96-Max+_A100](https://github.com/ophub/amlogic-s9xxx-armbian/issues/779), [A95XF3-Air](https://github.com/ophub/amlogic-s9xxx-armbian/issues/157), [Tencent-Aurora-3Pro(s905x3-b)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/506), [X96-Max+Q1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/788), [X96-Max+100W](https://github.com/ophub/amlogic-s9xxx-armbian/issues/909), [X96-Max+_2101](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1086), [Infinity-B32](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1181) | All | amlogic_s905x3.img |
| s905x2 | [X96Max-4G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/453), [X96Max-2G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/95), [MECOOL-KM3-4G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/79), [Tanix-Tx5-Max](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/351), [A95X-F2](https://github.com/ophub/amlogic-s9xxx-armbian/issues/851) | All | amlogic_s905x2.img |
| s912 | [Tanix-TX8-Max](https://github.com/ophub/amlogic-s9xxx-armbian/issues/500), [Tanix-TX9-Pro(3G)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/315), [Tanix-TX9-Pro(2G)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/740), [Tanix-TX92](https://github.com/ophub/amlogic-s9xxx-armbian/issues/72#issuecomment-1012790770), [Nexbox-A1](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/260), [Nexbox-A95X-A2](https://www.cafago.com/en/p-v2979eu-2g.html),  [A95X](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/260), [H96-Pro-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/72#issuecomment-1013071513), [VORKE-Z6-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/72), [Mecool-M8S-PRO-L](https://github.com/ophub/amlogic-s9xxx-armbian/issues/158), [Vontar-X92](https://github.com/ophub/amlogic-s9xxx-armbian/issues/525), [T95Z-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/668), [Octopus-Planet](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1020), [Phicomm-T1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/522) | All | amlogic_s912.img |
| s905d | [MECOOL-KI-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/59), [Phicomm-N1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/925) | All | amlogic_s905d.img |
| s905x | [HG680P](https://github.com/ophub/amlogic-s9xxx-armbian/issues/368), [B860H](https://github.com/ophub/amlogic-s9xxx-armbian/issues/60), [TBee-Box](https://github.com/ophub/amlogic-s9xxx-armbian/issues/98), [T95](https://github.com/ophub/amlogic-s9xxx-armbian/issues/285), [TX9](https://github.com/ophub/amlogic-s9xxx-armbian/issues/645) | All | amlogic_s905x.img |
| s905w | [X96-Mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/621), [TX3-Mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1062), [W95](https://github.com/ophub/amlogic-s9xxx-armbian/issues/570), [X96W/FunTV](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1044), [MXQ-Pro-4K](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1140) | All | amlogic_s905w.img |
| s905l2 | [MGV2000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/648), [MGV3000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/921), [Wojia-TV-IPBS9505](https://github.com/ophub/amlogic-s9xxx-armbian/issues/648), [M301A](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/405), [E900v21E](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1278) | All | amlogic_s905l2.img |
| s905l3 | [CM311-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/763), [HG680-LC](https://github.com/ophub/amlogic-s9xxx-armbian/issues/978), [M401A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/921#issuecomment-1453143251), [UNT400G1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1277) | All | amlogic_s905l3.img |
| s905l3a | [E900V22C/D](https://github.com/Calmact/e900v22c), [CM311-1a-YST](https://github.com/ophub/amlogic-s9xxx-armbian/issues/517), [M401A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/732), [M411A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/517), [UNT403A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/970), [UNT413A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/970), [ZTE-B863AV3.2-M](https://github.com/ophub/amlogic-s9xxx-armbian/issues/741) | All | amlogic_s905l3a.img |
| s905l3b | [E900V22D](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1256), [M302A/M304A](https://github.com/ophub/amlogic-s9xxx-armbian/pull/615), [E900V22E](https://github.com/ophub/amlogic-s9xxx-armbian/issues/939), [Hisense-IP103H](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1154), [CM211-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1180), [CM311-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1268) | All | amlogic_s905l3b.img |
| s905lb | [Q96-mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/734), [BesTV-R3300L](https://github.com/ophub/amlogic-s9xxx-armbian/pull/993), [SumaVision-Q7](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1190) | All | amlogic_s905lb.img |
| s905 | [Beelink-Mini-MX-2G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/127), [Sunvell-T95M](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/337), [MXQ-Pro+4K](https://github.com/ophub/amlogic-s9xxx-armbian/issues/715), [SumaVision-Q5](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1175) | All | amlogic_s905.img |
| rk3588 | [Radxa-Rock5B](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1240), [HinLink-H88K](http://www.hinlink.com/index.php?id=151) | [rk3588](https://github.com/ophub/kernel/releases/tag/kernel_rk3588) | rockchip_boxname.img |
| rk3568 | [FastRhino-R66S](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1061), [FastRhino-R68S](https://github.com/ophub/amlogic-s9xxx-armbian/issues/774), [HinLink-H66K](http://www.hinlink.com/index.php?id=137), [HinLink-H68K](http://www.hinlink.com/index.php?id=119), [Radxa-E25](https://wiki.radxa.com/Rock3/CM/CM3I/E25), [NanoPi-R5S](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1217), [Photonicat](https://ariaboard.com/wiki/Photonicat_%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C) | [6.x.y](https://github.com/ophub/kernel/releases/tag/kernel_stable) | rockchip_boxname.img |
| rk3399 | [EAIDK-610](https://github.com/ophub/amlogic-s9xxx-armbian/pull/991), [King3399](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1080), [TN3399](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1094), [Kylin3399](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1132), [ZCube1-Max](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1247), [CRRC](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1280) | [6.x.y](https://github.com/ophub/kernel/releases/tag/kernel_stable) | rockchip_boxname.img |
| rk3328 | [BeikeYun](https://github.com/ophub/amlogic-s9xxx-armbian/issues/852), [L1-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1007) | All | rockchip_boxname.img |
| h6 | [Vplus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1100), [Tanix-TX6](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1120) | All | allwinner_boxname.img |

💡Tip: Currently [s905 Boxes](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1173) can only be used in `TF/SD/USB`, Other models of boxes support writing to `eMMC` for use. For more information, please refer to [Description of Supported Device List](make-openwrt/openwrt-files/common-files/etc/model_database.conf). You can refer to the method in Section 12.15 of the documentation to [add new support devices](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/build-armbian/documents/README.md#1215-how-to-add-new-supported-devices).

## Install to EMMC and update instructions

Choose the corresponding firmware according to your box. See the corresponding instructions for the use of different devices.

- ### Install OpenWrt

1. For the installation method of the `Rockchip` platform, please refer to [Section 8](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/build-armbian/documents) in the documentation. The installation method is the same as Armbian.

2. `Amlogic` and `Allwinner` platform，Then write the IMG file to the USB hard disk through software such as [Rufus](https://rufus.ie/) or [balenaEtcher](https://www.balena.io/etcher/). Insert the USB hard disk into the box. Log in to the default IP: 192.168.1.1 → `Login in to openwrt` → `system menu` → `Amlogic Service` → `Install OpenWrt`, Select your box in the Supported Devices drop-down list and click the `Install OpenWrt` button to install it.

- ### Update OpenWrt

Log in to the default IP: 192.168.1.1 →  `Login in to openwrt` → `system menu` → `Amlogic Service` → `Upload updates manually / Download updates online`

If you choose `Upload Updates Manually` [OpenWrt firmware](https://github.com/ophub/amlogic-s9xxx-openwrt/releases), You can upload the corresponding OpenWrt firmware package, such as openwrt_xxx_k5.15.50.img.gz (It is recommended to upload the compressed package, and the system will automatically decompress it. If you upload the decompressed xxx.img file, the upload may fail because the file is too large), After the upload is complete, the interface will display the `Update firmware` operation button, click to update.

If you choose `Manually upload updates` [OpenWrt kernel](https://github.com/ophub/kernel/releases/tag/kernel_stable), You can upload the three kernel files `boot-xxx.tar.gz`, `dtb-xxx.tar.gz`, `modules-xxx.tar.gz` (Other kernel files are not required. If uploading at the same time does not affect the update, the system can accurately identify the required kernel files.)，After the upload is complete, the interface will display the `Update Kernel` operation button, click to update.

If you choose `Online Download Update` OpenWrt firmware or kernel, it will be downloaded according to `Firmware download address` and `Kernel download address` in `Plugin Settings`, you can customize and modify the download source, For details, please refer to the compilation and usage instructions of [luci-app-amlogic](https://github.com/ophub/luci-app-amlogic).

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

- ### Controlling the LED display

Log in to the default IP: 192.168.1.1 →  `Login in to openwrt` → `system menu` → `TTYD terminal` → input command

```yaml
openwrt-openvfd
```

Debug according to [LED screen display control instructions](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/build-armbian/documents/led_screen_display_control.md).

- ### More instructions for use

Use the `firstboot` command to restore the system to its initial state. In the use of OpenWrt, please refer to [documents](./make-openwrt/documents) for some common problems that may be encountered.

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
4. Enter the `~/amlogic-s9xxx-openwrt` root directory. And run Eg: `sudo ./make -b s905x3 -k 6.1.10`. The generated OpenWrt firmware is in the `out` directory under the root directory.

- ### Description of localized packaging parameters

| Parameter | Meaning       | Description               |
| --------- | ------------- | ------------------------- |
| -b       | Board      | Specify the Build system type. Write the build system name individually, such as `-b s905x3` . Multiple system use `_` connect such as `-b s905x3_s905d` . Use `all` for all board models. The model code is detailed in the `BOARD` setting in [model_database.conf](make-openwrt/openwrt-files/common-files/etc/model_database.conf) file. Default value: `all` |
| -r       | KernelRepo | Specifies the `<owner>/<repo>` of the github.com kernel repository. Default value: `ophub/kernel` |
| -u       | kernelUsage | Set the `tags suffix` of the kernel used, such as [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable), [flippy](https://github.com/ophub/kernel/releases/tag/kernel_flippy), [dev](https://github.com/ophub/kernel/releases/tag/kernel_dev). Default value: `stable` |
| -k       | Kernel     | Specify the [kernel version](https://github.com/ophub/kernel/releases/tag/kernel_stable), Such as `-k 5.10.125` . Multiple kernel use `_` connection such as `-k 5.10.125_5.15.50` . The kernel version freely specified by the `-k` parameter is only valid for the kernel in the `stable/flippy/dev`. Other kernel families such as [rk3588](https://github.com/ophub/kernel/releases/tag/kernel_rk3588) can only use specific kernels. |
| -a       | AutoKernel | Set whether to automatically adopt the latest version of the kernel of the same series. When it is `true`, it will automatically find in the kernel library whether there is an updated version of the kernel specified in `-k` such as 5.10.125 version. If there is the latest version of same series, it will automatically Replace with the latest version. When set to `false`, the specified version of the kernel will be compiled. Default value: `true` |
| -s       | Size       | Specify the ROOTFS partition size for the system, and the specified size must be greater than 2048MiB. Such as `-s 2560`, Default value: `2560` |
| -g        | GH_TOKEN      | Optional. Set `${{ secrets.GH_TOKEN }}` for [api.github.com](https://docs.github.com/en/rest/overview/resources-in-the-rest-api?apiVersion=2022-11-28#requests-from-personal-accounts) query. Default: `None` |


- `sudo ./make`: Compile latest kernel versions of openwrt for all board with the default configuration.
- `sudo ./make -b s905x3 -k 6.1.10`: recommend. Use the default configuration, specify a kernel and a firmware for compilation.
- `sudo ./make -b s905x3_s905d -k 6.1.10_5.15.50`: Use the default configuration, specify multiple cores, and multiple firmware for compilation. use `_` to connect.
- `sudo ./make -b s905x3 -k 6.1.10 -s 1024`: Using the default configuration, one kernel is specified, one model is packaged, and the firmware size is set to 1024 MiB.
- `sudo ./make -b s905x3_s905d`: Use the default configuration, specify multiple firmware, use `_` to connect. compile all kernels.
- `sudo ./make -k 6.1.10_5.15.50`: Use the default configuration. Specify multiple cores, use `_` to connect.
- `sudo ./make -k 6.1.10_5.15.50 -a true`: Use the default configuration. Specify multiple cores, use `_` to connect. Auto update to the latest kernel of the same series.
- `sudo ./make -s 1024 -k 6.1.10`: Use the default configuration and set the partition size to 1024 MiB, and only compile the openwrt firmware with the kernel version 6.1.10.

## Use GitHub Actions to build

You can modify the configuration file in the [config-openwrt](config-openwrt) directory and `.yml` file, customize the OpenWrt firmware, and complete the packaging online through `Actions`, and complete all the compilation of OpenWrt firmware in github.com One-stop.

1. Personalized plug-in configuration in [documents](./make-openwrt/documents) directory. Workflows configuration in [.yml](.github/workflows) file.
2. New compilation: Select ***`Build OpenWrt`*** on the [Action](https://github.com/ophub/amlogic-s9xxx-openwrt/actions) page. Click the ***`Run workflow`*** button.
3. Compile again: If there is an `openwrt-armvirt-64-default-rootfs.tar.gz` file in [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases), you do not need to compile it completely, you can directly use this file to `build openwrt` of different board. Select ***`Use Releases file to Packaging`*** on the [Actions](https://github.com/ophub/amlogic-s9xxx-armbian/openwrt) page. Click the ***`Run workflow`*** button.
4. More support: The compiled `openwrt-armvirt-64-default-rootfs.tar.gz` file is a common file for making various board firmware, and it is also suitable for making OpenWrt firmware using [unifreq's packaging script](https://github.com/unifreq/openwrt_packit). As the pioneer of using OpenWrt and Armbian system in the box, he has supported more devices, such as OpenWrt ([QEMU Version](https://github.com/unifreq/openwrt_packit/blob/master/files/qemu-aarch64/qemu-aarch64-readme.md)) as used by `KVM` virtual machine on [Armbian](https://github.com/ophub/amlogic-s9xxx-armbian) system, Amlogic, and Rockchip, and Allwinner series, etc. For details on the packaging method, please refer to his source code repository description. In Actions, you can use [packaging-openwrt-for-qemu-etc.yml](.github/workflows/packaging-openwrt-for-qemu-etc.yml) to call his packaging script to make more firmware.

```yaml
- name: Package Armvirt as OpenWrt
  uses: ophub/amlogic-s9xxx-openwrt@main
  with:
    openwrt_path: openwrt/bin/targets/*/*/*rootfs.tar.gz
    openwrt_board: s905x3_s905x2_s905x_s905w_s905d_s922x_s912
    openwrt_kernel: 6.1.10_5.15.50
    gh_token: ${{ secrets.GH_TOKEN }}
```

- ### GitHub Actions Input parameter description

The relevant parameters correspond to the `local packaging command`, please refer to the above description.

| Parameter          | Defaults         | Description                     |
| ------------------ | ---------------- | ------------------------------- |
| openwrt_path       | None             | Set the file path of `openwrt-armvirt-64-default-rootfs.tar.gz` , you can use a relative path such as `openwrt/bin/targets/*/*/*rootfs.tar.gz` or the network file download address. E.g `https://github.com/*/releases/*/*rootfs.tar.gz` |
| openwrt_board      | all              | Set the `board` of the packaging TV Boxes, function reference `-b` |
| kernel_repo        | ophub/kernel     | Specifies the `<owner>/<repo>` of the github.com kernel repository, function reference `-r` |
| kernel_usage       | stable           | Set the `tags suffix` of the kernel used, function reference `-u` |
| openwrt_kernel     | 6.1.1_5.15.1     | Set the kernel version，function reference `-k` |
| auto_kernel        | true             | Set whether to automatically adopt the latest version of the kernel of the same series. function reference `-a`  |
| openwrt_size       | 1024             | Set the size of the firmware ROOTFS partition, function reference `-s` |
| gh_token           | None             | Optional. Set `${{ secrets.GH_TOKEN }}`, function reference `-g` |

- ### GitHub Actions Output variable description

To upload to `Releases`, you need to add `${{ secrets.GITHUB_TOKEN }}` and `${{ secrets.GH_TOKEN }}` to the repository and set `Workflow read and write permissions`, see the [instructions for details](./make-openwrt/documents/README.md#2-set-the-privacy-variable-github_token).

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

For the compilation method of the kernel, see [compile-kernel](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/compile-kernel)

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

When making an OpenWrt system, the [kernel](https://github.com/ophub/kernel) and [u-boot](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian/u-boot) files used are the same files used to make an [Armbian](https://github.com/ophub/amlogic-s9xxx-armbian) system. In order to avoid repeated maintenance, the relevant content is classified and placed in the corresponding resource repository, and it will be automatically downloaded from the relevant repository when it is used.

The `kernel` / `u-boot` and other resources used by this system are mainly copied from the project of [unifreq/openwrt_packit](https://github.com/unifreq/openwrt_packit), Some files are shared by users in [Pull](https://github.com/ophub/amlogic-s9xxx-openwrt/pulls) and [Issues](https://github.com/ophub/amlogic-s9xxx-openwrt/issues) of [amlogic-s9xxx-openwrt](https://github.com/ophub/amlogic-s9xxx-openwrt) / [amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian) / [luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) / [kernel](https://github.com/ophub/kernel) and other projects. `unifreq` opened the door for us to use OpenWrt in TV Boxes, and was deeply influenced by him. My firmware has inherited his consistent standards in production and use. To thank these pioneers and sharers, I have recorded them in [CONTRIBUTORS.md](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/CONTRIBUTORS.md). Thanks again everyone for giving new life and meaning to the Boxes.

## Other distributions

- [unifreq](https://github.com/unifreq/openwrt_packit) has made `OpenWrt` system for more boxes such as `Amlogic`, `Rockchip` and `Allwinner`, which is a benchmark in the box circle and is recommended for use.
- The [amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian) project provides the `Armbian` system used in the box, which is also applicable to the relevant devices that support OpenWrt.

## Links

- [unifreq](https://github.com/unifreq/openwrt_packit)
- [OpenWrt](https://github.com/openwrt/openwrt)
- [coolsnowwolf](https://github.com/coolsnowwolf/lede)
- [immortalwrt](https://github.com/immortalwrt/immortalwrt)

## License

The amlogic-s9xxx-openwrt © OPHUB is licensed under [GPL-2.0](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/LICENSE)

