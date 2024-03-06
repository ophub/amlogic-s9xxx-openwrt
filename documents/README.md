# OpenWrt Production and Usage Guide

View Chinese description | [查看中文说明](README.cn.md)

The method of using GitHub Actions to compile OpenWrt in the cloud, and many contents in this guide, come from many technological innovators and resource sharers such as P3TERX, Flippy, etc. Thanks to everyone's contributions, using OpenWrt in the box has become so simple.

Github Actions is a service launched by Microsoft. It provides a very well-configured virtual server environment for building, testing, packaging, and deploying projects. It can be used for free with no time limit for public repositories, and each compilation time can last up to 6 hours, which is enough for compiling OpenWrt (we generally can complete a compilation in about 3 hours). Sharing is just for the exchange of experiences, please understand the shortcomings, please do not initiate various bad attacks on the internet, and do not maliciously use GitHub Actions.

# Table of Contents

- [OpenWrt Production and Usage Guide](#openwrt-production-and-usage-guide)
- [Table of Contents](#table-of-contents)
  - [1. Register Your Own Github Account](#1-register-your-own-github-account)
  - [2. Set Privacy Variable GITHUB\_TOKEN](#2-set-privacy-variable-github_token)
  - [3. Fork the repository and set Workflow permissions](#3-fork-the-repository-and-set-workflow-permissions)
  - [4. Personalized OpenWrt Firmware Customization File Description](#4-personalized-openwrt-firmware-customization-file-description)
    - [4.1 .config File Description](#41-config-file-description)
      - [4.1.1 First, Let the Firmware Support the National Language](#411-first-let-the-firmware-support-the-national-language)
      - [4.1.2 Select Personalized Software Packages](#412-select-personalized-software-packages)
    - [4.2 DIY Script Operations: diy-part1.sh and diy-part2.sh](#42-diy-script-operations-diy-part1sh-and-diy-part2sh)
      - [Example 1, Adding Third-Party Software Packages](#example-1-adding-third-party-software-packages)
      - [Example 2, Replace an Existing Same-Named Software Package in the Current Source Code Library with a Third-Party Software Package](#example-2-replace-an-existing-same-named-software-package-in-the-current-source-code-library-with-a-third-party-software-package)
      - [Example 3, Achieve Certain Requirements by Modifying the Code in the Source Code Library](#example-3-achieve-certain-requirements-by-modifying-the-code-in-the-source-code-library)
    - [4.3 Using Image Builder to Build Firmware](#43-using-image-builder-to-build-firmware)
  - [5. Firmware Compilation](#5-firmware-compilation)
    - [5.1 Manual Compilation](#51-manual-compilation)
    - [5.2 Scheduled Compilation](#52-scheduled-compilation)
    - [5.3 Expanding Github Actions Compilation Space Using Logical Volumes](#53-expanding-github-actions-compilation-space-using-logical-volumes)
  - [6. Saving Firmware](#6-saving-firmware)
    - [6.1 Save to Github Actions](#61-save-to-github-actions)
    - [6.2 Save to GitHub Releases](#62-save-to-github-releases)
    - [6.3 Save to Third Party](#63-save-to-third-party)
  - [7. Downloading Firmware](#7-downloading-firmware)
    - [7.1 Download from Github Actions](#71-download-from-github-actions)
    - [7.2 Download from Github Releases](#72-download-from-github-releases)
    - [7.3 Download from Third Party](#73-download-from-third-party)
  - [8. Install OpenWrt](#8-install-openwrt)
    - [8.1 Integrating luci-app-amlogic Operation Panel at Compilation Time](#81-integrating-luci-app-amlogic-operation-panel-at-compilation-time)
    - [8.2 Install Using the Operation Panel](#82-install-using-the-operation-panel)
  - [9. Update OpenWrt system or kernel](#9-update-openwrt-system-or-kernel)
  - [10. Advanced Tutorial on Personalized Firmware Customization](#10-advanced-tutorial-on-personalized-firmware-customization)
    - [10.1 Getting to Know the Complete .config File](#101-getting-to-know-the-complete-config-file)
    - [10.2 Understanding Workflow Files](#102-understanding-workflow-files)
      - [10.2.1 Changing the Address and Branch of the Compilation Source Code Repository](#1021-changing-the-address-and-branch-of-the-compilation-source-code-repository)
      - [10.2.2 Changing the Model and Kernel Version Number of the Box](#1022-changing-the-model-and-kernel-version-number-of-the-box)
    - [10.3 Customizing Banner Information](#103-customizing-banner-information)
    - [10.4 Customize feeds configuration file](#104-customize-feeds-configuration-file)
    - [10.5 Customize default software configuration information](#105-customize-default-software-configuration-information)
    - [10.6 Opkg package management](#106-opkg-package-management)
    - [10.7 Manage packages using the Web interface](#107-manage-packages-using-the-web-interface)
    - [10.8 How to restore the original Android TV system](#108-how-to-restore-the-original-android-tv-system)
      - [10.8.1 Backup and Recovery Using openwrt-ddbr](#1081-backup-and-recovery-using-openwrt-ddbr)
      - [10.8.2 Recovery Using Amlogic Flashing Tool](#1082-recovery-using-amlogic-flashing-tool)
      - [10.9 Unable to Boot After Installing Mainline u-boot](#109-unable-to-boot-after-installing-mainline-u-boot)
    - [10.10 Setting up the Box to Boot from USB/TF/SD](#1010-setting-up-the-box-to-boot-from-usbtfsd)
      - [10.10.1 Initial Installation of OpenWrt System](#10101-initial-installation-of-openwrt-system)
      - [10.10.2 Reinstallation of OpenWrt System](#10102-reinstallation-of-openwrt-system)
    - [10.11 Required OpenWrt Options](#1011-required-openwrt-options)

## 1. Register Your Own Github Account

Register your own account to continue with firmware personalization operations. Click the `Sign up` button in the upper right corner of the github.com website and register your own account according to the prompts.

## 2. Set Privacy Variable GITHUB_TOKEN

According to the [GitHub Docs](https://docs.github.com/en/actions/security-guides/automatic-token-authentication), GitHub automatically creates a unique GITHUB_TOKEN secret at the start of every workflow job for use within the workflow. The `{{ secrets.GITHUB_TOKEN }}` can be used for authentication within the workflow job.

## 3. Fork the repository and set Workflow permissions

Now you can Fork the repository. Open the repository https://github.com/ophub/amlogic-s9xxx-openwrt, click the Fork button in the upper right, and copy a copy of the repository code to your own account. Wait a few seconds, after the Fork is completed, visit amlogic-s9xxx-openwrt in your own repository under your own account. In the upper right corner `Settings` > `Actions` > `General` > `Workflow permissions` in the left navigation bar, select `Read and write permissions` and save. The illustration is as follows:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418568-0eb2f880-7a04-11eb-81c9-194e32382998.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/163203032-f044c63f-d113-4076-bf94-41f86c7dd0ce.png width="300" />
<img src=https://user-images.githubusercontent.com/68696949/167585338-841d3b05-8d98-4d73-ba72-475aad4a95a9.png width="300" />
</div>

## 4. Personalized OpenWrt Firmware Customization File Description

After the first 3 steps of preparation, start personalizing the firmware customization now. The 3 files under the [config/lede-master](../config/lede-master) directory are for customizing the OpenWrt firmware. In this chapter, we only make the simplest explanation, let you experience the joy of personalized customization as soon as you start, and I put more complex customization operations in the 10th section, which requires you to have a little foundation.

### 4.1 .config File Description

This file is the core file for customizing the OpenWrt software package, which contains all configuration information. Each line of code in the file represents a personalized configuration option. Although there are many projects, management is very simple. Let's start operating.

#### 4.1.1 First, Let the Firmware Support the National Language

In # National language packs, luci-i18n-base: Taking France as an example, to enable French support, change

```shell
# CONFIG_PACKAGE_luci-i18n-base-fr is not set
```

to

```shell
CONFIG_PACKAGE_luci-i18n-base-fr=y
```

All personalizations in the .config file can be operated in this way. For projects you don't need, fill in `#` at the beginning of the line and change `=y` at the end of the line to `is not set`. For the projects you need, remove the `#` at the beginning of the line and change `is not set` at the end of the line to `=y`.


#### 4.1.2 Select Personalized Software Packages

In `#LuCI-app:`, the approach to enable and delete default software packages is the same as above. This time we delete the plugin `luci-app-zerotier` from the default software package list, just change

```shell
CONFIG_PACKAGE_luci-app-zerotier=y
```
to

```shell
# CONFIG_PACKAGE_luci-app-zerotier is not set
```

By now, you should have a clear understanding of how to personalize configurations. Each line in the .config file represents a configuration item and can be enabled or deleted in this manner. The complete content of this file spans several thousand lines, what I have provided is a simplified version. How to obtain the full configuration file for more complex customization will be introduced in section 10.

### 4.2 DIY Script Operations: diy-part1.sh and diy-part2.sh

The scripts diy-part1.sh and diy-part2.sh are executed before and after the update and installation of feeds respectively. When we introduce OpenWrt's source code library for personalized firmware compilation, sometimes we want to rewrite some parts of the source code, or add some third-party software packages, delete or replace some software packages in the source code library. For example, we may want to modify the default IP, hostname, theme, add/delete software packages, etc. These modification instructions can be written into these two scripts. Let's take a few examples using OpenWrt source code library provided by coolsnowwolf.

Our operations below are all based on this source code library: [https://github.com/coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)

#### Example 1, Adding Third-Party Software Packages

Step one, add the following code in diy-part2.sh:

```shell
git clone https://github.com/jerrykuku/luci-app-ttnode.git package/lean/luci-app-ttnode
```

Step two, add the activation code for this third-party software package to the .config file:

```shell
CONFIG_PACKAGE_luci-app-ttnode=y
```

This completes the integration of the third-party software package, expanding the software packages that the current source code library does not have.

#### Example 2, Replace an Existing Same-Named Software Package in the Current Source Code Library with a Third-Party Software Package

Step one, add the following code to diy-part2.sh: The first line of code removes the original software from the source code library, and the second line introduces a third-party software package with the same name.

```shell
rm -rf package/lean/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon
```

Step two, add the third-party software package to the .config file:

```shell
CONFIG_PACKAGE_luci-theme-argon=y
```

This achieves the replacement of an existing same-named software package in the current source code library with a third-party software package.

#### Example 3, Achieve Certain Requirements by Modifying the Code in the Source Code Library

We add support for `aarch64` to `luci-app-cpufreq` so that it can be used in our firmware (some modifications should be handled with caution, you must know what you are doing).

Source file address: [luci-app-cpufreq/Makefile](https://github.com/coolsnowwolf/luci/blob/master/applications/luci-app-cpufreq/Makefile). Modify the code to add support for aarch64:

```shell
sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' package/lean/luci-app-cpufreq/Makefile
```

This achieves the modification of the source code. Through the diy-part1.sh and diy-part2.sh scripts, we have added some operation commands to make the compiled firmware better fit our personalized needs.


### 4.3 Using Image Builder to Build Firmware

The OpenWrt official website provides a ready-made openwrt-imagebuilder-*-armvirt-64.Linux-x86_64.tar.xz file (download address: [https://downloads.openwrt.org/releases](https://downloads.openwrt.org/releases)). The official Image Builder can be used to add packages and plugins to this file, and an openwrt-rootfs.tar.gz file can usually be made in just a few minutes. The manufacturing method can be found in the official documentation: [Use Image Builder](https://openwrt.org/zh/docs/guide-user/additional-software/imagebuilder)

This repository provides a one-click manufacturing service. You just need to pass the branch parameters into the [imagebuilder script](imagebuilder/imagebuilder.sh) to complete the production.

- Localized production command: In the `~/amlogic-s9xxx-openwrt` root directory, run the command `sudo ./config/imagebuilder/imagebuilder.sh openwrt:21.02.3` to generate. The parameter `21.02.3` is the current available `releases` version number for [download](https://downloads.openwrt.org/releases). The generated file is located in the `openwrt/bin/targets/armvirt/64` directory.

- Produce in `Actions` on github.com: [Build OpenWrt with Image Builder](../.github/workflows/build-openwrt-with-imagebuilder.yml)

## 5. Firmware Compilation

The configuration information of the default system is recorded in the [/etc/model_database.conf](../make-openwrt/openwrt-files/common-files/etc/model_database.conf) file, where the `BOARD` name is required to be unique.

Among them, the parts of the box system that are packaged by default when the value of `BUILD` is `yes` can be used directly. Those that are not packaged by default when the value is `no` need to download the packaged system of the same `FAMILY` (recommended to download the system of kernel `5.15/5.4`), and after writing to the `USB`, the `boot partition` in the `USB` can be opened on the computer, and the `FDT dtb name` in the `/boot/uEnv.txt` file can be modified to adapt to other boxes in the list.

When compiling locally, specify through the `-b` parameter, and when compiling in Actions on github.com, specify through the `openwrt_board` parameter. Using `-b all` means to package all devices whose `BUILD` is `yes`. When packaging with a specified `BOARD` parameter, it can be packaged regardless of whether `BUILD` is `yes` or `no`, for example: `-b r68s_s905x3-tx3_s905l3a-cm311`

### 5.1 Manual Compilation

In the navigation bar of your own repository, click the Actions button, and then click Build OpenWrt > Run workflow > Run workflow in order, start the compilation, wait for about 3 hours, and the entire process is completed after all processes are ended. The illustration is as follows:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418662-a0226a80-7a04-11eb-97f6-aeb893336e8c.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418663-a31d5b00-7a04-11eb-8d34-57d430696901.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418666-a7497880-7a04-11eb-9ed0-be738e22f7ae.jpg width="300" />
</div>

### 5.2 Scheduled Compilation

In the .github/workflows/build-openwrt.yml file, use Cron to set up scheduled compilation. The 5 different positions represent minute (0 - 59) / hour (0 - 23) / date (1 - 31) / month (1 - 12) / day of the week (0 - 6) (Sunday - Saturday) respectively. By modifying the values at different positions to set the time. The system defaults to UTC standard time, please convert according to the different time zones of your country.

```yaml
schedule:
  - cron: '0 17 * * *'
```

### 5.3 Expanding Github Actions Compilation Space Using Logical Volumes

The default compile space for Github Actions is 84G, with about 50G available after considering the system and necessary software packages. When compiling all firmware, you may encounter an issue with insufficient space, which can be addressed by using logical volumes to expand the compile space to approximately 110G. Refer to the method in the [.github/workflows/build-openwrt.yml](../.github/workflows/build-openwrt.yml) file, and use the commands below to create a logical volume. Then, use the path of the logical volume during the compilation process.

```yaml
- name: Create simulated physical disk
  run: |
    mnt_size=$(expr $(df -h /mnt | tail -1 | awk '{print $4}' | sed 's/[[:alpha:]]//g' | sed 's/\..*//') - 1)
    root_size=$(expr $(df -h / | tail -1 | awk '{print $4}' | sed 's/[[:alpha:]]//g' | sed 's/\..*//') - 4)
    sudo truncate -s "${mnt_size}"G /mnt/mnt.img
    sudo truncate -s "${root_size}"G /root.img
    sudo losetup /dev/loop6 /mnt/mnt.img
    sudo losetup /dev/loop7 /root.img
    sudo pvcreate /dev/loop6
    sudo pvcreate /dev/loop7
    sudo vgcreate github /dev/loop6 /dev/loop7
    sudo lvcreate -n runner -l 100%FREE github
    sudo mkfs.xfs /dev/github/runner
    sudo mkdir -p /builder
    sudo mount /dev/github/runner /builder
    sudo chown -R runner.runner /builder
    df -Th
```

## 6. Saving Firmware

The settings for firmware saving are also controlled in the .github/workflows/build-openwrt.yml file. We automatically upload the compiled firmware to the Actions and Releases provided by the official github through scripts, or to a third party (such as WeTransfer).

Currently, the longest storage period in Actions on github is 90 days, Releases is permanent, and third parties such as WeTransfer are 7 days. First of all, we thank these service providers for their free support, but please also save everyone's use. We advocate reasonable use of free services.

### 6.1 Save to Github Actions

```yaml
- name: Upload artifact to Actions
  uses: kittaakos/upload-artifact-as-is@master
  if: ${{ steps.build.outputs.status }} == 'success' && env.UPLOAD_FIRMWARE == 'true' && !cancelled()
  with:
    path: ${{ env.FILEPATH }}/
```

### 6.2 Save to GitHub Releases

```yaml
- name: Upload OpenWrt Firmware to Release
  uses: ncipollo/release-action@main
  if: ${{ env.PACKAGED_STATUS }} == 'success' && !cancelled()
  with:
    tag: openwrt_amlogic_s9xxx_lede_${{ env.PACKAGED_OUTPUTDATE }}
    artifacts: ${{ env.PACKAGED_OUTPUTPATH }}/*
    allowUpdates: true
    token: ${{ secrets.GITHUB_TOKEN }}
    body: |
      This is OpenWrt firmware for Amlogic s9xxx tv box
      * Firmware information
      Default IP: 192.168.1.1


      Default username: root
      Default password: password
      Default WIFI name: OpenWrt
      Default WIFI password: none
      Install to EMMC: Login to OpenWrt → System → Amlogic Service → Install OpenWrt
```
### 6.3 Save to Third Party

```yaml
- name: Upload OpenWrt Firmware to WeTransfer
  if: ${{ steps.build.outputs.status }} == 'success' && env.UPLOAD_WETRANSFER == 'true' && !cancelled()
  run: |
    curl -fsSL git.io/file-transfer | sh
    ./transfer wet -s -p 16 --no-progress ${{ env.FILEPATH }}/{openwrt_s9xxx_*,openwrt_n1_*} 2>&1 | tee wetransfer.log
    echo "WET_URL=$(cat wetransfer.log | grep https | cut -f3 -d" ")" >> $GITHUB_ENV
```

## 7. Downloading Firmware

Download the OpenWrt firmware that we have already compiled and uploaded to the relevant storage locations.

### 7.1 Download from Github Actions

Click the Actions button in the repository navigation bar. In the All workflows list, click on the completed firmware list. In the firmware list, choose the firmware that corresponds to your box model. The illustration is as follows:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418782-08714c00-7a05-11eb-9556-91575640a4bb.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418785-0ad3a600-7a05-11eb-9fdd-519835a14eaa.jpg width="300" />
</div>

### 7.2 Download from Github Releases

Enter from the Release section in the lower right corner of the repository homepage, select the firmware that corresponds to your box model. The illustration is as follows:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418828-466e7000-7a05-11eb-8f69-a89a1d158a4b.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418841-55edb900-7a05-11eb-9650-7100ebd6042c.jpg width="300" />
</div>

### 7.3 Download from Third Party

In the .github/workflows/build-openwrt.yml file, we have the option to upload to a third party turned off by default. If you need it, change false to true, and it will upload to the third party the next time the compilation is complete. The URL of the third party can be seen in the log of the firmware compilation process, and it can also be output to the compilation information.

```yaml
UPLOAD_COWTRANSFER: false
UPLOAD_WETRANSFER: false
```

The support for uploading to third parties comes from https://github.com/Mikubill/transfer. If you need, you can add more third-party support according to his instructions (control your creativity, don't waste too many free resources). The illustration is as follows:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418921-b5e45f80-7a05-11eb-80ba-02edb0698270.jpg width="300" />
</div>

## 8. Install OpenWrt

### 8.1 Integrating luci-app-amlogic Operation Panel at Compilation Time

1. Get the source code of the plugin `luci-app-amlogic`:
```shell
rm -rf package/luci-app-amlogic
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
```
2. After executing `menuconfig`, you can select the plugin `LuCI ---> 3. Applications  ---> <*> luci-app-amlogic`

For more instructions on the plugin, see: [https://github.com/ophub/luci-app-amlogic](https://github.com/ophub/luci-app-amlogic)

### 8.2 Install Using the Operation Panel

1. For the `Rockchip` platform, please refer to the introduction in the [Chapter 8](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/documents/README.md#8-installing-armbian-to-emmc) of the instruction manual, which is the same as the Armbian installation method.

2. For the `Amlogic` and `Allwinner` platforms, use tools like [Rufus](https://rufus.ie/) or [balenaEtcher](https://www.balena.io/etcher/) to write the firmware into the USB, then insert the USB with the firmware into the box. Access the default IP of OpenWrt from the browser: 192.168.1.1 → `Log in to OpenWrt using the default account` → `System Menu` → `Amlogic Treasure Box` → `Install OpenWrt`.

## 9. Update OpenWrt system or kernel

Access the OpenWrt system from the browser, in the `System` menu, choose `Amlogic Treasure Box`, choose `Upgrade OpenWrt Firmware` or `Change OpenWrt Kernel` feature to upgrade. (You can upgrade from a higher version like 5.15.50 to a lower version like 5.10.125, or you can upgrade from a lower version like 5.10.125 to a higher version like 5.15.50. The level of the kernel version number does not affect the upgrade, you can freely upgrade/downgrade).

[SOS]: In cases where a kernel update is incomplete due to special reasons, causing the system to fail to boot from eMMC/NVMe/sdX, you can boot an OpenWrt system with any kernel version from USB or other disks. To perform kernel rescue, go to `System Menu` > `Amlogic Service` > `Online Download Update` > `Rescue Kernel` to restore the normal use of the original system. You can also use the command `openwer-kernel -s` in the `TTYD terminal` for kernel rescue. When no disk parameter is specified, it defaults to restoring the kernel from a USB device to eMMC/NVMe/sdX. If the device has multiple disks, you can specify the exact disk name that needs to be restored. An example is as follows:

```shell
# To recover the kernel in eMMC
openwer-kernel -s mmcblk1

# To recover the kernel in NVMe
openwer-kernel -s nvme0n1

# To recover the kernel in a removable storage device
openwer-kernel -s sda

# Disk names can be abbreviated as mmcblk0/mmcblk1/nvme0n1/nvme1n1/sda/sdb/sdc, etc., or use the full name, such as /dev/sda
openwer-kernel -s /dev/sda

# When the device has only one built-in storage among eMMC/NVMe/sdX, the disk name parameter can be omitted
openwer-kernel -s
```

## 10. Advanced Tutorial on Personalized Firmware Customization

If you have followed the tutorial to this step, I believe you already know how to play happily. But if you continue to delve into it, you will start an extraordinary journey of exploration. You will encounter many problems, which requires you to be prepared to explore constantly, be good at using search engines to solve problems, and spend some time learning in some OpenWrt communities.


### 10.1 Getting to Know the Complete .config File

Use OpenWrt's official source code repository, or other branch source code repositories, to conduct a local compilation once, such as choosing the source code repository at https://github.com/coolsnowwolf/lede. Following its compilation instructions, install the Ubuntu system locally, deploy the environment, and complete a local compilation. In the local compilation configuration interface, you can also see a lot of rich descriptions, which will strengthen your understanding of the OpenWrt compilation process.

After you complete the personalized configuration of OpenWrt locally, save and exit the configuration interface. You can find the .config file in the root directory of the local OpenWrt source code repository (enter the `ls -a` command in the root directory of the code repository to view all hidden files). You can upload this file directly to your repository on github.com and replace the file at `config/lede-master/config`.

### 10.2 Understanding Workflow Files

GitHub's official detailed instructions on how to use GitHub Actions are available. You can start getting to know it here: [GitHub Actions Quick Start](https://docs.github.com/en/actions/quickstart)

Let's take a simple look at the current compilation process control file being used in the repository as an example: [build-openwrt.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt.yml)

#### 10.2.1 Changing the Address and Branch of the Compilation Source Code Repository

```yaml
#On line 63: This is where the OpenWrt compile source code address is specified
REPO_URL: https://github.com/coolsnowwolf/lede

#On line 64: This is where the branch name is specified
REPO_BRANCH: master
```
You can modify it to the address of other source code repositories, such as using the official source code repository and its `openwrt-21.02` branch:
```yaml
REPO_URL: https://github.com/openwrt/openwrt
REPO_BRANCH: openwrt-21.02
```

#### 10.2.2 Changing the Model and Kernel Version Number of the Box

Around line 139, look for the compile step titled `Build OpenWrt firmware`, and its code block should look like this:
```yaml
- name: Build OpenWrt firmware
  if: ${{ steps.compile.outputs.status }} == 'success' && !cancelled()
  uses: ophub/amlogic-s9xxx-openwrt@main
  with:
    openwrt_path: openwrt/bin/targets/*/*/*rootfs.tar.gz
    openwrt_board: ${{ inputs.openwrt_board }}
    openwrt_kernel: ${{ inputs.openwrt_kernel }}
    auto_kernel: ${{ inputs.auto_kernel }}
    openwrt_size: ${{ inputs.openwrt_size }}
```
Refer to the [parameter instructions](../README.md#gitHub-actions-input-parameters-explanation) related to the packaging command. The above setting options can be set by writing in fixed values, or they can be selected through the `Actions` panel:
<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/181870674-1816aa21-ece4-4149-83ce-6ec7f95ece68.png width="700" />
</div>

### 10.3 Customizing Banner Information

The default [/etc/banner](../openwrt-files/common-files/etc/banner) information is as follows, you can use a [banner generator](https://www.bootschool.net/ascii) to customize your own personalized banner information (the style below is `slant`), just overwrite the file with the same name.

```shell
      ____                 _       __     __        ____
     / __ \____  ___  ____| |     / /____/ /_      / __ )____  _  __
    / / / / __ \/ _ \/ __ \ | /| / / ___/ __/_____/ __  / __ \| |/_/
   / /_/ / /_/ /  __/ / / / |/ |/ / /  / /_/_____/ /_/ / /_/ />  <
   \____/ .___/\___/_/ /_/|__/|__/_/   \__/     /_____/\____/_/|_|
       /_/  H E L L O - W O R L D    W I R E L E S S - F R E E D O M
───────────────────────────────────────────────────────────────────────
```

### 10.4 Customize feeds configuration file

When you look at the feeds.conf.default file in the source code repository, have you noticed that it introduces many package source code repositories? Yes, we can find the source code repository provided by the official openwrt on GitHub, and many people share the branches and packages of openwrt. If you are familiar with them, you can add from here. For example, the [feeds.conf.default](https://github.com/coolsnowwolf/lede/blob/master/feeds.conf.default) in the coolsnowwolf source code repository.

### 10.5 Customize default software configuration information

When we are using openwrt, we have configured many pieces of software. Most of the configuration information of these software is saved in the /etc/config/ and other related directories of your openwrt. Copy these configuration information storage files to the files folder in the root directory of the repository on GitHub. Please keep the directory structure and file names the same. During the openwrt compilation, these configuration information storage files will be compiled into your firmware. The specific method is in the .github/workflows/build-openwrt.yml file. Let's take a look at this piece of code together:

```yaml
- name: Load custom configuration
  run: |
    [[ -d "files" ]] && mv -f files openwrt/files
    [[ -e "${CONFIG_FILE}" ]] && cp -f ${CONFIG_FILE} openwrt/.config
    chmod +x ${DIY_P2_SH}
    cd openwrt
    ${GITHUB_WORKSPACE}/${DIY_P2_SH}
```

Please do not copy those configuration information files that involve privacy. If your repository is public, the files you put in the files directory are also public. Do not expose secrets. Some password information can be encrypted using private key settings and other methods that you just learned in the GitHub Actions Quick Start Guide. You must understand what you are doing.

### 10.6 Opkg package management

Like most Linux distributions (or mobile device operating systems, such as Android or iOS), the functionality of the system can be upgraded by downloading and installing packages from package repositories (local or Internet). The opkg utility is a lightweight package manager used for this job. It is designed to add software to the firmware of embedded devices. Opkg is a complete package manager for the root file system, including kernel modules and drivers. The opkg package manager tries to solve the dependencies of packages in the repository. If it fails, it will report an error and abort the installation of the package. Third-party packages may lack dependencies, which can be obtained from the source of the package. To ignore dependency errors, pass the `--force-depends` argument.

- If you are using a snapshot/trunk/latest version, installing a package may fail if the kernel version used by the package in the repository is newer than the kernel version you own. In this case, you will receive an error message like `Cannot satisfy the following dependencies...`. For this usage of OpenWrt firmware, it is strongly recommended that you directly integrate the packages you need during the OpenWrt firmware compilation.

- Non-official openwrt.org plugins, such as `luci-app-uugamebooster`, `luci-app-xlnetacc`, etc., need to be directly integrated during firmware compilation. These packages cannot be installed directly from the mirror server using opkg, but you can manually upload these packages to openwrt and use opkg to install them.

- On the trunk/snapshot, the kernel and kmod packages are marked as reserved, and the `opkg upgrade` command will not attempt to update them.

Common commands:
```shell
opkg update                                       #Update the list of available packages
opkg upgrade <pkgs>                               #Upgrade packages
opkg install <pkgs>                               #Install packages
opkg install --force-reinstall <pkgs>             #Force reinstallation of packages
opkg configure <pkgs>                             #Configure unpacked packages
opkg remove <pkgs | regexp>                       #Remove packages
opkg list                                         #List available packages
opkg list-installed                               #List installed packages
opkg list-upgradable                              #List installed and upgradable packages
opkg list | grep <pkgs>                           #Search for packages matching keywords
```
For more help, please check [opkg](https://openwrt.org/docs/guide-user/additional-software/opkg)

### 10.7 Manage packages using the Web interface

After installing the OpenWrt firmware on the device, other packages can be installed through WebUI.

1. Login to OpenWrt → `System` → `Software packages`
2. Click the `Refresh list` button to update
3. Fill in the `Filter` field, and then click the `Find Package` button to search for specific packages
4. Switch to the `Available packages` tab to display the packages that can be installed
5. Switch to the `Installed packages` tab to display and delete installed packages

If you want to use LuCI to configure services, please search and install `luci-app-*` packages.

For more help, please check [packages](https://openwrt.org/packages/start)

### 10.8 How to restore the original Android TV system

The Android TV system on the device is usually backed up and restored using `openwrt-ddbr`.

In addition, the Android system can also be flashed into eMMC using the method of flashing via a cable. The download image of the Android system can be found in [Tools](https://github.com/ophub/kernel/releases/tag/tools).

#### 10.8.1 Backup and Recovery Using openwrt-ddbr

Before installing the OpenWrt system on a brand-new box, it is suggested that you backup the original Android TV system that the box comes with, for recovery purposes when needed. Boot the OpenWrt system from `TF/SD/USB`, type in the `openwrt-ddbr` command, and then input `b` following the prompts to back up the system. The backup file is stored in the path `/ddbr/BACKUP-arm-64-emmc.img.gz`, please download and save it. When you need to restore the Android TV system, upload the previously backed-up file to the same path on the `TF/SD/USB` device, input the `openwrt-ddbr` command, and then input `r` according to the prompts to restore the system.

#### 10.8.2 Recovery Using Amlogic Flashing Tool

- Generally, if you can boot from USB by plugging in the power again, all you need to do is reinstall, try a few more times.

- If the box does not boot from the USB and the screen is black after being connected to a monitor, it's necessary to short-circuit the box for initialization. First, restore the box to the original Android system, then reflash the OpenWrt system. Firstly, download the [amlogic_usb_burning_tool](https://github.com/ophub/kernel/releases/tag/tools) system recovery tool and install it. Prepare a [USB A-A data cable](https://user-images.githubusercontent.com/68696949/159267576-74ad69a5-b6fc-489d-b1a6-0f8f8ff28634.png) and a [paper clip](https://user-images.githubusercontent.com/68696949/159267790-38cf4681-6827-4cb6-86b2-19c7f1943342.png).

- For example, for the x96max+ model, confirm the location of the [short-circuit point](https://user-images.githubusercontent.com/68696949/110590933-67785300-81b3-11eb-9860-986ef35dca7d.jpg) on the box's motherboard, download the [Android TV firmware package](https://github.com/ophub/kernel/releases/tag/tools) for the box. The Android TV system firmware and corresponding short-circuit point diagrams for other common devices can also be [downloaded and viewed here](https://github.com/ophub/kernel/releases/tag/tools).

```shell
Operation method:

1. Open the flashing software USB Burning Tool:
   [ File → Import firmware package ]: X96Max_Plus2_20191213-1457_ATV9_davietPDA_v1.5.img
   [ Select ]: Erase flash
   [ Select ]: Erase bootloader
   Click the [ Start ] button
2. Use the [ paperclip ] to [ short-circuit the two points on the box's motherboard ],
   and simultaneously connect the [ box ] and [ computer ] with the [ USB A-A data cable ].
3. When you see the [ progress bar start moving ], remove the paperclip, no longer short-circuit.
4. When you see [ progress bar at 100% ], the flashing is complete, and the box has been restored to the Android TV system.
   Click the [ Stop ] button, unplug the [ USB A-A data cable ] between the [ box ] and [ computer ].
5. If any step above fails, try again until successful.
   If the progress bar does not move, you can try plugging in the power. Under normal circumstances, the power provided by the USB A-A alone is sufficient for flashing.
```

Once the factory reset is complete, the box has been restored to the Android TV system, the operation of installing the OpenWrt system is the same as the first time you installed the system. Just do it again.

#### 10.9 Unable to Boot After Installing Mainline u-boot

- A very small number of devices may not be able to boot after choosing to write the mainline `u-boot`. The prompt seen on the monitor ends with a `=>` symbol. At this point, you need to solder a 5-10 K pull-up or pull-down resistor on the TTL to solve the problem of the box being easily interfered by surrounding electromagnetic signals and failing to boot. After soldering the resistor, it can boot from the EMMC.

If you chose to install the mainline `u-boot` and cannot boot, please connect your box to the screen and check if the prompt is as follows:

```shell
Net: eth0: ethernet0ff3f0000
Hit any key to stop autoboot: 0
=>
```

If your phenomenon is as shown above, then you need to solder a resistor on the TTL: [X96 Max Plus's V4.0 motherboard diagram](https://user-images.githubusercontent.com/68696949/110910162-ec967000-834b-11eb-8fa6-64727ccbe4af.jpg)

```shell
#######################################################        ########################################################
#                                                     #        #                                                      #
#   Pull-Up Resistor: Solder between TTL RX and GND   #        #  Pull-Down Resistor: Solder between TTL 3.3V and RX  #
#                                                     #        #                                                      #
#            3.3V   RX       TX       GND             #   OR   #        3.3V               RX     TX     GND          #
#                    ┖————█████████————┚              #        #         ┖————█████████————┚                          #
#                      (5~10kΩ)                       #        #                  (5~10kΩ)                            #
#                                                     #        #                                                      #
#######################################################        ########################################################
```

### 10.10 Setting up the Box to Boot from USB/TF/SD

Based on the situation of your own device, there are two methods to use: initial installation and reinstallation of the OpenWrt system.

#### 10.10.1 Initial Installation of OpenWrt System

- Insert the USB/TF/SD with the flashed firmware into the box.
- Enable developer mode: Settings → About Device → Version number (e.g., X96max plus...), quickly click the left mouse button 5 times on the version number, until the system shows a prompt saying `Developer mode is enabled`.
- Enable USB debugging mode: System → Advanced options → Developer options (set `Enable USB debugging` to enabled). Enable `ADB` debugging.
- Install the ADB tool: Download [adb](https://github.com/ophub/kernel/releases/tag/tools) and unzip it, copy the three files `adb.exe`, `AdbWinApi.dll`, `AdbWinUsbApi.dll` to both the `system32` and `syswow64` folders in the `c://windows/` directory, then open the `cmd` command panel, use the `adb --version` command, if it shows something, it means you can use it now.
- Enter `cmd` command mode. Type the `adb connect 192.168.1.137` command (modify the IP according to your box, you can check it in the router device that the box is connected to), if the connection is successful, it will display `connected to 192.168.1.137:5555`.
- Type the `adb shell reboot update` command, the box will restart and boot from the USB/TF/SD you inserted, access the firmware IP address from the browser, or SSH access to enter the firmware.
- Login to the OpenWrt system: Directly connect your box to your computer → Turn off the WIFI option of the computer, only use the wired network card → Set the network of the wired network card to the same segment as OpenWrt, if the default IP of OpenWrt is: `192.168.1.1`, you can set the computer's IP to `192.168.1.2`, the subnet mask is set to `255.255.255.0`, besides these 2 options, no other options need to be set. Then you can enter OpenWrt from the browser. The default IP: `192.168.1.1`, default account: `root`, default password: `password`.

#### 10.10.2 Reinstallation of OpenWrt System

- In normal situations, you can directly insert the USB flash drive with OpenWrt installed and boot from it. USB booting takes priority over eMMC.
- In some cases, the device may not boot from the USB flash drive. In such cases, you can rename the `boot.scr` file in the `/boot` directory of the OpenWrt system on the eMMC. For example, you can rename it to `boot.scr.bak`. After that, you can insert the USB flash drive and boot from it. This way, you will be able to boot from the USB flash drive.

### 10.11 Required OpenWrt Options

This list is organized based on the development guide from [unifreq](https://github.com/unifreq/openwrt_packit). To ensure that installation/update scripts can run normally in OpenWrt, when using `make menuconfig` for configuration, the following required options need to be added:

```shell
Target System  -> Arm SystemReady (EFI) compliant
Subtarget      -> 64-bit (armv8) machines
Target Profile -> Generic EFI Boot
Target Images  -> tar.gz

OR

Target System  -> QEMU ARM Virtual Machine
Subtarget      -> QEMU ARMv8 Virtual Machine (cortex-a53)
Target Profile -> Default
Target Images  -> tar.gz


Kernel modules -> Wireless Drivers -> kmod-brcmfmac(SDIO)
                                   -> kmod-brcmutil
                                   -> kmod-cfg80211
                                   -> kmod-mac80211


Languages -> Perl
             -> perl-http-date
             -> perlbase-file
             -> perlbase-getopt
             -> perlbase-time
             -> perlbase-unicode
             -> perlbase-utf8
          -> Python
             -> Python3-ctypes
             -> Python3-logging
             -> Python3-yaml


Network -> File Transfer -> curl、wget-ssl
        -> Version Control Systems -> git
        -> WirelessAPD   -> hostapd-common
                         -> wpa-cli
                         -> wpad-basic
        -> iw


Utilities -> Compression -> bsdtar、pigz
          -> Disc -> blkid、fdisk、lsblk、parted
          -> Editors -> nano、vim
          -> Filesystem -> attr、btrfs-progs(Build with zstd support)、chattr、dosfstools、
                           e2fsprogs、f2fs-tools、f2fsck、lsattr、mkf2fs、xfs-fsck、xfs-mkfs
          -> Shells -> bash
          -> Time Zone info -> zoneinfo-america、zoneinfo-asia、zoneinfo-core、zoneinfo-europe (other)
          -> acpid、coremark、coreutils(-> coreutils-base64、coreutils-dd、coreutils-df、coreutils-nohup、
             coreutils-tail、coreutils-timeout、coreutils-touch、coreutils-tr、coreutils-truncate)、
             gawk、getopt、jq、lm-sensors、losetup、pv、tar、uuidgen
```
