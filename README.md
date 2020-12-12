# OpenWrt for S9xxx-Boxs and Phicomm-N1

Support `github.com One-stop compilation`, `github.com clone packaging`, `Local packaging`. including OpenWrt firmware install to EMMC and upgrade related functions. Support Amlogic-s9xxx chip series such as S905x3, S905x2, S922x and Phicomm-N1.

The latest version of the OpenWrt firmware is automatically compiled every Monday & Thursday, which can be downloaded in [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases). Some important update instructions can be found in [ChangeLog.md](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/ChangeLog.md) documents.

This OpenWrt firmware is packaged using ***`Flippy's`*** [Amlogic S9xxx Kernel for OpenWrt](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/armbian), and the [Installation and Update scripts](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/install-program), etc. Special thanks The maker `Flippy`.

Welcome to use `forks` for personalized OpenWrt firmware configuration. If you like it, Please click the `stars`.

## OpenWrt Firmware instructions

- `s9xxx-v*-openwrt_*.img`: Almost compatible with ***`all S9xxx-Boxs`***, you can choose different box types when installing into EMMC.
- `x96-v*-openwrt_*.img`: For X96-Max+(S905x3).
- `hk1-v*-openwrt_*.img`: For HK1-Box(S905x3).
- `h96-v*-openwrt_*.img`: For H96-Max-X3(S905x3).
- `octopus-v*-openwrt_*.img` For Octopus-Planet.
- `belink-v*-openwrt_*.img` For Belink GT-King.
- `belinkpro-v*-openwrt_*.img` For Belink GT-King Pro.
- `n1-v*-openwrt_*.img`: For Phicomm-N1.

For more firmware, please select in the [installation script](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/install-program)

## Install to emmc partition or upgrade instructions

Insert the `USB hard disk` with the written `OpenWrt` firmware. Log in to the default IP: 192.168.1.1 → `Login in to openwrt` → `system menu` → `TTYD terminal` → input command: 

- Phicomm-N1 installation command: `n1-install.sh`
- S9xxx-Boxs installation command: `s9xxx-install.sh`

[For more instructions please see: install-program](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/install-program)


- ## github.com One-stop compilation instructions

You can modify the configuration file in the `router_config` directory and `.yml` file, customize the OpenWrt firmware, and complete the packaging online through `Actions`, and complete all the compilation of OpenWrt firmware in github.com One-stop.

