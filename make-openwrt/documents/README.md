# OpenWrt Production and Usage Guide

View Chinese description | [查看中文说明](README.cn.md)

The method of using GitHub Actions to cloud compile OpenWrt, as well as many of the contents in this document, are from many technical innovators and resource sharers such as P3TERX and Flippy. Thanks to everyone's contribution, it has become so easy for us to use OpenWrt on boxes.

Github Actions is a service launched by Microsoft. It provides a virtual server environment with very good performance configuration. Based on it, projects can be built, tested, packaged, and deployed. For public repositories, it can be used for free without time limit, and the single compilation time can reach 6 hours, which is enough for compiling OpenWrt (we can usually complete one compilation work in about 3 hours). Sharing is just for exchanging experiences. Please understand the shortcomings, and do not launch various malicious attacks on the network or use GitHub Actions maliciously.

# 目录

- [OpenWrt Production and Usage Guide](#openwrt-production-and-usage-guide)
- [目录](#目录)
  - [1. Register your Github account](#1-register-your-github-account)
  - [2. Set the privacy variable GITHUB\_TOKEN](#2-set-the-privacy-variable-github_token)
  - [3. Fork the repository and set GH\_TOKEN](#3-fork-the-repository-and-set-gh_token)
  - [4. Personalized OpenWrt firmware customization file description](#4-personalized-openwrt-firmware-customization-file-description)
    - [4.1 .config file description](#41-config-file-description)
      - [4.1.1 First, let the firmware support local language](#411-first-let-the-firmware-support-local-language)
      - [4.1.2 Select personalized software packages](#412-select-personalized-software-packages)
    - [4.2 DIY script operation: diy-part1.sh and diy-part2.sh](#42-diy-script-operation-diy-part1sh-and-diy-part2sh)
      - [Example 1, adding a third-party software package](#example-1-adding-a-third-party-software-package)
      - [Example 2, replacing a software package with the same name](#example-2-replacing-a-software-package-with-the-same-name)
      - [Example 3, implementing certain requirements by modifying the code in the source code library](#example-3-implementing-certain-requirements-by-modifying-the-code-in-the-source-code-library)
    - [4.3 Use Image Builder to create firmware](#43-use-image-builder-to-create-firmware)
  - [5. Compiling Firmware](#5-compiling-firmware)
    - [5.1 Manual compilation](#51-manual-compilation)
    - [5.2 Scheduled compilation](#52-scheduled-compilation)
  - [6. Saving Firmware](#6-saving-firmware)
    - [6.1 Save to Github Actions](#61-save-to-github-actions)
    - [6.2 Save to GitHub Releases](#62-save-to-github-releases)
    - [6.3 Save to a Third-Party](#63-save-to-a-third-party)
  - [7. Downloading Firmware](#7-downloading-firmware)
    - [7.1 Download from Github Actions](#71-download-from-github-actions)
    - [7.2 Download from Github Releases](#72-download-from-github-releases)
    - [7.3 Download from a Third Party](#73-download-from-a-third-party)
  - [8. Installing Firmware](#8-installing-firmware)
    - [8.1 Integrate luci-app-amlogic Operation Panel during Compilation](#81-integrate-luci-app-amlogic-operation-panel-during-compilation)
    - [8.2 Install using the Operation Panel](#82-install-using-the-operation-panel)
  - [9. Upgrading Firmware](#9-upgrading-firmware)
  - [10. Personalized Firmware Customization and Upgrade Tutorial](#10-personalized-firmware-customization-and-upgrade-tutorial)
    - [10.1 Understanding the Complete .config File](#101-understanding-the-complete-config-file)
    - [10.2 Understanding the Workflow File](#102-understanding-the-workflow-file)
      - [10.2.1 Change the Address and Branch of the Compilation Source Code Repository](#1021-change-the-address-and-branch-of-the-compilation-source-code-repository)
      - [10.2.2 Change the Box Model and Kernel Version Number](#1022-change-the-box-model-and-kernel-version-number)
    - [10.3 Customizing Banner Information](#103-customizing-banner-information)
    - [10.4 Customizing Feeds Configuration File](#104-customizing-feeds-configuration-file)
    - [10.5 Customizing Default Software Configuration Information](#105-customizing-default-software-configuration-information)
    - [10.6 Opkg Package Management](#106-opkg-package-management)
    - [10.7 Managing Packages Using the Web Interface](#107-managing-packages-using-the-web-interface)
    - [10.8 How to Restore the Original Android TV System](#108-how-to-restore-the-original-android-tv-system)
      - [10.8.1 Using openwrt-ddbr Backup and Restore](#1081-using-openwrt-ddbr-backup-and-restore)
      - [10.8.2 Using Amlogic Flashing Tool to Restore](#1082-using-amlogic-flashing-tool-to-restore)
    - [10.9 Unable to Boot After Installing Mainline u-boot](#109-unable-to-boot-after-installing-mainline-u-boot)
    - [10.10 Setting the Box to Boot from USB/TF/SD](#1010-setting-the-box-to-boot-from-usbtfsd)
    - [10.11 OpenWrt Required Options](#1011-openwrt-required-options)

## 1. Register your Github account

Register your own account to continue with firmware customization. Click the `Sign up` button in the top right corner of the github.com website and follow the prompts to register your account.

## 2. Set the privacy variable GITHUB_TOKEN

Set the Github privacy variable `GITHUB_TOKEN`. After the firmware is compiled, we need to upload the firmware to Releases. We set this variable according to Github's official requirements, as follows:
Personal center: Settings > Developer settings > Personal access tokens > Generate new token ( Name: GITHUB_TOKEN, Select: public_repo ). Other options can be selected based on your needs. Submit and save, copy the encrypted KEY generated by the system, save it to your computer's notepad first, and you will use this value in the next step. See the figure below for an illustration:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418474-85032b00-7a03-11eb-85a2-759b0320cc2a.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418479-8b91a280-7a03-11eb-8383-9d970f4fffb6.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418483-90565680-7a03-11eb-8320-0df1174b0267.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418493-9815fb00-7a03-11eb-862e-deca4a976374.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418485-93514700-7a03-11eb-848d-36de784a4438.jpg width="300" />
</div>

## 3. Fork the repository and set GH_TOKEN

Now you can fork the repository. Open the repository https://github.com/ophub/amlogic-s9xxx-openwrt, click the Fork button in the upper right corner, copy a repository code to your account, wait a few seconds, and when prompted that the Fork is complete, go to your account and access amlogic-s9xxx-openwrt in your repository. In the upper right corner, go to `Settings` > `Secrets` > `Actions` > `New repostiory secret` ( Name: `GH_TOKEN`, Value: `Fill in the value of GITHUB_TOKEN just now` ), save it. And under `Actions` > `General` > `Workflow permissions` on the left navigation bar, select `Read and write permissions` and save it. See the figure below for an illustration:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418568-0eb2f880-7a04-11eb-81c9-194e32382998.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/163203032-f044c63f-d113-4076-bf94-41f86c7dd0ce.png width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418573-15417000-7a04-11eb-97a7-93973d7479c2.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/167579714-fdb331f3-5198-406f-b850-13da0024b245.png width="300" />
<img src=https://user-images.githubusercontent.com/68696949/167585338-841d3b05-8d98-4d73-ba72-475aad4a95a9.png width="300" />
</div>

## 4. Personalized OpenWrt firmware customization file description

After the preparation work of the previous three steps, let's start customizing personalized firmware. There are three files in the [config-openwrt/lede-master](../../config-openwrt/lede-master) directory for customizing OpenWrt firmware. In this chapter, we will only provide a simple explanation to allow you to experience the joy of personalized customization at your fingertips. More complicated customized operations are described in Section 10, which requires a little bit of foundation.

### 4.1 .config file description

This file is the core file for customizing OpenWrt software package, which contains all configuration information. Each line of code in the file represents a personalized configuration option. Although there are many items, management is very simple. Let's get started.

#### 4.1.1 First, let the firmware support local language

In # National language packs, luci-i18n-base: Taking French as an example, to enable French support, just change

```shell
# CONFIG_PACKAGE_luci-i18n-base-fr is not set
```

to

```shell
CONFIG_PACKAGE_luci-i18n-base-fr=y
```

This is how to customize all items in the .config file. For items that you do not need, add `#` at the beginning of the line, and change `=y` at the end to `is not set`. For items that you need, remove the `#` at the beginning of the line, and change `is not set` at the end to `=y`.

#### 4.1.2 Select personalized software packages

In `#LuCI-app:`, enabling and deleting default software packages is done in the same way as above. This time, let's remove the `luci-app-zerotier` plugin from the default software package. Change

```shell
CONFIG_PACKAGE_luci-app-zerotier=y
```

to

```shell
# CONFIG_PACKAGE_luci-app-zerotier is not set
```

I think you should already understand how to customize the configuration. Each line in the .config file represents a configuration item, and you can use this method to enable or delete default configurations in the firmware. The complete content of this file has several thousand lines. I provide only the simplified version here. How to obtain the complete configuration file and perform more complex personalized customization will be introduced in Section 10.

### 4.2 DIY script operation: diy-part1.sh and diy-part2.sh

The scripts diy-part1.sh and diy-part2.sh are executed before and after updating and installing feeds. When we introduce OpenWrt's source code library for personalized firmware compilation, sometimes we want to rewrite some of the code in the source code library, or add some third-party provided software packages, delete or replace some software packages in the source code library, such as modifying the default IP, host name, theme, adding/deleting software packages, etc. These instructions for modifying the source code library can be written to these 2 scripts. We take the OpenWrt source code library provided by coolsnowwolf as an example and illustrate a few examples.

All of our operations below are based on this source code library: [https://github.com/coolsnowwolf/lede](https://github.com/coolsnowwolf/lede).

#### Example 1, adding a third-party software package

Step 1: Add the following code to diy-part2.sh:

```shell
git clone https://github.com/jerrykuku/luci-app-ttnode.git package/lean/luci-app-ttnode
```

Step 2: Add the enable code for the third-party software package to the .config file:

```shell
CONFIG_PACKAGE_luci-app-ttnode=y
```

This completes the integration of the third-party software package and expands the software packages that are not currently available in the source code library.

#### Example 2, replacing a software package with the same name

Step 1: Add the following code to diy-part2.sh: Use the first line of code to delete the original software from the source code library, and then use the second line to introduce the third-party software package with the same name.

```shell
rm -rf package/lean/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon
```

Step 2: Add the third-party software package to the .config file:

```shell
CONFIG_PACKAGE_luci-theme-argon=y
```

This replaces the existing software package in the current source code library with a third-party one with the same name.

#### Example 3, implementing certain requirements by modifying the code in the source code library

We add support for `aarch64` to `luci-app-cpufreq` so that we can use it in our firmware (some modifications should be made with caution, you must know what you are doing).

Source file address: [luci-app-cpufreq/Makefile](https://github.com/coolsnowwolf/luci/blob/master/applications/luci-app-cpufreq/Makefile). Modify the code to add support for aarch64:

```shell
sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' package/lean/luci-app-cpufreq/Makefile
```

This completes the modification of the source code. Through the two scripts diy-part1.sh and diy-part2.sh, we added some operating commands to make the compiled firmware more in line with our personalized needs.

### 4.3 Use Image Builder to create firmware

The OpenWrt official website provides a pre-made openwrt-imagebuilder-*-armvirt-64.Linux-x86_64.tar.xz file (download address: [https://downloads.openwrt.org/releases](https://downloads.openwrt.org/releases)), which can be used with the official Image Builder to add software packages and plugins to this file. Usually, it only takes a few minutes to create an openwrt-rootfs.tar.gz file. The production method can refer to the official document: [Using Image Builder](https://openwrt.org/zh/docs/guide-user/additional-software/imagebuilder).

This repository provides a one-click production service. You only need to pass the branch parameter into the [imagebuilder script](imagebuilder/imagebuilder.sh) to complete the production.

- Local production command: You can run the `sudo ./config-openwrt/imagebuilder/imagebuilder.sh openwrt:21.02.3` command in the `~/amlogic-s9xxx-openwrt` root directory to generate it. The parameter `21.02.3` is the current version number of the `releases` that can be [downloaded](https://downloads.openwrt.org/releases). The generated file is located in the `openwrt/bin/targets/armvirt/64` directory.

- Use `Actions` on github.com to produce: [Build OpenWrt with Image Builder](../.github/workflows/build-openwrt-with-imagebuilder.yml)

## 5. Compiling Firmware

The default system configuration information is recorded in the [/etc/model_database.conf](../openwrt-files/common-files/etc/model_database.conf) file, and the name of `BOARD` requires uniqueness.

Among them, the value of `BUILD` that is `yes` is the default system for some boxed systems that are packaged and can be used directly. The default value of `no` is not packaged. These un-packaged boxes need to download the packaged system of the same `FAMILY` (recommended to download the system with kernel `5.15/5.4`). After writing to `USB`, you can open the `boot partition in USB ` on the computer, modify the `dtb name of FDT` in the `/boot/uEnv.txt` file, and adapt to other boxes in the compatibility list.

When compiling locally, specify it with the `-b` parameter, and specify it with the `openwrt_board` parameter in github.com's Actions. Use `-b all` to package all devices where `BUILD` is `yes`. When packaging with a specified `BOARD` parameter, it can be packaged regardless of whether `BUILD` is `yes` or `no`. For example: `-b r68s_s905x3-tx3_s905l3a-cm311`

### 5.1 Manual compilation

In your repository's navigation bar, click the Actions button, and then click Build OpenWrt > Run workflow > Run workflow in turn to start compiling. It takes about 3 hours to complete the entire process after all processes are completed. The diagram is as follows:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418662-a0226a80-7a04-11eb-97f6-aeb893336e8c.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418663-a31d5b00-7a04-11eb-8d34-57d430696901.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418666-a7497880-7a04-11eb-9ed0-be738e22f7ae.jpg width="300" />
</div>

### 5.2 Scheduled compilation

In the .github/workflows/build-openwrt-with-lede.yml file, use Cron to set the scheduled compilation, and the five different positions represent the meaning of minutes (0-59)/hours (0-23)/date (1-31)/month (1-12)/day of the week (0-6) (Sunday-Saturday). Modify the numerical value in different locations to set the time. The system uses UTC standard time by default, please convert it according to the time zone of your country.

```yaml
schedule:
  - cron: '0 17 * * *'
```

## 6. Saving Firmware

The firmware saving settings are also controlled in the .github/workflows/build-openwrt-with-lede.yml file. We automatically upload the compiled firmware to Actions and Releases provided by GitHub through scripts, or upload them to third-party services (such as WeTransfer).

The maximum retention period of Actions in Github is now 90 days, Releases is permanent, and third parties such as WeTransfer are 7 days. First of all, we thank these service providers for their free support, but please use them sparingly. We advocate reasonable use of free services.

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
    token: ${{ secrets.GH_TOKEN }}
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
### 6.3 Save to a Third-Party

```yaml
- name: Upload OpenWrt Firmware to WeTransfer
  if: ${{ steps.build.outputs.status }} == 'success' && env.UPLOAD_WETRANSFER == 'true' && !cancelled()
  run: |
    curl -fsSL git.io/file-transfer | sh
    ./transfer wet -s -p 16 --no-progress ${{ env.FILEPATH }}/{openwrt_s9xxx_*,openwrt_n1_*} 2>&1 | tee wetransfer.log
    echo "WET_URL=$(cat wetransfer.log | grep https | cut -f3 -d" ")" >> $GITHUB_ENV
```

## 7. Downloading Firmware

Download the OpenWrt firmware we have compiled and uploaded to the relevant storage location.

### 7.1 Download from Github Actions

Click the Actions button in the repository navigation bar, click the compiled firmware list in the All workflows list, and select the firmware corresponding to your box model in the firmware list. The figure is as follows:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418782-08714c00-7a05-11eb-9556-91575640a4bb.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418785-0ad3a600-7a05-11eb-9fdd-519835a14eaa.jpg width="300" />
</div>

### 7.2 Download from Github Releases

Enter the Release section in the lower right corner of the repository homepage and select the firmware corresponding to your box model. The figure is as follows:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418828-466e7000-7a05-11eb-8f69-a89a1d158a4b.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418841-55edb900-7a05-11eb-9650-7100ebd6042c.jpg width="300" />
</div>

### 7.3 Download from a Third Party

In the .github/workflows/build-openwrt-with-lede.yml file, we have disabled the option to upload to third parties by default. If you need it, change false to true, and it will be uploaded to the third party after the next compilation is completed. The third-party website can be seen in the firmware compilation process logs, or output to the compilation information.

```yaml
UPLOAD_COWTRANSFER: false
UPLOAD_WETRANSFER: false
```

Support for uploading to third parties comes from https://github.com/Mikubill/transfer. If you need it, you can add more third-party support according to their instructions (control your creativity and don't waste too much free resources). The figure is as follows:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418921-b5e45f80-7a05-11eb-80ba-02edb0698270.jpg width="300" />
</div>

## 8. Installing Firmware

### 8.1 Integrate luci-app-amlogic Operation Panel during Compilation

1. `svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic`
2. After executing `menuconfig`, you can choose the plugin `LuCI ---> 3. Applications  ---> <*> luci-app-amlogic`

For more explanation of the plugin, please see: [https://github.com/ophub/luci-app-amlogic](https://github.com/ophub/luci-app-amlogic)

### 8.2 Install using the Operation Panel

1. For the `Rockchip` platform installation method, please refer to Chapter 8 in the documentation for the same installation method as Armbian.

2. For the `Amlogic` and `Allwinner` platforms, use tools such as [Rufus](https://rufus.ie/) or [balenaEtcher](https://www.balena.io/etcher/) to write the firmware into the USB, and then insert the USB with the written firmware into the box. Access OpenWrt's default IP from the browser: 192.168.1.1 → `Login to OpenWrt with default account` → `System Menu` → `Amlogic Service` → `Install OpenWrt`.

## 9. Upgrading Firmware

Access the OpenWrt system from the browser, select `Amlogic Service` in the `System` menu, and select `Upgrade OpenWrt firmware` or `Replace OpenWrt kernel` to upgrade. (You can upgrade from a higher version like 5.15.50 to a lower version like 5.10.125, or from a lower version like 5.10.125 to a higher version like 5.15.50. The high and low versions of the kernel version do not affect the upgrade, and you can freely upgrade/downgrade).

## 10. Personalized Firmware Customization and Upgrade Tutorial

If you have followed this tutorial to this step, I believe you already know how to play with OpenWrt. But if you continue to explore deeper, you will embark on an extraordinary journey of tinkering. You will encounter many problems, which require you to have a mentality of continuous exploration, be good at using search engines to solve problems, and spend some time learning in the OpenWrt community.

### 10.1 Understanding the Complete .config File

Use the official OpenWrt source code repository or other branch repositories for local compilation. For example, select the source code repository https://github.com/coolsnowwolf/lede and install Ubuntu locally according to its compilation instructions. The environment is deployed and a local compilation is completed. In the local compilation configuration interface, you can also see many rich explanations, which will strengthen your understanding of the OpenWrt compilation process.

After you complete the OpenWrt personalized configuration locally, save and exit the configuration interface. You can find the .config file in the root directory of the local OpenWrt source code repository (enter the command `ls -a` in the root directory of the code repository to view all hidden files). You can directly upload this file to your repository on github.com and replace the file config-openwrt/lede-master/config.

### 10.2 Understanding the Workflow File

GitHub provides detailed instructions on the use of GitHub Actions. You can start learning it from here: [GitHub Actions Quick Start](https://docs.github.com/en/actions/quickstart)

Let's take the workflow control file currently used in this repository as an example to briefly introduce it: [build-openwrt-with-lede.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt-with-lede.yml)

#### 10.2.1 Change the Address and Branch of the Compilation Source Code Repository

```yaml
# On line 63: Specifies the address of the OpenWrt compilation source code
REPO_URL: https://github.com/coolsnowwolf/lede

# On line 64: Specifies the name of the branch
REPO_BRANCH: master
```

You can modify it to the address of other source code repositories, such as using the official source code repository and its `openwrt-21.02` branch:

```yaml
REPO_URL: https://github.com/openwrt/openwrt
REPO_BRANCH: openwrt-21.02
```

#### 10.2.2 Change the Box Model and Kernel Version Number

Near line 139, find the compilation step with the title `Build OpenWrt firmware`, and its code block is similar to this:

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
    gh_token: ${{ secrets.GH_TOKEN }}
```

Refer to the related [parameter description](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/README.md#github-actions-input-parameter-description) of the packaging command. The above settings options can be set by writing fixed values or by selecting through the `Actions` panel:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/181870674-1816aa21-ece4-4149-83ce-6ec7f95ece68.png width="700" />
</div>

### 10.3 Customizing Banner Information

The default [/etc/banner](../openwrt-files/common-files/etc/banner) information is as follows. You can use the [banner generator](https://www.bootschool.net/ascii) to customize your own personalized banner information (the style below is `slant`). Overwrite the file with the same name to replace it.

```shell
      ____                 _       __     __        ____
     / __ \____  ___  ____| |     / /____/ /_      / __ )____  _  __
    / / / / __ \/ _ \/ __ \ | /| / / ___/ __/_____/ __  / __ \| |/_/
   / /_/ / /_/ /  __/ / / / |/ |/ / /  / /_/_____/ /_/ / /_/ />  <
   \____/ .___/\___/_/ /_/|__/|__/_/   \__/     /_____/\____/_/|_|
       /_/  H E L L O - W O R L D    W I R E L E S S - F R E E D O M
───────────────────────────────────────────────────────────────────────
```

### 10.4 Customizing Feeds Configuration File

When you view the feeds.conf.default file in the source code repository, do you find that it imports many software package repositories? Yes, we can find the source code repositories provided by OpenWrt and many people's branches and software packages on GitHub. If you know them, you can add them here. For example, the [feeds.conf.default](https://github.com/coolsnowwolf/lede/blob/master/feeds.conf.default) in the coolsnowwolf repository.

### 10.5 Customizing Default Software Configuration Information

We have already configured many software when using OpenWrt. Most of the configuration information of these software is saved in the /etc/config/ related directories of your OpenWrt. Copy these storage files of configuration information to the files folder in the root directory of your GitHub repository, please keep the directory structure and file names the same. During OpenWrt compilation, these configuration information storage files will be compiled into your firmware. The specific method is in the .github/workflows/build-openwrt-with-lede.yml file. Let's take a look at this code together:

```yaml
- name: Load custom configuration
  run: |
    [[ -d "files" ]] && mv -f files openwrt/files
    [[ -e "${CONFIG_FILE}" ]] && cp -f ${CONFIG_FILE} openwrt/.config
    chmod +x ${DIY_P2_SH}
    cd openwrt
    ${GITHUB_WORKSPACE}/${DIY_P2_SH}
```

Please do not copy configuration information files involving privacy. If your repository is public, the files you put in the files folder are also public. Do not disclose secrets publicly. Some password and other information can be encrypted and used with methods such as private key settings learned in the GitHub Actions Quick Start guide you just learned. You must understand what you are doing.

### 10.6 Opkg Package Management

Like most Linux distributions (or mobile device operating systems such as Android or iOS), system functionality can be upgraded by downloading and installing packages from software repositories (local or Internet). The opkg utility is a lightweight package manager used for this task, intended to add software to firmware on embedded devices. Opkg is a full package manager for the root file system, including kernel modules and drivers. The software package manager opkg attempts to resolve dependencies for packages in the repository, and if it fails, it reports an error and aborts the installation of that package. Third-party packages may lack dependencies and can be obtained from the source of the package. To ignore dependency errors, pass the `--force-depends` parameter.

- If you are using a snapshot/trunk/latest version, installing a package may fail if the kernel version used by the package in the repository is newer than the kernel version you have. In this case, you will receive an error message such as `Unable to satisfy the following dependencies...`. For this usage of the OpenWrt firmware, it is strongly recommended that you directly integrate the required packages into the OpenWrt firmware during compilation.

- Non-official plugins of openwrt.org, such as `luci-app-uugamebooster`, `luci-app-xlnetacc`, etc., need to be directly integrated and compiled during firmware compilation. These packages cannot be installed directly from the mirror server using opkg, but you can manually upload these packages to OpenWrt and install them using opkg.

- On the trunk/snapshot, kernel and kmod packages are marked as reserved, and the `opkg upgrade` command will not attempt to update them.

Common commands:

```shell
opkg update                                       # Update the list of available packages
opkg upgrade <pkgs>                               # Upgrade packages
opkg install <pkgs>                               # Install packages
opkg install --force-reinstall <pkgs>             # Force reinstallation of packages
opkg configure <pkgs>                             # Configure unpacked packages
opkg remove <pkgs | regexp>                       # Remove packages
opkg list                                         # List available packages
opkg list-installed                               # List installed packages
opkg list-upgradable                              # List installed and upgradable packages
opkg list | grep <pkgs>                           # Find packages matching keyword
```

For more help, please refer to [opkg](https://openwrt.org/docs/guide-user/additional-software/opkg).

### 10.7 Managing Packages Using the Web Interface

After installing OpenWrt firmware on a device, you can use the WebUI to install other software packages.

1. Log in to OpenWrt → `System` → `Software`.
2. Click the `Update lists` button to update.
3. Fill in the `Filter` field and click the `Find package` button to search for specific software packages.
4. Switch to the `Available packages` tab to display available software packages that can be installed.
5. Switch to the `Installed packages` tab to display and remove installed packages.

If you want to use LuCI to configure services, search for and install `luci-app-*` packages.

For more help, please refer to [packages](https://openwrt.org/packages/start).

### 10.8 How to Restore the Original Android TV System

Generally, openwrt-ddbr backup and restore or the Amlogic flashing tool can be used to restore the original Android TV system.

#### 10.8.1 Using openwrt-ddbr Backup and Restore

Before installing the OpenWrt system on a new box, it is recommended that you back up the original Android TV system that comes with the current box so that you can use it when you need to restore the system. Boot the OpenWrt system from `TF/SD/USB`, enter the `openwrt-ddbr` command, and then follow the prompts to enter `b` to back up the system. The backup file is stored in `/ddbr/BACKUP-arm-64-emmc.img.gz`, please download and save it. When you need to restore the Android TV system, upload the previously backed up file to the same path of the `TF/SD/USB` device, enter the `openwrt-ddbr` command, and then follow the prompts to enter `r` for system restoration.

#### 10.8.2 Using Amlogic Flashing Tool to Restore

- Generally, if you re-insert the power supply and can boot from USB, just reinstall it. Try several times.

- If the screen is black and cannot boot from USB after connecting to the display, you need to short-circuit the box for initialization. First, restore the box to the original Android system and then re-flash the OpenWrt system. First, download the [amlogic_usb_burning_tool](https://github.com/ophub/kernel/releases/tag/tools) system recovery tool and install it. Prepare a [USB dual male head data cable](https://user-images.githubusercontent.com/68696949/159267576-74ad69a5-b6fc-489d-b1a6-0f8f8ff28634.png) and a [paperclip](https://user-images.githubusercontent.com/68696949/159267790-38cf4681-6827-4cb6-86b2-19c7f1943342.png).

- Taking x96max+ as an example, confirm the position of the [short circuit point](https://user-images.githubusercontent.com/68696949/110590933-67785300-81b3-11eb-9860-986ef35dca7d.jpg) on the mainboard of the box, and download the [Android TV firmware package](https://github.com/ophub/kernel/releases/tag/tools) for the box. The schematic diagram of the short-circuit point for the Android TV system firmware of other common devices and its corresponding download can also be viewed and downloaded from here.

```shell
Operation:

1. Open the flashing software USB Burning Tool:
   [ Files → Import firmware package]: X96Max_Plus2_20191213-1457_ATV9_davietPDA_v1.5.img
   [ Select]: Erase flash
   [ Select]: Erase bootloader
   Click the [Start] button.
2. Use a [paperclip] to [short-circuit the two short-circuit points] on the mainboard of the box
   and at the same time use a [USB dual male head data cable] to connect the [box] to the [computer].
3. When you see the [progress bar start to move], remove the paper clip and no longer short-circuit it.
4. When you see the [progress bar 100%], the flashing is complete, and the box has been restored to the Android TV system.
   Click the [Stop] button, unplug the [USB dual male head data cable] between the [box] and the [computer].
5. If any of the above steps fail, do it again until successful.
   If the progress bar does not move, try plugging in the power supply. In general, power supply support is not required, only USB dual male head power supply can meet the flashing requirements.
```

When the factory settings are restored, the box has been restored to the Android TV system, and other operations for installing the OpenWrt system are the same as the requirements when you first installed the system. Just go through the process again.

### 10.9 Unable to Boot After Installing Mainline u-boot

- A few devices may fail to boot after installing the mainline `u-boot`, and you may see a section of code ending with the `=>` symbol in the display. In this case, you need to solder a 5-10 K pull-up or pull-down resistor on the TTL interface to solve the problem that the box is easily affected by surrounding electromagnetic signals and cannot be started, and then you can start from EMMC.

If you choose to install the mainline `u-boot` and cannot boot, please connect the box to the screen to see if you get the following prompt:

```shell
Net: eth0: ethernet0ff3f0000
Hit any key to stop autoboot: 0
=>
```

If your phenomenon is as shown above, then you need to solder a resistor on the TTL interface: [X96 Max Plus's V4.0 motherboard diagram](https://user-images.githubusercontent.com/68696949/110910162-ec967000-834b-11eb-8fa6-64727ccbe4af.jpg).

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

### 10.10 Setting the Box to Boot from USB/TF/SD

- Insert the USB/TF/SD card with the firmware into the box.
- Enable Developer Options: go to Settings → About Device → Version (such as X96max plus...), quickly click the left mouse button five times on the version number, and you will see a prompt "Developer mode enabled".
- Enable USB Debugging: go to System → Advanced Options → Developer Options (set "Enable USB debugging" to enabled) and enable ADB debugging.
- Install ADB Tools: download [adb](https://github.com/ophub/kernel/releases/tag/tools) and extract it. Copy the three files `adb.exe`, `AdbWinApi.dll`, and `AdbWinUsbApi.dll` to the `system32` and `syswow64` folders under `c://windows/`. Then open the `cmd` command panel and use the `adb --version` command. If something is displayed, it means you can use it.
- Enter the `cmd` command mode. Enter the command `adb connect 192.168.1.137` (replace the IP address with your box's IP address, which can be found in the router device that the box is connected to). If the connection is successful, it will display "connected to 192.168.1.137:5555".
- Enter the command `adb shell reboot update`. The box will restart and boot from the USB/TF/SD inserted. Access the firmware's IP address from the browser or SSH to enter the firmware.
- Log in to OpenWrt: Connect your box directly to your computer → Disable Wi-Fi on your computer and only use wired Ethernet → Set the network settings of the wired Ethernet to the same subnet as OpenWrt. If the default IP of OpenWrt is `192.168.1.1`, you can set the IP of your computer to `192.168.1.2` and the subnet mask to `255.255.255.0`. You do not need to set any other options. Then you can enter OpenWrt from the browser, with the default IP being `192.168.1.1`, default username: `root`, and default password: `password`.

### 10.11 OpenWrt Required Options

This list is based on the development guidelines of [unifreq](https://github.com/unifreq/openwrt_packit). To ensure that installation/update scripts can run smoothly in OpenWrt, the following required options need to be added when configuring with `make menuconfig`:

```shell
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


Network -> WirelessAPD -> hostapd-common
                       -> wpa-cli
                       -> wpad-basic
        -> iw


Utilities -> Compression -> bsdtar、pigz
          -> Disc -> blkid、fdisk、lsblk、parted
          -> Filesystem -> attr、btrfs-progs(Build with zstd support)、chattr、dosfstools、
                           e2fsprogs、f2fs-tools、f2fsck、lsattr、mkf2fs、xfs-fsck、xfs-mkfs
          -> Shells -> bash
          -> acpid、coremark、coreutils(-> coreutils-base64、coreutils-nohup)、gawk、getopt、
             jq、losetup、pv、tar、uuidgen
```

