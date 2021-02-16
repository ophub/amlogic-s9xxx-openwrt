# install-program

Install and Upgrading openwrt to the emmc for S9xxx-Boxs.

## Instructions

1. `svn co https://github.com/ophub/amlogic-s9xxx-openwrt/trunk/amlogic-s9xxx/install-program package/install-program`
2. Execute make `menuconfig` and select `install-program` under `Utilities`

```shell script
Utilities  --->  
   <*> install-program
```
💡Tips: This installation and upgrade script can be introduced and used separately during github.com online compilation. If the firmware in the `openwrt-armvirt` directory you provided does not integrate this installation and upgrade script, ***`Will auto add`*** this function to you through the `./make` script when packaging.

## Install to S9xxx-Boxs EMMC partition and upgrade instructions

Choose the corresponding firmware according to your box. Then write the IMG file to the USB hard disk through software such as [balenaEtcher](https://www.balena.io/etcher/). Insert the USB hard disk into the S9xxx-Boxs. Common for `Phicomm-n1` and `s9xxx-Boxes`.

***`Install OpenWrt`***

- Log in to the default IP: 192.168.1.1 → `Login in to openwrt` → `system menu` → `TTYD terminal` → input command: 

```yaml
s9xxx-install.sh
reboot
```

When writing into EMMC through [s9xxx-install.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/s9xxx-install.sh), `select the name` of the box you own in the menu.

For more OpenWrt firmware .dtb files are in the [amlogic-dtb](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb) directory. You can use the `openwrt_s905x3_v*.img` firmware to install via USB hard disk. When writing into EMMC through [s9xxx-install.sh](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/files/s9xxx-install.sh), [select 0: Enter the dtb file name of your box](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb), and use the S9xxx-Boxes you own.

***`Upgrading OpenWrt`***

- Log in to the default IP: 192.168.1.1 →  `Login in to openwrt` → `system menu` → `file transfer` → upload ***`openwrt*.img.gz`*** to ***`/tmp/upload/`***, enter the `system menu` → `TTYD terminal` → input command: 

```yaml
mv -f /tmp/upload/*.img.gz /mnt/mmcblk*p4/
cp -f /usr/bin/s9xxx-update.sh /mnt/mmcblk*p4/
cd /mnt/mmcblk*p4/
gzip -df *.img.gz
chmod 755 s9xxx-update.sh
./s9xxx-update.sh
# ./s9xxx-update.sh  your_openwrt_imgFileName.img
reboot
```

Tips: If there is only one `.img` file in the ***`/mnt/mmcblk*p4/`*** directory, you can just enter the ***`s9xxx-update.sh`*** command without specifying a specific file name. The upgrade script will vaguely look for `.img` files from the fixed directory and try to upgrade. If there are multiple `.img` files in the ***`/mnt/mmcblk*p4/`*** directory, please use the ***`s9xxx-update.sh your_openwrt_imgFileName.img`*** command to specify the firmware upgrade.

***`Write bootloader`***

If your box is X96-Max+, you must write the bootloader of HK1-Box included in the firmware to EMMC before it can be gigabit. This step is now integrated into the installation script and is automatically completed during installation:

```shell script
dd if=/root/hk1box-bootloader.img  of=/dev/mmcblk2 bs=1 count=442 conv=fsync 2>/dev/null
dd if=/root/hk1box-bootloader.img  of=/dev/mmcblk2 bs=512 skip=1 seek=1 conv=fsync 2>/dev/null
sync
reboot
```

If the Phicomm-n1 partition fails and cannot be written, you can restore the bootloader, restart it, and run the relevant command again.
```shell script
dd if=/root/u-boot-2015-phicomm-n1.bin of=/dev/mmcblk1
sync
reboot
```
## Option description when installing into s9xxx-boxs emmc

| Serial | Box | Description | DTB |
| ---- | ---- | ---- | ---- |
| 1 | X96-Max+ | S905x3: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-sm1-x96-max-plus.dtb |
| 2 | X96-Max+ | 905x3: NETWORK: 1000M / TF: 30Mtz / CPU: 2208Mtz | meson-sm1-x96-max-plus-oc.dtb |
| 3 | HK1-Box | S905x3: NETWORK: 1000M / TF: 25Mtz / CPU: 2124Mtz | meson-sm1-hk1box-vontar-x3.dtb |
| 4 | HK1-Box | S905x3: NETWORK: 1000M / TF: 25Mtz / CPU: 2184Mtz | meson-sm1-hk1box-vontar-x3-oc.dtb |
| 5 | H96-Max-X3 | S905x3: NETWORK: 1000M / TF: 50Mtz / CPU: 2124Mtz | meson-sm1-h96-max-x3.dtb |
| 6 | H96-Max-X3 | S905x3: NETWORK: 1000M / TF: 50Mtz / CPU: 2208Mtz | meson-sm1-h96-max-x3-oc.dtb |
| 7 | X96-Max-4G | S905x2: NETWORK: 1000M / TF: 50Mtz / CPU: 1944Mtz | meson-g12a-x96-max.dtb |
| 8 | X96-Max-2G | S905x2: NETWORK: 100M  / TF: 50Mtz / CPU: 1944Mtz | meson-g12a-x96-max-rmii.dtb |
| 9 | Octopus-Planet | S912: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-gxm-octopus-planet.dtb |
| 10 | Belink GT-King | S922x: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-g12b-gtking.dtb |
| 11 | Belink GT-King Pro | S922x: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-g12b-gtking-pro.dtb |
| 12 | UGOOS AM6 Plus | S922x: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-g12b-ugoos-am6.dtb |
| 13 | Phicomm-n1 | S905d: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-gxl-s905d-phicomm-n1.dtb |
| 0 | Other | - | Enter the dtb file name of your box |

You can refer to the [dtb library](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb) when you customize the file name.

## Turn on the USB disk boot mode of the s9xxx-boxs

- Open the developer mode: Settings → About this machine → Version number (for example: X96max plus...), click on the version number for 7 times in quick succession, and you will see that the developer mode is turned on.
- Turn on USB debugging: After restarting, enter Settings → System → Advanced options → Developer options again (after entering, confirm that the status is on, and the USB debugging status in the list is also on)
- Boot from USB hard disk: Unplug the power → insert the USB hard disk → insert the thimble into the AV port (top reset button) → insert the power → release the thimble of the av port → the system will boot from the USB hard disk.
- Log in to the system: Connect the computer and the s9xxx box with a network interface → turn off the wireless wifi on the computer → enable the wired connection → manually set the computer ip to the same network segment ip as openwrt, ipaddr such as `192.168.1.2`. The netmask is `255.255.255.0`, and others are not filled in. You can log in to the openwrt system from the browser, Enter OpwnWrt's IP Address: `192.168.1.1`, Account: `root`, Password: `password`, and then log in OpenWrt system.

