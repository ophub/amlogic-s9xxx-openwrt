# OpenWrt for Amlogic S9xxx STB

Support `github.com One-stop compilation`, `github.com clone packaging`, `Use github.com Releases rootfs file to packaging`, `Local packaging`. including OpenWrt firmware install to EMMC and update related functions. Support Amlogic-s9xxx chip series such as `S905x3`, `S905x2`, `S922x`, `S905x`, `S905d`, `s912`, etc. Support STB are ***`Phicomm-N1, Octopus-Planet, X96-Max+, HK1-Box, H96-Max-X3, Belink GT-King, Belink GT-King Pro, UGOOS AM6 Plus, Fiberhome HG680P, ZTE B860H`***, etc.

The latest version of the OpenWrt firmware can be downloaded in [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases). Some important update instructions can be found in [ChangeLog.md](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/ChangeLog.md) documents.

This OpenWrt firmware is packaged using ***`Flippy's`*** Amlogic S9xxx Kernel for OpenWrt, and the Install and update scripts, etc. Welcome to use `Forks` for [personalized OpenWrt firmware configuration](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/router_config/Documentation.md). If you like it, Please click the `Star`.

## OpenWrt Firmware instructions

| Model  | STB | OpenWrt Firmware |
| ---- | ---- | ---- |
| s905x3 | [x96](https://tokopedia.link/uMaH09s41db), [hk1](https://tokopedia.link/pNHf5AE41db), [h96](https://tokopedia.link/wRh6SVI41db) | openwrt_s905x3_v*.img |
| s905x2 | [x96max4g](https://tokopedia.link/HcfLaRzjqeb), [x96max2g](https://tokopedia.link/ro207Hsjqeb) | openwrt_s905x2_v*.img |
| s905x | [hg680p](https://tokopedia.link/NWF1Skg21db), [b860h](https://tokopedia.link/fp8wG3711db) | openwrt_s905x_v*.img |
| s922x | [belink](https://tokopedia.link/RAgZmOM41db), [belinkpro](https://tokopedia.link/sfTHlfS41db), [ugoos](https://tokopedia.link/pHGKXuV41db) | openwrt_s922x_v*.img |
| s912 | octopus | openwrt_s912_v*.img |
| s905d | n1 | openwrt_s905d_v*.img |

## Install to EMMC partition and update instructions

Choose the corresponding firmware according to your STB. Then write the IMG file to the USB hard disk through software such as [balenaEtcher](https://www.balena.io/etcher/). Insert the USB hard disk into the Amlogic s9xxx STB. Common for all `Amlogic s9xxx STB`.

***`Install OpenWrt`***

- Log in to the default IP: 192.168.1.1 → `Login in to openwrt` → `system menu` → `TTYD terminal` → input command: 

```yaml
openwrt-install
```
***`Update OpenWrt`***

- Log in to the default IP: 192.168.1.1 →  `Login in to openwrt` → `system menu` → `file transfer` → upload ***`openwrt*.img.gz (Support suffix: *.img.xz, *.img.gz, *.7z, *.zip)`*** to ***`/tmp/upload/`***, enter the `system menu` → `TTYD terminal` → input command: 

```yaml
openwrt-update
```

[For more instructions please see: install-program](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/install-program)

## Compilation and packaging method

Provide multiple ways to generate the OpenWrt firmware you need. Please choose one method you like. Each method can be used independently.

- ### Github.com One-stop compilation instructions

You can modify the configuration file in the `router_config` directory and `.yml` file, customize the OpenWrt firmware, and complete the packaging online through `Actions`, and complete all the compilation of OpenWrt firmware in github.com One-stop.

1. Personalized plug-in configuration in [router_config](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/router_config) directory. Workflows configuration in [.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt.yml) file.
2. Select ***`Build OpenWrt`*** on the [Action](https://github.com/ophub/amlogic-s9xxx-openwrt/actions) page. Click the ***`Run workflow`*** button.

- ### Github.com clone packaging instructions

[For more instructions please see: .yml example](https://github.com/ophub/op/blob/main/.github/workflows/build-openwrt-s9xxx.yml)

In your .github/workflows/.yml file, after completing the compilation of Subtarget is ARMv8, add the following online packaging code:

```yaml
- name: Build OpenWrt for Amlogic S9xxx STB
  id: build
  run: |
    git clone --depth 1 https://github.com/ophub/amlogic-s9xxx-openwrt.git
    cd amlogic-s9xxx-openwrt/
    [ -d openwrt-armvirt ] || mkdir -p openwrt-armvirt
    cp -f ../openwrt/bin/targets/*/*/*.tar.gz openwrt-armvirt/ && sync
    sudo rm -rf ../openwrt && sync
    sudo rm -rf /workdir && sync
    sudo chmod +x make
    sudo ./make -d -b s905x3_s905x2_s905x_s905d_s922x_s912 -k 5.9.14_5.4.83
    cd out/ && sudo gzip *.img
    cp -f ../openwrt-armvirt/*.tar.gz . && sync
    echo "FILEPATH=$PWD" >> $GITHUB_ENV
    echo "::set-output name=status::success"
```

- Uploads OpenWrt Firmware to Actions:
 
```yaml
- name: Upload artifact to Actions
  uses: kittaakos/upload-artifact-as-is@master
  with:
    path: ${{ env.FILEPATH }}/
```

- Uploads OpenWrt Firmware to Release:

```yaml
- name: Upload OpenWrt Firmware to Release
  uses: softprops/action-gh-release@v1
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  with:
    tag_name: openwrt_s9xxx
    files: ${{ env.FILEPATH }}/*
    body: |
      This is OpenWrt firmware for Amlogic S9xxx STB.
      More information ...
```

- ### Use github.com Releases rootfs file to packaging

If there is an `openwrt-armvirt-64-default-rootfs.tar.gz` file in a [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases) in your repository, you can use this file to directly package the required firmware.

- `openwrt_s9xxx_.*` is Prefix the `tag_name` in the Release.
- `openwrt-armvirt-64-default-rootfs.tar.gz` is the firmware you are going to package, please refer to [router_config](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/router_config) for compilation method.

[For more instructions please see: use-releases-file-to-packaging.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/use-releases-file-to-packaging.yml)

```yaml
- name: Build OpenWrt firmware
  id: build
  run: |
    [ -d openwrt-armvirt ] || mkdir -p openwrt-armvirt
    curl -s "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases" | grep -o "openwrt_s9xxx_.*/openwrt-armvirt-.*\.tar.gz" | head -n 1 > DOWNLOAD_URL
    [ -s DOWNLOAD_URL ] && wget -q -P openwrt-armvirt https://github.com/${GITHUB_REPOSITORY}/releases/download/$(cat DOWNLOAD_URL)
    sudo chmod +x make
    sudo ./make -d -b s905x3_s905x2_s905x_s905d_s922x_s912 -k 5.9.14_5.4.83
    cd out/ && sudo gzip *.img
    cp -f ../openwrt-armvirt/*.tar.gz . && sync
    echo "FILEPATH=$PWD" >> $GITHUB_ENV
    echo "FILE_DATE=$(date +"%Y.%m.%d.%H%M")" >> $GITHUB_ENV
    echo "::set-output name=status::success"
```

This function is suitable for the needs of replacing the [kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel) packaging and packaging the OpenWrt firmware of the specified [amlogic-s9xxx-STB](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb) separately. As long as you have the `openwrt-armvirt-64-default-rootfs.tar.gz` file in the [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases) of your repository, you can package the OpenWrt firmware you want at any time, which is efficient and convenient.

- ### Local packaging instructions

1. Clone the warehouse to the local. `git clone --depth 1 https://github.com/ophub/amlogic-s9xxx-openwrt.git`
2. Create a `openwrt-armvirt` folder, and upload the OpenWrt firmware of the ARM kernel ( Eg: `openwrt-armvirt-64-default-rootfs.tar.gz` ) to this `~/amlogic-s9xxx-openwrt/openwrt-armvirt` directory.
3. Enter the `~/amlogic-s9xxx-openwrt` root directory. And run Eg: `sudo ./make -d -b s905x3_s905d -k 5.4.75_5.9.5` to complete the compilation. The generated OpenWrt firmware is in the `out` directory under the root directory.

## Detailed make compile command

- `sudo ./make -d -b s905x3 -k 5.9.5`: recommend. Use the default configuration, specify a kernel and a firmware for compilation.
- `sudo ./make -d -b s905x3_s905d -k 5.4.75_5.9.5`: Use the default configuration, specify multiple cores, and multiple firmware for compilation. use `_` to connect.
- `sudo ./make -d`: Compile all kernel versions of openwrt with the default configuration.
- `sudo ./make -d -b s905x3 -k 5.9.2 -s 1024`: Use the default configuration, specify a kernel, a firmware, and set the partition size for compilation.
- `sudo ./make -d -b s905x3_s905d`: Use the default configuration, specify multiple firmware, use `_` to connect. compile all kernels.
- `sudo ./make -d -k 5.4.73_5.9.2`: Use the default configuration. Specify multiple cores, use `_` to connect.
- `sudo ./make -d -k latest`: Use the default configuration to compile the latest kernel version of the openwrt firmware.
- `sudo ./make -d -s 1024 -k 5.7.15`: Use the default configuration and set the partition size to 1024m, and only compile the openwrt firmware with the kernel version 5.7.15.
- `sudo ./make -h`: Display help information and view detailed description of each parameter.
- `sudo ./make`: If you are familiar with the relevant setting requirements of the s905x3 firmware, you can follow the prompts, such as selecting the firmware you want to make, the kernel version, setting the ROOTFS partition size, etc. If you don’t know these settings, just press Enter.

| Parameter | Types | Description |
| ---- | ---- | ---- |
| -d | Defaults | Compile all cores and all firmware types. |
| -b | Build | Specify the Build firmware type. Write the build firmware name individually, such as `-b s905x3` . Multiple firmware use `_` connect such as `-b s905x3_s905d` . You can also use model codes: `s905x3`, `s905x2`, `s905x`, `s905d`, `s922x`, `s912` |
| -k | Kernel | Specify the kernel type. Write the kernel name individually such as `-k 5.4.50` . Multiple cores use `_` connection such as `-k 5.4.50_5.9.5` [View the kernel library](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel). |
| -s | Size | Specify the size of the root partition in MB. The default is 1024, and the specified size must be greater than 256. Such as `-s 1024` |
| -h | help | View full documentation. |

## Build more kernel files

***`Flippy`*** has shared with us dozens of versions of firmware, Brings unlimited freedom to amlogic s9xxx STB. We have stored some of the latest kernels in the [kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel) directory. If you think it’s not enough, or you don’t find the version you miss, you can use the kernel build tool to add the `Flippy kernel` to the Kernel library of the repository, and package the version of openwrt firmware you want. [For more instructions please see: build_kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/build_kernel)

## ~/openwrt-armvirt/* Firmware compilation parameters

| Option | Value |
| ---- | ---- |
| Target System | QEMU ARM Virtual Machine |
| Subtarget | QEMU ARMv8 Virtual Machine(cortex-a53) |
| Target Profile | Default |
| Target Images | squashfs |

[For more instructions please see: router_config](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/router_config)

## Firmware information

| Name | Value |
| ---- | ---- |
| Default IP | 192.168.1.1 |
| Default username | root |
| Default password | password |
| Default WIFI name | OpenWrt |
| Default WIFI password | none |

## Bypass gateway settings

If used as a bypass gateway, you can add custom firewall rules as needed (Network → Firewall → Custom Rules):

```yaml
iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE        #If the interface is eth0.
iptables -t nat -I POSTROUTING -o br-lan -j MASQUERADE      #If the interface is br-lan bridged.
```

## Acknowledgments

- [OpenWrt](https://github.com/openwrt/openwrt)
- [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
- [Lienol/openwrt](https://github.com/Lienol/openwrt)
- Flippy: The maker of Amlogic s9xxx Kernel for openwrt
- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [tuanqing/mknop](https://github.com/tuanqing/mknop)
- [Mikubill/transfer](https://github.com/Mikubill/transfer)

## License

[LICENSE](https://github.com/ophub/op/blob/main/LICENSE) © OPHUB

