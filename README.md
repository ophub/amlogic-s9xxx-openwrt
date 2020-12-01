# Packaged OpenWrt for S905x3-Boxs and Phicomm-N1

Support local compilation and github.com online compilation, including OpenWrt firmware install to EMMC and upgrade related functions. Support Amlogic-s9xxx chip series such as S905x3-Boxs and Phicomm-N1.

## Local packaging instructions

1. Clone the warehouse to the local. `git clone https://github.com/ophub/amlogic-s9xxx-kernel-for-openwrt.git`
2. Create an `openwrt-armvirt` folder in the local Eg: `~/amlogic-s9xxx-kernel-for-openwrt/openwrt-armvirt`, and upload the compiled openwrt firmware of the ARM kernel to the `openwrt-armvirt` directory.
3. Enter the `~/amlogic-s9xxx-kernel-for-openwrt` root directory. And run Eg: `sudo ./make -d -b n1_x96 -k 5.4.75_5.9.5` to complete the compilation. The generated openwrt firmware is in the `out` directory under the root directory.

## github.com online packaging instructions

[For more instructions please see: .yml example](https://github.com/ophub/openwrt-s905x3-phicomm-n1/blob/main/.github/workflows/build-openwrt-s905x3-phicomm_n1.yml). 

In your .github/workflows/*.yml file, after completing the compilation of Subtarget is ARMv8, add the following online packaging code:

```yaml
- name: Build OpenWrt for S905x3-Boxs and Phicomm-N1
  id: build
  run: |
    git clone https://github.com/ophub/amlogic-s9xxx-kernel-for-openwrt.git amlogic-s9xxx-kernel-for-openwrt
    cd amlogic-s9xxx-kernel-for-openwrt
    mkdir -p openwrt-armvirt
    cp -f ../openwrt/bin/targets/*/*/*.tar.gz openwrt-armvirt
    sudo chmod +x make
    sudo ./make -d -b n1_x96_hk1_h96_octopus -k 5.4.77_5.9.8
    cd out && gzip *.img
    cp -f ../openwrt-armvirt/*.tar.gz . && sync
    echo "FILEPATH=$PWD" >> $GITHUB_ENV
    echo "::set-output name=status::success"
```

- Uploads OpenWrt Firmware to Actions:

```yaml
- name: Upload OpenWrt Firmware to Actions for Phicomm-N1
  uses: actions/upload-artifact@v2
  with:
    name: openwrt_phicomm-n1
    path: ${{ env.FILEPATH }}/openwrt_n1_*
    if-no-files-found: ignore

- name: Upload OpenWrt Firmware to Actions for X96-Max+
  uses: actions/upload-artifact@v2
  with:
    name: openwrt_x96-max
    path: ${{ env.FILEPATH }}/openwrt_x96_*
    if-no-files-found: ignore

# More Upload to Actions
- name: Upload OpenWrt Firmware ...

```

- The upload path of the packaged openwrt is ```${{ env.FILEPATH }}/```

```yaml
path: ${{ env.FILEPATH }}/openwrt_n1_*           #For Phicomm-N1
path: ${{ env.FILEPATH }}/openwrt_x96_*          #For X96-Max+
path: ${{ env.FILEPATH }}/openwrt_hk1_*          #For HK1-Box
path: ${{ env.FILEPATH }}/openwrt_h96_*          #For H96-Max-X3
path: ${{ env.FILEPATH }}/openwrt_octopus_*      #For Octopus-Planet
```

- Uploads OpenWrt Firmware to Release:

```yaml
- name: Upload OpenWrt firmware to release for S905x3-Boxs and Phicomm-N1
  uses: svenstaro/upload-release-action@v2
  with:
    repo_token: ${{ secrets.GITHUB_TOKEN }}
    file: ${{ env.FILEPATH }}/*
    tag: openwrt_s905x3_phicomm-n1
    overwrite: true
    file_glob: true
    body: |
      This is OpenWrt firmware for S905x3-Boxs and Phicomm-N1
```

## OpenWrt Firmware instructions

- `n1-v*-openwrt_*.img`: For Phicomm-N1.
- `x96-v*-openwrt_*.img`: Almost compatible with all S905x3-Boxs, you can choose different box types when installing into EMMC.
- `hk1-v*-openwrt_*.img`: For HK1-Box(S905x3).
- `h96-v*-openwrt_*.img`: For H96-Max-X3(S905x3).
- `octopus-v*-openwrt_*.img` For Octopus-Planet.

## Install to emmc partition or upgrade instructions

[For more instructions please see: install-program](https://github.com/ophub/amlogic-s9xxx-kernel-for-openwrt/tree/main/install-program).

- ***`Install OpenWrt for Phicomm-N1`***

Log in to the default IP: 192.168.1.1 → `Login in to openwrt` → `system menu` → `TTYD terminal` → input command: 
```shell script
n1-install.sh
reboot
```

- ***`Upgrading OpenWrt for Phicomm-N1`***

Log in to the default IP: 192.168.1.1 → `Login in to openwrt` → `system menu` → `TTYD terminal` → input command: 
```shell script
n1-update.sh
reboot
```

- ***`Install OpenWrt for S905x3-Boxs`***

Log in to the default IP: 192.168.1.1 → `Login in to openwrt` → `system menu` → `TTYD terminal` → input command: 
```shell script
s905x3-install.sh
reboot
```

- ***`Upgrading OpenWrt for S905x3-Boxs`***

Log in to the default IP: 192.168.1.1 → `Login in to openwrt` → `system menu` → `file transfer` → upload ***`s905x3-openwrt.img.gz`*** to ***`/tmp/upload/`***, enter the `system menu` → `TTYD terminal` → input command: 
```shell script
mv -f /tmp/upload/*.img.gz /mnt/mmcblk2p4/
cp -f /usr/bin/s905x3-update.sh /mnt/mmcblk2p4/
cd /mnt/mmcblk2p4/
gzip -df *.img.gz
s905x3-update.sh
#s905x3-update.sh  your_openwrt_imgFileName.img
reboot
```

## Bypass gateway settings

If used as a bypass gateway, you can add custom firewall rules as needed (Network → Firewall → Custom Rules):

```shell script
iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE        #If the interface is eth0.
iptables -t nat -I POSTROUTING -o br-lan -j MASQUERADE      #If the interface is br-lan bridged.
```

## Option description when installing into s905x3-boxs emmc

You can refer to the [dtb library](https://github.com/ophub/amlogic-s9xxx-kernel-for-openwrt/tree/main/armbian/dtb-amlogic) when you customize the file name.

| Serial | Box | Description | DTB |
| ---- | ---- | ---- | ---- |
| 1 | X96-Max+ | S905x3: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-sm1-x96-max-plus.dtb |
| 2 | HK1-Box | S905x3: NETWORK: 1000M / TF: 25Mtz / CPU: 2124Mtz | meson-sm1-hk1box-vontar-x3.dtb |
| 3 | H96-Max-X3 | S905x3: NETWORK: 1000M / TF: 50Mtz / CPU: 2124Mtz | meson-sm1-h96-max-x3.dtb |
| 4 | X96-Max-4G | S905x2: NETWORK: 1000M / TF: 50Mtz / CPU: 1944Mtz | meson-g12a-x96-max.dtb |
| 5 | X96-Max-2G | S905x2: NETWORK: 100M  / TF: 50Mtz / CPU: 1944Mtz | meson-g12a-x96-max-rmii.dtb |
| 6 | X96-Max+ | 905x3: NETWORK: 1000M / TF: 30Mtz / CPU: 2244Mtz | meson-sm1-x96-max-plus-oc.dtb |
| 7 | HK1-Box | S905x3: NETWORK: 1000M / TF: 25Mtz / CPU: 2184Mtz | meson-sm1-hk1box-vontar-x3-oc.dtb |
| 8 | H96-Max-X3 | S905x3: NETWORK: 1000M / TF: 50Mtz / CPU: 2208Mtz | meson-sm1-h96-max-x3-oc.dtb |
| 9 | Octopus-Planet | S905x3: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-gxm-octopus-planet.dtb |
| 0 | Other | - | Enter the dtb file name |


## Detailed make compile command

- `sudo ./make -d -b n1 -k 5.9.5`: recommend. Use the default configuration, specify a kernel and a firmware for compilation.
- `sudo ./make -d -b n1_x96 -k 5.4.75_5.9.5`: Use the default configuration, specify multiple cores, and multiple firmware for compilation. use "_" to connect.
- `sudo ./make -d`: Compile all kernel versions of openwrt with the default configuration.
- `sudo ./make -d -b n1 -k 5.9.2 -s 1024`: Use the default configuration, specify a kernel, a firmware, and set the partition size for compilation.
- `sudo ./make -d -b n1_x96`: Use the default configuration, specify multiple firmware, use "_" to connect. compile all kernels.
- `sudo ./make -d -k 5.4.73_5.9.2`: Use the default configuration. Specify multiple cores, use "_" to connect.
- `sudo ./make -d -k latest`: Use the default configuration to compile the latest kernel version of the openwrt firmware.
- `sudo ./make -d -s 1024 -k 5.7.15`: Use the default configuration and set the partition size to 1024m, and only compile the openwrt firmware with the kernel version 5.7.15.
- `sudo ./make -h`: Display help information and view detailed description of each parameter.
- `sudo ./make`: If you are familiar with the relevant setting requirements of the phicomm_n1 firmware, you can follow the prompts, such as selecting the firmware you want to make, the kernel version, setting the ROOTFS partition size, etc. If you don’t know these settings, just press Enter.

| Parameter | Types | Description |
| ---- | ---- | ---- |
| -d | Defaults | Compile all cores and all firmware types. |
| -b | Build | Specify the Build firmware type. Write the build firmware name individually, such as `-b n1` . Multiple firmware use `_` connect such as `-b n1_x96` . The model represented by the relevant variable： `n1` is phicomm-n1, `x96` is X96-Max+, `hk1` is HK1-Box, `h96` is H96-Max-X3, `octopus` is Octopus-Planet. |
| -k | Kernel | Specify the kernel type. Write the kernel name individually such as `-k 5.4.50` . Multiple cores use `_` connection such as `-k 5.4.50_5.9.5` |
| -s | Size | Specify the size of the root partition in MB. The default is 1024, and the specified size must be greater than 256. Such as `-s 1024` |
| -h | help | View full documentation. |

## ARMv8 Firmware compilation parameters

| Option | Value |
| ---- | ---- |
| Target System | QEMU ARM Virtual Machine |
| Subtarget | ARMv8 multiplatform |
| Target Profile | Default |
| Target Images | squashfs |

