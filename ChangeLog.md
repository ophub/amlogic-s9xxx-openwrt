# Change Log
The version update instructions record each important update point for everyone to track and understand.

## Release Notes
- Date: Version update date.
- Firmware: Targeted OpenWrt firmware.
- Types: ADD / UPDATE / TOOL / BUG
- Importance: The difference between five stars (✩✩✩✩✩), the more stars the more important.
- Path: Link to related files.
- description: Detailed description of the update.


| Date | Firmware | Types | Importance | Path | description |
| ---- | ---- | ---- | ---- | ---- | ---- |
| 2021.02.28 | All | ADD | ✩✩✩✩✩ | [Documentation.md](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/router_config/Documentation.md) | Add detailed description of openwrt personalized compilation. |
| 2021.02.19 | All | UPDATE | ✩✩✩✩✩ | [s9xxx-update.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/s9xxx-update.sh) | Optimize online upgrade method. |
| 2021.02.17 | All | ADD | ✩✩✩ | [5.4.98](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel/5.4.98) | Add New kernel. |
| - | All | ADD | ✩✩✩ | [5.10.16.Beta](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel/5.10.16.Beta) | Add New kernel. |
| 2021.02.15 | All | UPDATE | ✩✩✩✩✩ | [s9xxx-install.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/s9xxx-install.sh) | Merging scripts, common for phicomm-n1 and s9xxx-Boxes. |
| - | All | UPDATE | ✩✩✩✩✩ | [s9xxx-update.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/s9xxx-update.sh) | Merging scripts, common for phicomm-n1 and s9xxx-Boxes. |
| 2021.02.01 | All | UPDATE | ✩✩✩✩✩ | [make](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/make) | Add support for 5.10 kernel. |
| - | All | UPDATE | ✩✩ | [s9xxx-install.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/s9xxx-install.sh) | Add support for 5.10 kernel. |
| - | All | ADD | ✩✩ | [5.10.11.Beta](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel/5.10.11.Beta) | Add New kernel. |
| - | All | ADD | ✩✩ | [5.4.93](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel/5.4.93) | Add New kernel. |
| 2020.12.31 | All | ADD | ✩✩✩ | [5.9.16](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel/5.9.16) | Add New kernel. |
| - | All | ADD | ✩✩✩ | [5.4.86](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel/5.4.86) | Add New kernel. |
| 2020.12.13 | All | ADD | ✩✩✩✩✩ | [packaging.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/use-releases-rootfs-file-to-packaging-openwrt.yml) | Added the `Use github.com Releases rootfs file to packaging`. |
| 2020.12.12 | S9xxx | UPDATE | ✩✩ | [s9xxx-install.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/s9xxx-install.sh) | Added the shared partition formatting type selection, which can be changed in `$TARGET_SHARED_FSTYPE`. |
| - | N1 | UPDATE | ✩✩ | [n1-install.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/n1-install.sh) | Added the shared partition formatting type selection, which can be changed in `$TARGET_SHARED_FSTYPE`. |
| - | All | ADD | ✩✩ | [5.9.14](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel/5.9.14) | Add New kernel. |
| - | All | ADD | ✩✩ | [5.4.83](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel/5.4.83) | Add New kernel. |
| - | All | ADD | ✩✩ | [make](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/make) | Support Belink GT-King, Belink GT-King Pro and UGOOS AM6 Plus. |
| - | All | ADD | ✩✩✩✩ | [amlogic-dtb](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb) | Added dtb files for Belink GT-King Pro and other boxes. |
| - | All | ADD | ✩✩✩ | [kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel) | The kernel files in the repository are all updated to the latest for dtb files. |
| - | S9xxx | UPDATE | ✩✩ | [s9xxx-install.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/s9xxx-install.sh) | s905x3-install.sh Renamed s9xxx-install.sh |
| - | S9xxx | UPDATE | ✩✩ | [s9xxx-update.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/s9xxx-update.sh) | s905x3-update.sh Renamed s9xxx-update.sh |
| 2020.12.07 | S9xxx | UPDATE | ✩✩ | [s9xxx-install.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/s9xxx-install.sh) | Upgrade the installation script to `flippy` version. |
| - | N1 | UPDATE | ✩✩ | [n1-install.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/n1-install.sh) | Upgrade the installation script to `flippy` version. |
| 2020.11.28 | All | UPDATE | ✩ | [make](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/make) | Add firmware version information to the terminal page. |
| 2020.11.14 | All | ADD | ✩✩✩ | [5.9.8](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel/5.9.8) | Add New kernel. |
| - | All | ADD | ✩✩✩ | [5.7.7](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel/5.7.7) | Add New kernel. |
| 2020.11.13 | N1 | UPDATE | ✩✩✩ | [n1-update.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/n1-update.sh) | Upgraded the Phicomm-N1 upgrade script, which supports booting from the USB hard disk to upgrade. |
| 2020.11.12 | All | UPDATE | ✩✩✩✩✩ | [make](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/make) | When the openwrt firmware is packaged, the auto-complete installation/update file and BootLoader file are added. |
| 2020.11.09 | All | ADD | ✩✩✩ | [make](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/make) | Add the -b parameter to support compiling multiple firmwares at the same time. For example, `./make -d -b n1_x96`. The -k parameter is expanded to support the simultaneous compilation of multiple kernels, such as `./make -d -k 5.4.60_5.9.5`. |
| 2020.11.08 | All | TOOL | ✩✩✩ | [amlogic-dtb](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb) | The dtb library is added to facilitate the lack of corresponding boot files when compiling the firmware of related models with the old version of the kernel file. |
| - | All | TOOL | ✩✩✩ | [update_dtb.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/amlogic-kernel/build_kernel/update_dtb.sh) | Update kernel.tar.xz files in the kernel directory with the latest dtb file. |
| - | All | UPDATE | ✩✩✩✩✩ | [kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel) | Supplement the old version of the kernel with the latest dtb file. |
| - | All | UPDATE | ✩✩✩ | [make_use_img.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/amlogic-kernel/build_kernel/make_use_img.sh) | When the kernel is extracted, if the file lacks a key .dtb file, the supplement will be extracted from the dtb library. |
| - | All | UPDATE | ✩✩✩ | [make_use_kernel.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/amlogic-kernel/build_kernel/make_use_kernel.sh) | When the kernel is extracted, if the file lacks a key .dtb file, the supplement will be extracted from the dtb library. |
| - | S9xxx | UPDATE | ✩✩ | [s9xxx-install.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/s9xxx-install.sh) | Added that if the dtb file is missing during installation, the download path will be prompted. |
| 2020.11.07 | All | ADD | ✩✩ | [5.4.75](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel/5.4.75) | Add New kernel. |
| - | All | ADD | ✩✩ | [5.9.5](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel/5.9.5) | Add New kernel. |
| - | All | UPDATE | ✩✩ | [make_use_img.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/amlogic-kernel/build_kernel/make_use_img.sh) | Add fuzzy matching function. When the version specified by the script is not found, other firmware will be searched from the flippy directory. Thus, you can directly put the kernel file you want to use into the flippy directory for extraction, without manually changing the relevant parameters each time. |
| - | All | UPDATE | ✩✩ | [make_use_kernel.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/amlogic-kernel/build_kernel/make_use_kernel.sh) | Add fuzzy matching function. When the version specified by the script is not found, other firmware will be searched from the flippy directory. Thus, you can directly put the kernel file you want to use into the flippy directory for extraction, without manually changing the relevant parameters each time. |
| 2020.11.01 | S9xxx | ADD | ✩✩✩✩✩ | [s9xxx-install.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/s9xxx-install.sh) | Added the function of writing emmc partition to s9xxx series boxes. |
| - | S9xxx | ADD | ✩✩✩✩✩ | [s9xxx-update.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/s9xxx-update.sh) | Added the function of updating emmc partition firmware to s9xxx series boxes. |
| 2020.10.25 | All | ADD | ✩ | [amlogic-s9xxx-openwrt](https://github.com/ophub/amlogic-s9xxx-openwrt) | Open this Github repository. |

