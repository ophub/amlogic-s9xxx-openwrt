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
| 2020.12.07 | S905x3 | UPDATE | ✩✩ | [s905x3-install.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/install-program/files/s905x3-install.sh) | Upgrade the installation script to `flippy` version. |
| - | N1 | UPDATE | ✩✩ | [n1-install.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/install-program/files/n1-install.sh) | Upgrade the installation script to `flippy` version. |
| 2020.11.28 | All | UPDATE | ✩ | [make](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/make) | Add firmware version information to the terminal page. |
| 2020.11.14 | All | ADD | ✩✩✩ | [5.9.8](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/armbian/kernel-amlogic/kernel/5.9.8) | Add New kernel. |
| - | All | ADD | ✩✩✩ | [5.7.7](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/armbian/kernel-amlogic/kernel/5.7.7) | Add New kernel. |
| 2020.11.13 | N1 | UPDATE | ✩✩✩ | [n1-update.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/install-program/files/n1-update.sh) | Upgraded the Phicomm-N1 upgrade script, which supports booting from the USB hard disk to upgrade. |
| 2020.11.12 | All | UPDATE | ✩✩✩✩✩ | [make](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/make) | When the openwrt firmware is packaged, the auto-complete installation/update file and BootLoader file are added. |
| 2020.11.09 | S905x3 | UPDATE | ✩✩✩ | [make](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/make) | Independent configuration of s905x3, supporting configuration of files such as .config. The compilation script of phicomm-n1 is transplanted, and the -b parameter is added to support the simultaneous compilation of multiple firmwares. For example, `./make -d -b x96_hk1`. The -k parameter is expanded to support the simultaneous compilation of multiple kernels, such as `./make -d -k 5.4.60_5.9.5`. |
| - | N1 | UPDATE | ✩✩✩ | [make](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/make) | Add the -b parameter to support compiling multiple firmwares at the same time. For example, `./make -d -b n1_x96`. The -k parameter is expanded to support the simultaneous compilation of multiple kernels, such as `./make -d -k 5.4.60_5.9.5`. |
| 2020.11.08 | All | TOOL | ✩✩✩ | [dtb-amlogic](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/armbian/dtb-amlogic) | The dtb library is added to facilitate the lack of corresponding boot files when compiling the firmware of related models with the old version of the kernel file. |
| - | All | TOOL | ✩✩✩ | [update_dtb.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/build_kernel/update_dtb.sh) | Update kernel.tar.xz files in the kernel directory with the latest dtb file. |
| - | All | UPDATE | ✩✩✩✩✩ | [kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/armbian/kernel-amlogic/kernel) | Supplement the old version of the kernel with the latest dtb file. |
| - | All | UPDATE | ✩✩✩ | [make_use_img.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/build_kernel/make_use_img.sh) | When the kernel is extracted, if the file lacks a key .dtb file, the supplement will be extracted from the dtb library. |
| - | All | UPDATE | ✩✩✩ | [make_use_kernel.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/build_kernel/make_use_kernel.sh) | When the kernel is extracted, if the file lacks a key .dtb file, the supplement will be extracted from the dtb library. |
| - | S905x3 | UPDATE | ✩✩ | [s905x3-install.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/install-program/files/s905x3-install.sh) | Added that if the dtb file is missing during installation, the download path will be prompted. |
| 2020.11.07 | All | ADD | ✩✩ | [5.4.75](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/armbian/kernel-amlogic/kernel/5.4.75) | Add New kernel. |
| - | All | ADD | ✩✩ | [5.9.5](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/armbian/kernel-amlogic/kernel/5.9.5) | Add New kernel. |
| - | All | UPDATE | ✩✩ | [make_use_img.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/build_kernel/make_use_img.sh) | Add fuzzy matching function. When the version specified by the script is not found, other firmware will be searched from the flippy directory. Thus, you can directly put the kernel file you want to use into the flippy directory for extraction, without manually changing the relevant parameters each time. |
| - | All | UPDATE | ✩✩ | [make_use_kernel.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/build_kernel/make_use_kernel.sh) | Add fuzzy matching function. When the version specified by the script is not found, other firmware will be searched from the flippy directory. Thus, you can directly put the kernel file you want to use into the flippy directory for extraction, without manually changing the relevant parameters each time. |
| 2020.11.01 | S905x3 | ADD | ✩✩✩✩✩ | [s905x3-install.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/install-program/files/s905x3-install.sh) | Added the function of writing emmc partition to s905x3 series boxes. |
| - | S905x3 | ADD | ✩✩✩✩✩ | [s905x3-update.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/install-program/files/s905x3-update.sh) | Added the function of updating emmc partition firmware to s905x3 series boxes. |
| 2020.10.25 | All | ADD | ✩ | [amlogic-s9xxx-openwrt](https://github.com/ophub/amlogic-s9xxx-openwrt) | Add OpenWrt Firmware for S905x3-Boxs and Phicomm-N1. |

