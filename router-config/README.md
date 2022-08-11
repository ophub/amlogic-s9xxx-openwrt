# How to make and use OpenWrt

View Chinese description  |  [查看中文说明](README.cn.md)

How to use GitHub Actions cloud to compile OpenWrt, and many of the content in this documentation, from P3TERX, Flippy and many other technology innovators and resource sharers. Because of the dedication of everyone, let us use OpenWrt in Amlogic s9xxx TV Boxes So Easy.

`GitHub Actions` is a service launched by `Microsoft`. It provides a virtual server environment with very good performance configuration. Based on it, projects can be built, tested, packaged, and deployed. The public repository can be used for free without time limit, and the single compilation time is up to `6 hours`, which is enough for `compiling OpenWrt` (we can usually complete a compilation in about `3 hours`). Sharing is only for the exchange of experience. Please understand the deficiencies. Please do not initiate various bad attacks on the Internet, and do not maliciously use it.

# Tutorial directory

- [How to make and use OpenWrt](#how-to-make-and-use-openwrt)
- [Tutorial directory](#tutorial-directory)
  - [1. Register your own GitHub account](#1-register-your-own-github-account)
  - [2. Set the privacy variable GitHub_TOKEN](#2-set-the-privacy-variable-github_token)
  - [3. Fork repository and set GH_TOKEN](#3-fork-repository-and-set-gh_token)
  - [4. Personalized OpenWrt firmware customization file description](#4-personalized-openwrt-firmware-customization-file-description)
    - [4.1 .config file description](#41-config-file-description)
      - [4.1.1 Let the firmware support the native language](#411-let-the-firmware-support-the-native-language)
      - [4.1.2 Select the personalized software package](#412-select-the-personalized-software-package)
    - [4.2 DIY script operation: diy-part1.sh and diy-part2.sh](#42-diy-script-operation-diy-part1sh-and-diy-part2sh)
      - [Example 1, Add a third-party software package](#example-1-add-a-third-party-software-package)
      - [Example 2: Replace the existing software package](#example-2-replace-the-existing-software-package)
      - [Example 3: Modifying the code in the source code library](#example-3-modifying-the-code-in-the-source-code-library)
    - [4.3 Make firmware with Image Builder](#43-make-firmware-with-image-builder)
  - [5. Compile the firmware](#5-compile-the-firmware)
    - [5.1 Manual compilation](#51-manual-compilation)
    - [5.2 Compile at the agreed time](#52-compile-at-the-agreed-time)
  - [6. Save the firmware](#6-save-the-firmware)
    - [6.1 Save to GitHub Actions](#61-save-to-github-actions)
    - [6.2 Save to GitHub Releases](#62-save-to-github-releases)
    - [6.3 Save to a third party](#63-save-to-a-third-party)
  - [7. Download the firmware](#7-download-the-firmware)
    - [7.1 Download from GitHub Actions](#71-download-from-github-actions)
    - [7.2 Download from GitHub Releases](#72-download-from-github-releases)
    - [7.3 Download from third parties](#73-download-from-third-parties)
  - [8. Install the firmware](#8-install-the-firmware)
    - [8.1 Method of integrating luci-app-amlogic at compile time](#81-method-of-integrating-luci-app-amlogic-at-compile-time)
    - [8.2 Install using the operation panel](#82-install-using-the-operation-panel)
    - [8.3 Install using script commands](#83-install-using-script-commands)
  - [9. Update firmware](#9-update-firmware)
    - [9.1 Update using the operation panel](#91-update-using-the-operation-panel)
    - [9.2 Update using script commands](#92-update-using-script-commands)
    - [9.3 Replace the kernel to update](#93-replace-the-kernel-to-update)
  - [10. Personalized firmware customization update tutorial](#10-personalized-firmware-customization-update-tutorial)
    - [10.1 Know the complete .config file](#101-know-the-complete-config-file)
    - [10.2 Know the workflow file](#102-know-the-workflow-file)
      - [10.2.1 Replacing source code repositories and branches](#1021-replacing-source-code-repositories-and-branches)
      - [10.2.2 Change TV Boxes model and kernel version](#1022-change-tv-boxes-model-and-kernel-version)
    - [10.3 Custom banner information](#103-custom-banner-information)
    - [10.4 Custom feeds configuration file](#104-custom-feeds-configuration-file)
    - [10.5 Custom software default configuration information](#105-custom-software-default-configuration-information)
    - [10.6 Opkg Package Manager](#106-opkg-package-manager)
    - [10.7 Manage packages using web interface](#107-manage-packages-using-web-interface)
    - [10.8 How to restore the original Android TV system](#108-how-to-restore-the-original-android-tv-system)
      - [10.8.1 Restoring using openwrt-ddbr backup](#1081-restoring-using-openwrt-ddbr-backup)
      - [10.8.2 Restoring with Amlogic usb burning tool](#1082-restoring-with-amlogic-usb-burning-tool)
    - [10.9 If you can’t startup after using the Mainline u-boot](#109-if-you-cant-startup-after-using-the-mainline-u-boot)
    - [10.10 Set the box to boot from USB/TF/SD](#1010-set-the-box-to-boot-from-usbtfsd)
    - [10.11 Required options for OpenWrt](#1011-required-options-for-openwrt)

## 1. Register your own GitHub account

Register your own account, so that you can continue to customize the firmware. Click the `Sign up` button in the upper right corner of the `github.com` website and follow the prompts to `register your account`.

## 2. Set the privacy variable GitHub_TOKEN

Set the GitHub privacy variable `GitHub_TOKEN`. After the firmware is compiled, we need to upload the firmware to `GitHub Releases`. We set this variable according to the official requirements of GitHub. The method is as follows:
`Personal center`: `Settings` > `Developer settings` > `Personal access tokens` > `Generate new token` ( Name: `GitHub_TOKEN`, Select: `public_repo` ). `Other options` can be selected according to your needs. Submit and save, copy the `Encrypted KEY Value` generated by the system, and `save it` to your computer's notepad first. This value will be used in the next step. The icons are as follows:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418474-85032b00-7a03-11eb-85a2-759b0320cc2a.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418479-8b91a280-7a03-11eb-8383-9d970f4fffb6.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418483-90565680-7a03-11eb-8320-0df1174b0267.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418493-9815fb00-7a03-11eb-862e-deca4a976374.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418485-93514700-7a03-11eb-848d-36de784a4438.jpg width="300" />
</div>

## 3. Fork repository and set GH_TOKEN

Now you can `Fork` the `repository`, open the repository [https://github.com/ophub/amlogic-s9xxx-openwrt](https://github.com/ophub/amlogic-s9xxx-openwrt), click the `Fork` button on the `upper right`, Will copy a copy of the repository code to your account, `wait a few seconds`, and prompt the Fork to complete Later, go to your account to access `amlogic-s9xxx-armbian` in `your repository`. In the upper right corner of `Settings` > `Secrets` > `Actions` > `New repostiory secret` (Name: `GH_TOKEN`, Value: `Fill in the value of GitHub_TOKEN` just now), `save it`. And select `Read and write permissions` under `Actions` > `General` > `Workflow permissions` in the left nav and save. The icons are as follows:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418568-0eb2f880-7a04-11eb-81c9-194e32382998.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/163203032-f044c63f-d113-4076-bf94-41f86c7dd0ce.png width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418573-15417000-7a04-11eb-97a7-93973d7479c2.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/167579714-fdb331f3-5198-406f-b850-13da0024b245.png width="300" />
<img src=https://user-images.githubusercontent.com/68696949/167585338-841d3b05-8d98-4d73-ba72-475aad4a95a9.png width="300" />
</div>

## 4. Personalized OpenWrt firmware customization file description

After the previous 3 steps of preparation, let's start personalized firmware customization now. Have some files in the [router-config/lede-master](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/router-config/lede-master) directory. Except for the description files, the other three are files for customizing OpenWrt firmware. In this chapter, we only make the simplest instructions, so that you can experience the happiness of personalized customization with your hands. I put more complex customization operations in `Section 10`, which requires you to have a little foundation.

### 4.1 .config file description

The `.config` file is the core file for personalized customization of the OpenWrt software package. It contains all the configuration information. Each line of code in the file represents a personalized configuration option. Although there are many projects, management is very simple. Let's get started.

#### 4.1.1 Let the firmware support the native language

in `# National language packs, luci-i18n-base:` Take France as an example, if you enable French language support, just put

```yaml
# CONFIG_PACKAGE_luci-i18n-base-fr is not set
```

change into

```yaml
CONFIG_PACKAGE_luci-i18n-base-fr=y
```

All the personalized customization in the `.config` file can be done in this way. For items you don't need, fill in `#` at the beginning of the line, and change `=y` to `is not set` at the end of the line. For the items you need, remove the `#` at the beginning of the line and change `is not set` to `=y` at the end

#### 4.1.2 Select the personalized software package

in `#LuCI-app:` The practice of enabling and deleting the default software package is the same as above. This time we delete the `luci-app-zerotier` plug-in in the default software package, just put

```yaml
CONFIG_PACKAGE_luci-app-zerotier=y
```
change into

```yaml
# CONFIG_PACKAGE_luci-app-zerotier is not set
```

I think you already know how to personalize the configuration. Each line of the `.config` file represents a configuration item. You can use this method to enable or delete the default configuration in the firmware. The complete content of this file has several thousand lines, I provide This is only a simplified version. How to obtain a complete configuration file for more complex and personalized customization is introduced in `Section 10`.

### 4.2 DIY script operation: diy-part1.sh and diy-part2.sh

The scripts `diy-part1.sh` and `diy-part2.sh` are executed `before and after` the `update and installation` of `feeds` respectively. When we introduce the OpenWrt source code library for personalized firmware compilation, sometimes we want to rewrite part of the code in the source code library, or add Some third-party software packages, delete or replace some software packages in the source code library, such as `modifying the default IP, host name, theme, adding/deleting software packages`, etc., these `modification instructions` to the source code library can be written to these two Script. Let's take the `OpenWrt` source code library provided by `coolsnowwolf` as the compilation object, to give a few examples.

Our following operations are based on this source code library: [https://github.com/coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)

#### Example 1, Add a third-party software package

The first step is to add the following code to `diy-part2.sh`:

```yaml
git clone https://github.com/jerrykuku/luci-app-ttnode.git package/lean/luci-app-ttnode
```

The second step is to add the activation code of this third-party software package to the `.config` file

```yaml
CONFIG_PACKAGE_luci-app-ttnode=y
```

This completes the integration of third-party software packages and expands the software packages that are not in the current source code repository.

#### Example 2: Replace the existing software package

Replace the existing software package with the same name in the current source code library with a third-party software package. The first step is to add the following code to `diy-part2.sh`:

First delete the original software package in the source code library, and Introduce a third-party package of the same name.

```yaml
rm -rf package/lean/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon
```

The second step is to add third-party software packages to the `.config` file.

```yaml
CONFIG_PACKAGE_luci-theme-argon=y
```

This realizes the use of a third-party software package to replace the existing software package with the same name in the current source code library.

#### Example 3: Modifying the code in the source code library

To achieve certain requirements by modifying the code in the source code library. We have added `luci-app-cpufreq` support for `aarch64` so that it can be used in our firmware (some modifications need to be cautious, you must know what you are doing).

Source file address: [luci-app-cpufreq/Makefile](https://github.com/coolsnowwolf/lede/blob/master/package/lean/luci-app-cpufreq/Makefile)

```yaml
sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' package/lean/luci-app-cpufreq/Makefile
```

This realizes the modification of the source code.

Through `diy-part1.sh` and `diy-part2.sh` two scripts, we add operation commands to make more powerful functions.

### 4.3 Make firmware with Image Builder

The official website of OpenWrt provides the prepared openwrt-imagebuilder-*-armvirt-64.Linux-x86_64.tar.xz file (download address: [https://downloads.openwrt.org/releases](https://downloads.openwrt.org/releases)), you can use the official Image Builder to add packages and plug-ins to this file, usually Create an openwrt-rootfs.tar.gz file in just a few minutes. For the production method, please refer to the official document: [Using the Image Builder](https://openwrt.org/docs/guide-user/additional-software/imagebuilder)

This repository provides a one-click production service. You only need to pass the branch parameters into the [imagebuilder script](openwrt-imagebuilder/imagebuilder.sh) to complete the production.

- Localized make command: You can run the `sudo ./router-config/openwrt-imagebuilder/imagebuilder.sh 21.02.3` command in the `~/amlogic-s9xxx-openwrt` root directory to generate it. The parameter `21.02.3` is the version number of `releases` currently available for [download](https://downloads.openwrt.org/releases). The generated files are in the `openwrt/bin/targets/armvirt/64` directory.

- Use github.com's `Actions` to make: [Build OpenWrt with Image Builder](../.github/workflows/build-openwrt-with-imagebuilder.yml)

## 5. Compile the firmware

The firmware compilation process is controlled in the [.github/workflows/build-openwrt-with-lede.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt-with-lede.yml) file. There are other `yml files` in the `workflows` directory to achieve other different functions. There are many ways to compile firmware, you can set timed compilation, manual compilation, or set some specific events to trigger compilation. Let's start with simple operations.

### 5.1 Manual compilation

In the `navigation bar of your repository`, click the `Actions` button, and then click `Build OpenWrt` > `Run workflow` > `Run workflow` to start the compilation, wait about `3 hours`, and complete the compilation after all the processes are over. The icons are as follows:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418662-a0226a80-7a04-11eb-97f6-aeb893336e8c.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418663-a31d5b00-7a04-11eb-8d34-57d430696901.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418666-a7497880-7a04-11eb-9ed0-be738e22f7ae.jpg width="300" />
</div>

### 5.2 Compile at the agreed time

In the [.github/workflows/build-openwrt-with-lede.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt-with-lede.yml) file, use `cron` to set the timing compilation. The 5 different positions represent min (0 - 59) / hour (0 - 23) / day of month (1 - 31) / month (1 - 12) / day of week (0 - 6)(Sunday - Saturday). Set the time by modifying the values of different positions. The system uses `UTC standard time` by default, please convert it according to the time zone of your country.

```yaml
schedule:
  - cron: '0 17 * * *'
```

## 6. Save the firmware

The settings saved by the firmware are also controlled in the [.github/workflows/build-openwrt-with-lede.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt-with-lede.yml) file. We will automatically upload the compiled firmware to the `Actions` and `Releases` officially provided by `GitHub` through scripts, or upload it to a `third party` (such as WeTransfer).

Now the longest storage period of `Actions in GitHub is 90 days`, `Releases is permanent`, and third parties such as WeTransfer are 7 days. First of all, we thank these service providers for their free support, but we also ask you to use it sparingly. We advocate the reasonable use of free services.

### 6.1 Save to GitHub Actions

```yaml
- name: Upload artifact to Actions
  uses: kittaakos/upload-artifact-as-is@master
  if: steps.build.outputs.status == 'success' && env.UPLOAD_FIRMWARE == 'true' && !cancelled()
  with:
    path: ${{ env.FILEPATH }}/
```

### 6.2 Save to GitHub Releases

```yaml
- name: Upload OpenWrt Firmware to Release
  uses: ncipollo/release-action@main
  if: env.PACKAGED_STATUS == 'success' && !cancelled()
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
### 6.3 Save to a third party

```yaml
- name: Upload OpenWrt Firmware to WeTransfer
  if: steps.build.outputs.status == 'success' && env.UPLOAD_WETRANSFER == 'true' && !cancelled()
  run: |
    curl -fsSL git.io/file-transfer | sh
    ./transfer wet -s -p 16 --no-progress ${{ env.FILEPATH }}/{openwrt_s9xxx_*,openwrt_n1_*} 2>&1 | tee wetransfer.log
    echo "WET_URL=$(cat wetransfer.log | grep https | cut -f3 -d" ")" >> $GITHUB_ENV
```

## 7. Download the firmware

Download our compiled openwrt firmware.

### 7.1 Download from GitHub Actions

Click the `Actions` button in the `repository navigation bar`. In the `All workflows` list, click the compiled firmware list. In the firmware list inside, select the firmware corresponding to the model of your `Amlogic s9xxx TV Boxes`. The icons are as follows:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418782-08714c00-7a05-11eb-9556-91575640a4bb.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418785-0ad3a600-7a05-11eb-9fdd-519835a14eaa.jpg width="300" />
</div>

### 7.2 Download from GitHub Releases

Enter from the GitHub `Releases` section at the bottom right corner of the `repository homepage`, and select the firmware corresponding to the model of your `Amlogic s9xxx TV Boxes`. The icons are as follows:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418828-466e7000-7a05-11eb-8f69-a89a1d158a4b.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418841-55edb900-7a05-11eb-9650-7100ebd6042c.jpg width="300" />
</div>

### 7.3 Download from third parties

In the [.github/workflows/build-openwrt-with-lede.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt-with-lede.yml) file, upload to the third party is closed by default. If you need, change `false` to `true`, and upload to the third party when the compilation is completed next time. The third-party URL can be seen `in the log` of the firmware compilation process, and can also be output to the compilation information.

```yaml
UPLOAD_COWTRANSFER: false
UPLOAD_WETRANSFER: false
```

The support for uploading to a third party comes from [Mikubill/transfer](https://github.com/Mikubill/transfer). If you need it, you can add more third-party support according to his instructions (control your creativity and don't waste too many free resources). The icons are as follows:

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418921-b5e45f80-7a05-11eb-80ba-02edb0698270.jpg width="300" />
</div>

## 8. Install the firmware

### 8.1 Method of integrating luci-app-amlogic at compile time

1. `svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic`
2. Execute make `menuconfig` and select `luci-app-amlogic` under `LuCI ---> 3. Applications  ---> <*> luci-app-amlogic`

For more instructions on the plug-in, see：[https://github.com/ophub/luci-app-amlogic](https://github.com/ophub/luci-app-amlogic)

Choose the corresponding firmware according to your box. Then write the IMG file to the USB hard disk through software such as [Rufus](https://rufus.ie/) or [balenaEtcher](https://www.balena.io/etcher/). Insert the USB hard disk into the box.

### 8.2 Install using the operation panel

`Log in to the default IP: 192.168.1.1` → `Login in to openwrt` → `system menu` → `Amlogic Service` → `Install OpenWrt`

### 8.3 Install using script commands

`Log in to the default IP: 192.168.1.1` → `Login in to openwrt` → `system menu` → `TTYD terminal` → input command:

```yaml
openwrt-install-amlogic
```

The same type of TV Boxes, the firmware is common, such as `openwrt_s905x3_v*.img` firmware can be used for `x96max plus, hk1, h96` and other `s905x3` type TV Boxes. When the installation script writes OpenWrt to EMMC, you will be prompted to choose your own box, please choose the correct one according to the prompt.

In addition to the default 13 models of TV Boxes are automatically installed, when you select 0 for optional .dtb file installation, you need to fill in the specific .dtb file name, you can check the exact file name from here and fill in it, see [amlogic-dtb](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian/common-files/patches/amlogic-dtb)

## 9. Update firmware

### 9.1 Update using the operation panel

`Log in to your OpenWrt system`, under the `System` menu, select the `Amlogic Service`, select the `Update OpenWrt` to update. (You can update from a higher version such as 5.15.50 to a lower version such as 5.10.125, or from a lower version such as 5.10.125 to a higher version such as 5.15.50. The kernel version number does not affect the update, and `you can freely update/downgrade`.)

### 9.2 Update using script commands

`Log in to your OpenWrt system` →  under the `System` menu → `Amlogic Service` → upload ***`openwrt*.img.gz (Support suffix: *.img.xz, *.img.gz, *.7z, *.zip)`*** to ***`/mnt/mmcblk*p4/`***, enter the `system menu` → `TTYD terminal` → input command:

```yaml
openwrt-update-amlogic
```
💡Tips: You can also put the `update file` in the `/mnt/mmcblk*p4/` directory, the `openwrt-update-amlogic` script will automatically find the `update file` from the `/mnt/mmcblk*p4/` directories.

If there is only one `update file` in the ***`/mnt/mmcblk*p4/`*** directory, you can just enter the ***`openwrt-update-amlogic`*** command without specifying a specific `update file`. The `openwrt-update-amlogic` script will vaguely look for `update file` from this directory and try to update. If there are multiple `update file` in the `/mnt/mmcblk*p4/` directory, please use the ***`openwrt-update-amlogic openwrt_s905x3_v5.10.125_2021.03.17.0412.img.gz`*** command to specify the `update file`.

- The `openwrt-update-amlogic` update file search order

| Directory | `/mnt/mmcblk*p4/` 1-6 |
| ---- | ---- |
| Oeder | `specified_update_file` → `*.img` → `*.img.xz` → `*.img.gz` → `*.7z` → `*.zip` → |


### 9.3 Replace the kernel to update

- Log in to the default IP: 192.168.1.1 →  `Login in to openwrt` → `system menu` → `Amlogic Service` → Upload kernel package ***`(There are 3 files：boot-*，dtb-amlogic-*，modules-*)`*** to ***`/mnt/mmcblk*p4/`***, enter the `system menu` → `TTYD terminal` → input the Kernel replacement command: 

```yaml
openwrt-kernel
```

💡Tips: You can also put the `kernel files` in the `/mnt/mmcblk*p4/` directory, the `openwrt-kernel` script will automatically find the `kernel file` from the `/mnt/mmcblk*p4/` directories.

Replacing the OpenWrt kernel is only a kernel replacement, and the various personalized configurations of the firmware remain unchanged. It is the easiest way to update. Support replacement of kernel high/low version.

## 10. Personalized firmware customization update tutorial

If you see this step in the tutorial, I believe you already know how to play happily. If you don’t continue to read what is said later, I believe you will not be at ease. But, but ah, if you continue to explore in depth, you will start an extraordinary journey of tossing. You will encounter a lot of problems. This requires you to be prepared for continuous exploration, and you must be good at using `search engines` to solve problems. The time can go to various `OpenWrt communities` to learn.

### 10.1 Know the complete .config file

Use the official source code library of `OpenWrt` or the source code library of other branches to perform a `localized compilation`. For example, select the source code library of [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede), and install the `Ubuntu system` locally and deploy the environment according to its compilation instructions. And `complete a local compilation`. In the local compilation configuration interface, you can also see a lot of rich instructions, which will strengthen your understanding of the OpenWrt compilation process.

After you complete the `OpenWrt personalized configuration` locally, `save and exit` the configuration interface. You can find the `.config` file in the root directory of the local OpenWrt source code library. You can upload this file directly to `your repository on github.com`, Replace the `router-config/lede-master/.config` file.

### 10.2 Know the workflow file

The official GitHub gave a detailed explanation. Regarding the use of `GitHub Actions`, you can start to get to know it from here: [Quickstart for GitHub Actions](https://docs.github.com/en/Actions/quickstart)

Let’s make a few brief introductions based on the files being used in the repository: [build-openwrt-with-lede.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt-with-lede.yml)

#### 10.2.1 Replacing source code repositories and branches

```yaml
#On Line 63: Source code library address
REPO_URL: https://github.com/coolsnowwolf/lede

#On Line 64: Branch name
REPO_BRANCH: master
```
You can modify it to other, such as official:
```yaml
REPO_URL: https://github.com/openwrt/openwrt
REPO_BRANCH: openwrt-21.02
```

#### 10.2.2 Change TV Boxes model and kernel version

Near line 139, find `Build OpenWrt firmware`, Code snippet like this:
```yaml
- name: Build OpenWrt firmware
  if: steps.compile.outputs.status == 'success' && !cancelled()
  uses: ophub/amlogic-s9xxx-openwrt@main
  with:
    openwrt_path: openwrt/bin/targets/*/*/*rootfs.tar.gz
    openwrt_soc: ${{ github.event.inputs.openwrt_soc }}
    openwrt_kernel: ${{ github.event.inputs.openwrt_kernel }}
    auto_kernel: ${{ github.event.inputs.auto_kernel }}
    openwrt_size: ${{ github.event.inputs.openwrt_size }}
```
Refer to the related [parameter description](https://github.com/ophub/amlogic-s9xxx-openwrt#github-actions-input-parameter-description) of the packaging command. The above setting options can be set by writing fixed values, or they can be selected through the `Actions` panel:
<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/181870674-1816aa21-ece4-4149-83ce-6ec7f95ece68.png width="700" />
</div>

### 10.3 Custom banner information

The default [/etc/banner](../amlogic-s9xxx/common-files/rootfs/etc/banner) information is as follows, you can use the [banner generator](https://www.bootschool.net/ascii) Customize your own personalized banner information(The style below is `slant`), just overwrite the file with the same name.

```yaml
     ___              __      ____                 _       __     __
    /   |  ____ ___  / /     / __ \____  ___  ____| |     / /____/ /_
   / /| | / __ `__ \/ /_____/ / / / __ \/ _ \/ __ \ | /| / / ___/ __/
  / ___ |/ / / / / / /_____/ /_/ / /_/ /  __/ / / / |/ |/ / /  / /_
 /_/  |_/_/ /_/ /_/_/      \____/ .___/\___/_/ /_/|__/|__/_/   \__/
 A M L O G I C - S E R V I C E /_/ W I R E L E S S - F R E E D O M
───────────────────────────────────────────────────────────────────────
```

### 10.4 Custom feeds configuration file

When you look at the `feeds.conf.default` file in the `source code repository`, do you find that there are a lot of package libraries introduced here? You understand that right, we can find the source code library officially provided by OpenWrt on GitHub, as well as the branches of OpenWrt shared by many people. If you know them, you can add them from here. For example, [feeds.conf.default](https://github.com/coolsnowwolf/lede/blob/master/feeds.conf.default) in the `coolsnowwolf` source code library.

### 10.5 Custom software default configuration information

When we use `OpenWrt`, we have already configured many software. Most of the `configuration information` of these software is stored in your OpenWrt's `/etc/config/` and other related directories. Copy the storage files of these configuration information to In the `files` folder under the root directory of the `repository in GitHub`, please `keep the directory structure and files the same`. During OpenWrt compilation, the storage files of these configuration information will be compiled into your firmware. The specific method is in the [.github/workflows/build-openwrt-with-lede.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt-with-lede.yml) file. Let's take a look at this code together:

```yaml
- name: Load custom configuration
  run: |
    [[ -d "files" ]] && mv -f files openwrt/files
    [[ -e "${CONFIG_FILE}" ]] && cp -f ${CONFIG_FILE} openwrt/.config
    chmod +x ${DIY_P2_SH}
    cd openwrt
    ${GITHUB_WORKSPACE}/${DIY_P2_SH}
```

Please do not copy the configuration information files that `involve privacy`. If `your repository is public`, then the files you put in the `files` directory are also `public`. Do not disclose the secrets. Some passwords and other information can be used using the `private key settings` you just learned in [Quickstart for GitHub Actions](https://docs.github.com/en/Actions/quickstart). You must understand what you are doing.

### 10.6 Opkg Package Manager

Like most Linux distributions (or mobile device operating systems like say Android or iOS), the functionality of the system can be upgraded rather significantly by downloading and installing pre-made packages from package repositories (local or on the Internet).

The opkg utility is the lightweight package manager used for this job. which is designed to add software to stock firmware of embedded devices. Opkg is a full package manager for the root file system, including kernel modules and drivers.

The package manager opkg attempts to resolve dependencies with packages in the repositories - if this fails, it will report an error and abort the installation of that package.

Missing dependencies with third-party packages are probably available from the source of the package.
To ignore dependency errors, pass the `--force-depends` flag.

- If you are using a snapshot / trunk / bleeding edge version, installing packages may fail if the package in the repository is for a newer kernel version than the kernel version you have.
In this case, you will get the error message “Cannot satisfy the following dependencies for…”.
For such usage of OpenWrt firmware, **`it's warmly recommended to use the Image Builder to make a flashable image containing all packages you need`**.

- Non-openwrt.org official plug-ins, such as `luci-app-uugamebooster`, `luci-app-xlnetacc`, etc., need to be personalized during firmware compilation. These packages cannot be directly installed from the mirror server using opkg, But you can manually `upload to openwrt and use opkg to install`.

- When on trunk/snapshot, kernel and kmod packages are flagged as hold, the `opkg upgrade` command won't attempt to update them.

Common commands:
```
opkg update                                   #Update list of available packages
opkg upgrade <pkgs>                           #Upgrade packages
opkg install <pkgs>                           #Install package(s)
opkg install --force-reinstall <pkgs>         #Force reinstall package(s)
opkg configure <pkgs>                         #Configure unpacked package(s)
opkg remove <pkgs | regexp>                   #Remove package(s)
opkg list                                     #List available packages
opkg list-installed                           #List installed packages
opkg list-upgradable                          #List installed and upgradable packages
opkg list | grep <pkgs>                       #Find similar packages names
```
[For more instructions please see: opkg](https://openwrt.org/docs/guide-user/additional-software/opkg)

### 10.7 Manage packages using web interface

After you have flashed the OpenWrt firmware to your device, you can install additional software packages via WebUI.

1. Navigate to LuCI → System → Software.
2. Click Update lists button to fetch a list of available packages.
3. Fill in Filter field and click Find package button to search for a specific package.
4. Switch to Available packages tab to show and install available packages.
5. Switch to Installed packages tab to show and remove installed packages.

Search and install `luci-app-*` packages if you want to configure services using LuCI.

[For more instructions please see: packages](https://openwrt.org/packages/start)

### 10.8 How to restore the original Android TV system

Usually use openwrt-ddbr backup to restore, or use Amlogic usb burning tool to restore the original Android TV system.

#### 10.8.1 Restoring using openwrt-ddbr backup

It is recommended that you make a backup of the original Android TV system that comes with the current box before installing the OpenWrt system in a new box, so that you can use it when you need to restore the system. Please boot the OpenWrt system from `TF/SD/USB`, enter the `openwrt-ddbr` command, and then enter `b` according to the prompts to backup the system. The backup file is stored in the path `/ddbr/BACKUP-arm-64-emmc. img.gz` , please download and save. When you need to restore the Android TV system, upload the previously backed up files to the same path of the `TF/SD/USB` device, enter the `openwrt-ddbr` command, and then enter `r` according to the prompt to restore the system.

#### 10.8.2 Restoring with Amlogic usb burning tool

- Under normal circumstances, re-insert the USB hard disk and install it again.

- If you cannot start the OpenWrt system from the USB hard disk again, connect the Amlogic s9xxx TV Boxes to the computer monitor. If the screen is completely black and there is nothing, you need to restore the Amlogic s9xxx TV Boxes to factory settings first, and then reinstall it. First download the [amlogic_usb_burning_tool](https://github.com/ophub/kernel/releases/tag/tools) system recovery tool and install it. Prepare a [USB dual male data cable](https://user-images.githubusercontent.com/68696949/159267576-74ad69a5-b6fc-489d-b1a6-0f8f8ff28634.png), Prepare a [paper clip](https://user-images.githubusercontent.com/68696949/159267790-38cf4681-6827-4cb6-86b2-19c7f1943342.png).

- Take x96max+ as an example. Find the two [short-circuit points](https://user-images.githubusercontent.com/68696949/110590933-67785300-81b3-11eb-9860-986ef35dca7d.jpg) on the motherboard, Download the [Android TV firmware](https://github.com/ophub/kernel/releases/tag/tools). The Android TV system firmware of other common devices and the corresponding short circuit diagrams can also be [downloaded and viewed here](https://github.com/ophub/kernel/releases/tag/tools).

```
Operation method:

1. Open the USB Burning Tool:
   [ File → Import image ]: X96Max_Plus2_20191213-1457_ATV9_davietPDA_v1.5.img
   [ Check ]：Erase flash
   [ Check ]：Erase bootloader
   Click the [ Start ] button
2. Use a [ paper clip ] to connect the [ two shorting points ] on the main board of the box,
   and use a [ USB dual male data cable ] to connect the [ box ] to the [ computer ] at the same time.
3. Loosen the short contact after seeing the [ progress bar moving ].
4. After the [ progress bar is 100% ], the restoration of the original Android TV system is completed.
   Click [ stop ], unplug the [ USB male-to-male data cable ] and [ power ].
5. If the progress bar is interrupted, repeat the above steps until it succeeds.
   If the progress bar does not respond after the short-circuit, plug in the [ power ] supply after the short-circuit.
   Generally, there is no need to plug in the power supply.
```

When the factory reset is completed, the box has been restored to the Android TV system, and other operations to install the OpenWrt system are the same as the requirements when you installed the system for the first time before, just do it again.

### 10.9 If you can’t startup after using the Mainline u-boot

- A very small number of devices may fail to boot after choosing to write to the main line `u-boot`. The fault phenomenon is usually the `=>` prompt of u-boot automatically. The reason is that TTL lacks a pull-up resistor or pull-down resistor and is easily interfered by surrounding electromagnetic signals. The solution is to solder a 5K-10K resistor (pull-down) between TTL RX and GND, or solder a resistor between RX and 3.3V. A resistance of 5K-10K (pull-up).

If you choose to use the `mainline u-boot` during installation and it fails to start, please connect the Amlogic S905x3 box to the monitor. If the screen shows the following prompt:
```
Net: eth0: ethernet0ff3f0000
Hit any key to stop autoboot: 0
=>
```

You need to install a resistor on the TTL: [X96 Max Plus's V4.0 Motherboard](https://user-images.githubusercontent.com/68696949/110910162-ec967000-834b-11eb-8fa6-64727ccbe4af.jpg)

```
#######################################################            #####################################################
#                                                     #            #                                                   #
#   Resistor (pull-down): between TTL's RX and GND    #            #   Resistor (pull-up): between TTL's 3.3V and RX   #
#                                                     #            #                                                   #
#            3.3V   RX       TX       GND             #     OR     #        3.3V               RX     TX     GND       #
#                    ┖————█████████————┚              #            #         ┖————█████████————┚                       #
#                      Resistor (5~10K)               #            #           Resistor (5~10K)                        #
#                                                     #            #                                                   #
#######################################################            #####################################################
```

### 10.10 Set the box to boot from USB/TF/SD

- Write the firmware to USB/TF/SD, insert it into the box after writing.
- Open the developer mode: Settings → About this machine → Version number (for example: X96max plus...), click on the version number for 5 times in quick succession, See the prompt of `Enable Developer Mode` displayed by the system.
- Turn on USB debugging: System → Advanced options → Developer options again (after entering, confirm that the status is on, and the `USB debugging` status in the list is also on). Enable `ADB` debugging.
- Install ADB tools: Download [adb](https://github.com/ophub/kernel/releases/tag/tools) and unzip it, copy the three files `adb.exe`, `AdbWinApi.dll`, and `AdbWinUsbApi.dll` to the two files `system32` and `syswow64` under the directory of `c://windows/` Folder, then open the `cmd` command panel, use `adb --version` command, if it is displayed, it is ready to use.
- Enter the `cmd` command mode. Enter the `adb connect 192.168.1.137` command (the ip is modified according to your box, and you can check it in the router device connected to the box), If the link is successful, it will display `connected to 192.168.1.137:5555`
- Enter the `adb shell reboot update` command, the box will restart and boot from the USB/TF/SD you inserted, access the firmware IP address from a browser, or SSH to enter the firmware.
- Log in to the system: Connect the computer and the s9xxx box with a network interface → turn off the wireless wifi on the computer → enable the wired connection → manually set the computer ip to the same network segment ip as openwrt, ipaddr such as `192.168.1.2`. The netmask is `255.255.255.0`, and others are not filled in. You can log in to the openwrt system from the browser, Enter OpwnWrt's IP Address: `192.168.1.1`, Account: `root`, Password: `password`, and then log in OpenWrt system.

### 10.11 Required options for OpenWrt

This list is organized based on the development guide of [unifreq](https://github.com/unifreq/openwrt_packit). In order to ensure that scripts such as installation/update can run normally in OpenWrt, when using `make menuconfig` to configure, you need to add the following mandatory options:

```
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
             losetup、pv、tar、uuidgen
```