1. Personalized plug-in configuration in [router_config](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/router_config) directory. Workflows configuration in [.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt.yml) file.
2. Select ***`Build OpenWrt`*** on the [Action](https://github.com/ophub/amlogic-s9xxx-openwrt/actions) page. Click the ***`Run workflow`*** button.

- ## github.com clone packaging instructions

[For more instructions please see: .yml example](https://github.com/ophub/op/blob/main/.github/workflows/build-openwrt-s9xxx.yml)

In your .github/workflows/*.yml file, after completing the compilation of Subtarget is ARMv8, add the following online packaging code:

```yaml
- name: Build OpenWrt for S9xxx-Boxs and Phicomm-N1
  id: build
  run: |
    git clone --depth 1 https://github.com/ophub/amlogic-s9xxx-openwrt.git
    cd amlogic-s9xxx-openwrt/
    mkdir -p openwrt-armvirt
    cp -f ../openwrt/bin/targets/*/*/*.tar.gz openwrt-armvirt/
    sudo chmod +x make
    sudo ./make -d -b s9xxx_n1_x96_hk1_h96_octopus_belinkpro_belink -k 5.4.77_5.9.8
    cd out/ && gzip *.img
    cp -f ../openwrt-armvirt/*.tar.gz . && sync
    echo "FILEPATH=$PWD" >> $GITHUB_ENV
    echo "::set-output name=status::success"
```

- Uploads OpenWrt Firmware to Actions:

```yaml
- name: Upload OpenWrt Firmware to Actions for S9xxx
  uses: actions/upload-artifact@v2
  with:
    name: openwrt_s9xxx
    path: ${{ env.FILEPATH }}/openwrt_s9xxx_*
    if-no-files-found: ignore

- name: Upload OpenWrt Firmware to Actions for Phicomm-N1
  uses: actions/upload-artifact@v2
  with:
    name: openwrt_phicomm-n1
    path: ${{ env.FILEPATH }}/openwrt_n1_*
    if-no-files-found: ignore

# More Upload to Actions
- name: Upload OpenWrt Firmware ...
```

- The upload path of the packaged openwrt is ```${{ env.FILEPATH }}/*```

```yaml
path: ${{ env.FILEPATH }}/openwrt_s9xxx_*        #For S9xxx series box general firmware
path: ${{ env.FILEPATH }}/openwrt_n1_*           #For Phicomm-N1
path: ${{ env.FILEPATH }}/openwrt_x96_*          #For X96-Max+
path: ${{ env.FILEPATH }}/openwrt_hk1_*          #For HK1-Box
path: ${{ env.FILEPATH }}/openwrt_h96_*          #For H96-Max-X3
path: ${{ env.FILEPATH }}/openwrt_octopus_*      #For Octopus-Planet
path: ${{ env.FILEPATH }}/openwrt_belink_*       #For Belink GT-King
path: ${{ env.FILEPATH }}/openwrt_belinkpro_*    #For Belink GT-King Pro
```

- Uploads OpenWrt Firmware to Release:

```yaml
- name: Upload OpenWrt Firmware to Release
  uses: softprops/action-gh-release@v1
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  with:
    tag_name: openwrt_s9xxx_phicomm-n1
    files: ${{ env.FILEPATH }}/*
    body: |
      This is OpenWrt firmware for S9xxx-Boxs and Phicomm-N1.
      More information ...
```

- ## Local packaging instructions

1. Clone the warehouse to the local. `git clone --depth 1 https://github.com/ophub/amlogic-s9xxx-openwrt.git`
2. Create a `openwrt-armvirt` folder, and upload the OpenWrt firmware of the ARM kernel ( Eg: `openwrt-armvirt-64-default-rootfs.tar.gz` ) to this `~/amlogic-s9xxx-openwrt/openwrt-armvirt` directory.
3. Enter the `~/amlogic-s9xxx-openwrt` root directory. And run Eg: `sudo ./make -d -b n1_x96 -k 5.4.75_5.9.5` to complete the compilation. The generated OpenWrt firmware is in the `out` directory under the root directory.

## Detailed make compile command

- `sudo ./make -d -b n1 -k 5.9.5`: recommend. Use the default configuration, specify a kernel and a firmware for compilation.
- `sudo ./make -d -b n1_s9xxx -k 5.4.75_5.9.5`: Use the default configuration, specify multiple cores, and multiple firmware for compilation. use "_" to connect.
- `sudo ./make -d`: Compile all kernel versions of openwrt with the default configuration.
- `sudo ./make -d -b n1 -k 5.9.2 -s 1024`: Use the default configuration, specify a kernel, a firmware, and set the partition size for compilation.
- `sudo ./make -d -b n1_s9xxx`: Use the default configuration, specify multiple firmware, use "_" to connect. compile all kernels.
- `sudo ./make -d -k 5.4.73_5.9.2`: Use the default configuration. Specify multiple cores, use "_" to connect.
- `sudo ./make -d -k latest`: Use the default configuration to compile the latest kernel version of the openwrt firmware.
- `sudo ./make -d -s 1024 -k 5.7.15`: Use the default configuration and set the partition size to 1024m, and only compile the openwrt firmware with the kernel version 5.7.15.
- `sudo ./make -h`: Display help information and view detailed description of each parameter.
- `sudo ./make`: If you are familiar with the relevant setting requirements of the phicomm_n1 firmware, you can follow the prompts, such as selecting the firmware you want to make, the kernel version, setting the ROOTFS partition size, etc. If you don’t know these settings, just press Enter.

| Parameter | Types | Description |
| ---- | ---- | ---- |
| -d | Defaults | Compile all cores and all firmware types. |
| -b | Build | Specify the Build firmware type. Write the build firmware name individually, such as `-b n1` . Multiple firmware use `_` connect such as `-b n1_s9xxx` . The model represented by the relevant variable： `s9xxx` is S9xxx series Boxs general firmware, `belinkpro` is Belink GT-King Pro, `belink` is Belink GT-King, `n1` is Phicomm-N1, `x96` is X96-Max+, `hk1` is HK1-Box, `h96` is H96-Max-X3, `octopus` is Octopus-Planet. |
| -k | Kernel | Specify the kernel type. Write the kernel name individually such as `-k 5.4.50` . Multiple cores use `_` connection such as `-k 5.4.50_5.9.5` |
| -s | Size | Specify the size of the root partition in MB. The default is 1024, and the specified size must be greater than 256. Such as `-s 1024` |
| -h | help | View full documentation. |

## Build more kernel files

***`Flippy`*** has shared with us dozens of versions of firmware, The `amlogic-s9xxx series boxes` bring unlimited freedom. We have treasured a lot in [kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/armbian/kernel-amlogic/kernel). If you think it’s not enough, or you don’t find the version you miss, you can use the kernel build tool to add the `Flippy kernel` to the Kernel library of the repository, and package the version of openwrt firmware you want. [For more instructions please see: build_kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/build_kernel)

## ~/openwrt-armvirt/* Firmware compilation parameters

| Option | Value |
| ---- | ---- |
| Target System | QEMU ARM Virtual Machine |
| Subtarget | ARMv8 multiplatform |
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


