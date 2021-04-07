# install-program

View Chinese description  |  [查看中文说明](README.cn.md)

Install and Update openwrt to emmc for Amlogic S9xxx STB.

## Instructions

1. `svn co https://github.com/ophub/amlogic-s9xxx-openwrt/trunk/amlogic-s9xxx/install-program package/install-program`
2. Execute make `menuconfig` and select `install-program` under `Utilities`

```shell script
Utilities  --->  
   <*> install-program
```
💡Tips: This installation and update script can be introduced and used separately during github.com online compilation. If the firmware in the `openwrt-armvirt` directory you provided does not integrate this installation and update script, ***`Will auto add`*** this function to you through the `./make` script when packaging.

## Install to Amlogic S9xxx STB EMMC and update instructions

Choose the corresponding firmware according to your Amlogic S9xxx STB. Then write the IMG file to the USB hard disk through software such as [Rufus](https://rufus.ie/) or [balenaEtcher](https://www.balena.io/etcher/). Insert the USB hard disk into the Amlogic S9xxx STB. Common for all `Amlogic S9xxx STB`.

### Install OpenWrt

- Log in to the default IP: 192.168.1.1 → `Login in to openwrt` → `system menu` → `TTYD terminal` → input command: 

```yaml
openwrt-install
```

When writing into EMMC through [openwrt-install](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/openwrt-install), `select the name` of the Amlogic S9xxx STB you own in the menu.

For more OpenWrt firmware .dtb files are in the [amlogic-dtb](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb) directory. You can use the `openwrt_s905x3_v*.img` firmware to install via USB hard disk. When writing into EMMC through [openwrt-install](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/openwrt-install), [select 0: Enter the dtb file name of your box](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb), and use the Amlogic S9xxx STB you own.

### Update OpenWrt firmware

- Log in to the default IP: 192.168.1.1 →  `Login in to openwrt` → `system menu` → `file transfer` → upload ***`openwrt*.img.gz (Support suffix: *.img.xz, *.img.gz, *.7z, *.zip)`*** to ***`/tmp/upload/`***, enter the `system menu` → `TTYD terminal` → input command: 

```yaml
openwrt-update
```
💡Tips: You can also put the `update file` in the `/mnt/mmcblk*p4/` directory, the `openwrt-update` script will automatically find the `update file` from the `/mnt/mmcblk*p4/` and `/tmp/upload/` directories.
    
If there is only one `update file` in the ***`/mnt/mmcblk*p4/`*** and ***`/tmp/upload/`***  directory, you can just enter the ***`openwrt-update`*** command without specifying a specific `update file`. The `openwrt-update` will vaguely look for `update file` from this directory and try to update. If there are multiple `update file` in the `/mnt/mmcblk*p4/` directory, please use the ***`openwrt-update specified_update_file`*** command to specify the `update file`. When the `update file` is not found in the `/mnt/mmcblk*p4/` directory, the `openwrt-update` will search for the `update file` in the `/tmp/upload/` directory and move it to the `/mnt/mmcblk*p4/` directory to perform the update operation. 

- The `openwrt-update` update file search order

| Directory | `/mnt/mmcblk*p4/` 1-6 | `/tmp/upload/` 7-10 |
| ---- | ---- | ---- |
| Oeder | `specified_update_file` → `*.img` → `*.img.xz` → `*.img.gz` → `*.7z` → `*.zip` → | `*.img.xz` → `*.img.gz` → `*.7z` → `*.zip` |

### Replace OpenWrt kernel

- Log in to the default IP: 192.168.1.1 →  `Login in to openwrt` → `system menu` → `file transfer` → upload ***`kernel.tar.xz & modules.tar.xz  (Or the original kernel 3 file provided by Flippy：boot-*，dtb-amlogic-*，modules-*)`*** to ***`/tmp/upload/`***, enter the `system menu` → `TTYD terminal` → input the Kernel replacement command: 

```yaml
openwrt-kernel
```

💡Tips: You can also put the `kernel files` in the `/mnt/mmcblk*p4/` directory, the `openwrt-kernel` script will automatically find the `kernel file` from the `/mnt/mmcblk*p4/` and `/tmp/upload/` directories. When there are both the reorganized kernel files of this repository and the original kernel of `Flippy` in two directories, the 3 files of `Flippy` are first used for kernel replacement.

This script is also suitable for kernel replacement of the `OpenWrt` series firmware produced and shared by `Flippy`. Put the `openwrt-kernel` file in the `/usr/bin/` directory and grant the execution permission `chmod 777 /usr/bin/openwrt-kernel`, you can enter the kernel replacement command in any directory to operate. Since the `OpenWrt` in use may choose a different `U-BOOT (Mainline/Android)`, for the sake of safety, the script judges whether the kernel is 5.10 and supports the same series for replacement (for example, the 5.10 kernel can only be replaced with 5.10 Series kernels, non-5.10 kernels can only be replaced with non-5.10 related kernels).

### Backup & Restore

You can backup and restore software config information at any time when you need it, and the software list can be adjusted according to your needs: [openwrt-backup](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/common-files/files/usr/bin/openwrt-backup) . Please operate according to the prompts, if `b` is for `backup`, `r` is for `restore`.

- Log in to the default IP: 192.168.1.1 → `Login in to openwrt` → `system menu` → `TTYD terminal` → input command: 

```yaml
openwrt-backup
```

When `opemwrt-update` the software, you will also be asked whether to keep the current config. If you choose `y`, the current software config information will be automatically restored after the update is completed. If the config information of a certain software in the current version is different from the previous version, the restored config may not work normally. Please manually clear the config information of this software and reconfigure it.

### Write bootloader

If your box is X96-Max+, you must write the bootloader of HK1-Box included in the firmware to EMMC before it can be gigabit. This step is now integrated into the installation script and is automatically completed during installation:

```shell script
dd if=/lib/u-boot/hk1box-bootloader.img  of=/dev/mmcblk2 bs=1 count=442 conv=fsync 2>/dev/null
dd if=/lib/u-boot/hk1box-bootloader.img  of=/dev/mmcblk2 bs=512 skip=1 seek=1 conv=fsync 2>/dev/null
sync
reboot
```

If the Phicomm-n1 partition fails and cannot be written, you can restore the bootloader, restart it, and run the relevant command again.
```shell script
dd if=/lib/u-boot/u-boot-2015-phicomm-n1.bin of=/dev/mmcblk1
sync
reboot
```

## Option description when installing into Amlogic S9xxx STB emmc

| Serial | STB | Description | DTB |
| ---- | ---- | ---- | ---- |
| 1 | X96-Max+ | S905x3: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-sm1-x96-max-plus.dtb |
| 2 | X96-Max+ | 905x3: NETWORK: 1000M / TF: 30Mtz / CPU: 2208Mtz | meson-sm1-x96-max-plus-oc.dtb |
| 3 | HK1-Box | S905x3: NETWORK: 1000M / TF: 25Mtz / CPU: 2124Mtz | meson-sm1-hk1box-vontar-x3.dtb |
| 4 | HK1-Box | S905x3: NETWORK: 1000M / TF: 25Mtz / CPU: 2184Mtz | meson-sm1-hk1box-vontar-x3-oc.dtb |
| 5 | H96-Max-X3 | S905x3: NETWORK: 1000M / TF: 50Mtz / CPU: 2124Mtz | meson-sm1-h96-max-x3.dtb |
| 6 | H96-Max-X3 | S905x3: NETWORK: 1000M / TF: 50Mtz / CPU: 2208Mtz | meson-sm1-h96-max-x3-oc.dtb |
| 7 | X96-Max-4G | S905x2: NETWORK: 1000M / TF: 50Mtz / CPU: 1944Mtz | meson-g12a-x96-max.dtb |
| 8 | X96-Max-2G | S905x2: NETWORK: 100M  / TF: 50Mtz / CPU: 1944Mtz | meson-g12a-x96-max-rmii.dtb |
| 9 | Belink GT-King | S922x: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-g12b-gtking.dtb |
| 10 | Belink GT-King Pro | S922x: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-g12b-gtking-pro.dtb |
| 11 | UGOOS AM6 Plus | S922x: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-g12b-ugoos-am6.dtb |
| 12 | Octopus-Planet | S912: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-gxm-octopus-planet.dtb |
| 13 | Phicomm-n1 | S905d: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-gxl-s905d-phicomm-n1.dtb |
| 14 | hg680p & b860h | S905x: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-gxl-s905x-p212.dtb |
| 0 | Other | - | Enter the dtb file name of your box |

You can refer to the [dtb library](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb) when you customize the file name.

## Turn on the USB disk boot mode of the Amlogic S9xxx STB

- Open the developer mode: Settings → About this machine → Version number (for example: X96max plus...), click on the version number for 7 times in quick succession, and you will see that the developer mode is turned on.
- Turn on USB debugging: After restarting, enter Settings → System → Advanced options → Developer options again (after entering, confirm that the status is on, and the USB debugging status in the list is also on)
- Boot from USB hard disk: Unplug the power → insert the USB hard disk → insert the thimble into the AV port (top reset button) → insert the power → release the thimble of the av port → the system will boot from the USB hard disk.
- Log in to the system: Connect the computer and the s9xxx box with a network interface → turn off the wireless wifi on the computer → enable the wired connection → manually set the computer ip to the same network segment ip as openwrt, ipaddr such as `192.168.1.2`. The netmask is `255.255.255.0`, and others are not filled in. You can log in to the openwrt system from the browser, Enter OpwnWrt's IP Address: `192.168.1.1`, Account: `root`, Password: `password`, and then log in OpenWrt system.

## How to recover if the install fails and cannot be started

- Under normal circumstances, re-insert the USB hard disk and install it again.

- If you cannot start the OpenWrt system from the USB hard disk again, connect the Amlogic S9xxx STB to the computer monitor. If the screen is completely black and there is nothing, you need to restore the Amlogic S9xxx STB to factory settings first, and then reinstall it.

```
Take x96max+ as an example.

Prepare materials:

1. [ A USB male-to-male data cable ]: https://www.ebay.com/itm/152516378334
2. [ A paper clip ]: https://www.ebay.com/itm/133577738858
3. Install the software and Download the Android TV firmware
   [ Install the USB_Burning_Tool ]: https://androidmtk.com/download-amlogic-usb-burning-tool
   [ Android TV firmware ]: https://xdafirmware.com/x96-max-plus-2
4. [ Find the two short-circuit points on the motherboard ]:
   https://user-images.githubusercontent.com/68696949/110590933-67785300-81b3-11eb-9860-986ef35dca7d.jpg

Operation method:

1. Connect the [ Amlogic S9xxx STB ] to the [ computer ] with a [ USB male-to-male data cable ].
2. Open the USB Burning Tool:
   [ File → Import image ]: X96Max_Plus2_20191213-1457_ATV9_davietPDA_v1.5.img
   [ Check ]：Erase flash
   [ Check ]：Erase bootloader
   Click the [ Start ] button
3. Use a [ paper clip ] to [ connect the two short-circuit points ] on the motherboard at the same time.
   If the progress bar does not respond after the short-circuit, plug in the [ power ] supply after the short-circuit.
   Generally, there is no need to plug in the power supply.
4. Loosen the short contact after seeing the [ progress bar moving ].
5. After the [ progress bar is 100% ], the restoration of the original Android TV system is completed.
   Click [ stop ], unplug the [ USB male-to-male data cable ] and [ power ].
6. If the progress bar is interrupted, repeat the above steps until it succeeds.
```
After restoring the factory settings, the operation method is the same as when you install openwrt on the Amlogic S9xxx STB for the first time:

- Make an openwrt mirrored usb hard disk and insert it into the USB port of the Amlogic S9xxx STB. Use a paper clip or other objects to press and hold the reset button in the AV hole, plug in the power, wait 5 seconds and then release the reset button, the system will boot from the USB hard disk, enter the openwrt system, enter The installation command can reinstall openwrt.

## If you can’t startup after using the Mainline u-boot

- Some Amlogic S905x3 STB sometimes fail to boot after use the `mainline u-boot`. The fault phenomenon is usually the `=>` prompt of u-boot automatically. The reason is that TTL lacks a pull-up resistor or pull-down resistor and is easily interfered by surrounding electromagnetic signals. The solution is to solder a 5K-10K resistor (pull-down) between TTL RX and GND, or solder a resistor between RX and 3.3V. A resistance of 5K-10K (pull-up).
- The `mainline u-boot` is not perfect yet, and the install is not prompted by default. The relatively stable BootLoader is currently installed by default.
- If you are willing to try it, you can use the `openwrt-install TEST-UBOOT` command to install and choose. But I strongly recommend that you don't try it. When it is stable, I will enable the recommendation prompt in the install and update script. It is still in the testing period.

If you choose to use the `mainline u-boot` during installation and it fails to start, please connect the Amlogic S905x3 STB to the monitor. If the screen shows the following prompt:
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

