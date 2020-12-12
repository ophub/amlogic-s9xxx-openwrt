# install-program

Install and Upgrading openwrt to the emmc for S9xxx-Boxs and Phicomm-N1.

## Instructions

1. `svn co https://github.com/ophub/amlogic-s9xxx-openwrt/trunk/install-program package/install-program`
2. Execute make `menuconfig` and select `install-program` under `Utilities`

```shell script
Utilities  --->  
   <*> install-program
```
💡Tips: This installation and upgrade script can be introduced and used separately during github.com online compilation. If the firmware in the `openwrt-armvirt` directory you provided does not integrate this installation and upgrade script, ***`Will auto add`*** this function to you through the `./make` script when packaging.

## Install to Phicomm-N1 emmc partition and upgrade instructions

The `n1-v*-openwrt_*.img` firmware supports USB hard disk booting. You can also Install the OpenWrt firmware in the USB hard disk into the EMMC partition of Phicomm N1, and start using it from EMMC.

***`Install OpenWrt`***

Insert the ***`USB hard disk`*** with the written openwrt firmware into the Phicomm N1, and then plug it into the ***`power supply`***. The Phicomm N1 will automatically start the openwrt system from the USB hard disk, wait for about 2 minutes, select ***`OpenWrt`*** in the wireless wifi list of your computer, no password, the computer will automatically obtain the IP, Enter OpwnWrt's IP Address: ***`192.168.1.1`***, Account: ***`root`***, Password: ***`password`***, and then log in OpenWrt system.

- Log in to the default IP: 192.168.1.1 → `Login in to openwrt` → `system menu` → `TTYD terminal` → input command: 
```shell script
n1-install.sh
reboot
```
Wait for the installation to complete. remove the USB hard disk, unplug/plug in the power again, reboot into EMMC.


***`Upgrading OpenWrt`***

Write the new version of the openwrt system to the USB hard drive. ***`Insert the USB hard disk`*** of the openwrt system into the USB port of phicomm-n1 near HDMI. Plug in the power source, the openwrt system in the USB hard disk will be started. Enter OpwnWrt's IP Address: ***`192.168.1.1`***, Account: ***`root`***, Password: ***`password`***, and then log in OpenWrt system, run the upgrade command, and use the system in the USB hard disk to upgrade the system in the EMMC partition in the phicomm-n1 box.

- Log in to the default IP: 192.168.1.1 → `Login in to openwrt` → `system menu` → `TTYD terminal` → input command: 
```shell script
n1-update.sh
reboot
```

If the partition fails and cannot be written, you can restore the bootloader, restart it, and run the relevant command again.
```shell script
dd if=/root/u-boot-2015-phicomm-n1.bin of=/dev/mmcblk1
sync
reboot
```

## Install to S9xxx-Boxs EMMC partition and upgrade instructions

The `s9xxx-v*-openwrt_*.img` and related s9xxx kernel firmware supports USB hard disk booting. You can also Install the OpenWrt firmware in the USB hard disk into the EMMC partition of s9xxx, and start using it from EMMC.

***`Install OpenWrt`***

- Open the developer mode: Settings → About this machine → Version number (for example: X96max plus...), click on the version number for 7 times in quick succession, and you will see that the developer mode is turned on.

- Turn on USB debugging: After restarting, enter Settings → System → Advanced options → Developer options again (after entering, confirm that the status is on, and the USB debugging status in the list is also on)

- Boot from USB hard disk: Unplug the power → insert the USB hard disk → insert the thimble into the AV port (top reset button) → insert the power → release the thimble of the av port → the system will boot from the USB hard disk.

- Log in to the system: Connect the computer and the s9xxx box with a network interface → turn off the wireless wifi on the computer → enable the wired connection → manually set the computer ip to the same network segment ip as openwrt, ipaddr such as ***`192.168.1.2`***. The netmask is ***`255.255.255.0`***, and others are not filled in. You can log in to the openwrt system from the browser, Enter OpwnWrt's IP Address: ***`192.168.1.1`***, Account: ***`root`***, Password: ***`password`***, and then log in OpenWrt system.

- Tips: When booting from USB hard disk, the network card is 100M, and it will automatically become Gigabit after writing into EMMC.

- Log in to the default IP: 192.168.1.1 → `Login in to openwrt` → `system menu` → `TTYD terminal` → input command: 
```shell script
s9xxx-install.sh
reboot
```
***`Upgrading OpenWrt`***

Install Recommended practice: After writing the emmc partition from the USB hard disk, ***`first plug in the original USB hard disk and restart it`*** by unplugging/plugging in the power source until the boot is completed and the default IP: 192.168.1.1 can be accessed. Then unplug the USB hard drive, and officially boot from the EMMC partition by unplugging/plugging in the power source.

- Log in to the default IP: 192.168.1.1 →  `Login in to openwrt` → `system menu` → `file transfer` → upload ***`s9xxx-openwrt.img.gz`*** to ***`/tmp/upload/`***, enter the `system menu` → `TTYD terminal` → input command: 
```shell script
mv -f /tmp/upload/*.img.gz /mnt/mmcblk2p4/
cp -f /usr/bin/s9xxx-update.sh /mnt/mmcblk2p4/
cd /mnt/mmcblk2p4/
gzip -df *.img.gz
s9xxx-update.sh
#s9xxx-update.sh  your_openwrt_imgFileName.img
reboot
```

Tips: If there is only one `.img` file in the ***`/mnt/mmcblk2p4/`*** directory, you can just enter the ***`s9xxx-update.sh`*** command without specifying a specific file name. The upgrade script will vaguely look for `.img` files from the fixed directory and try to upgrade. If there are multiple `.img` files in the ***`/mnt/mmcblk2p4/`*** directory, please use the ***`s9xxx-update.sh your_openwrt_imgFileName.img`*** command to specify the firmware upgrade.

Upgrade Recommended method: After the upgrade is completed, if the system cannot be started, ***`you can plug in the USB hard disk with the openwrt system to boot once`***, until you can access the default IP of the firmware on the USB hard disk. Then unplug the USB hard drive, and officially boot from the emmc partition by unplugging/plugging in the power source.


Write bootloader: If your box is X96-Max+, you must write the bootloader of HK1-Box included in the firmware to EMMC before it can be gigabit. This step is now integrated into the installation script and is automatically completed during installation:

```shell script
dd if=/root/hk1box-bootloader.img  of=/dev/mmcblk2 bs=1 count=442 conv=fsync 2>/dev/null
dd if=/root/hk1box-bootloader.img  of=/dev/mmcblk2 bs=512 skip=1 seek=1 conv=fsync 2>/dev/null
sync
reboot
```

## Option description when installing into s9xxx-boxs emmc

You can refer to the [dtb library](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/armbian/dtb-amlogic) when you customize the file name.

| Serial | Box | Description | DTB |
| ---- | ---- | ---- | ---- |
| 1 | X96-Max+ | S905x3: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-sm1-x96-max-plus.dtb |
| 2 | HK1-Box | S905x3: NETWORK: 1000M / TF: 25Mtz / CPU: 2124Mtz | meson-sm1-hk1box-vontar-x3.dtb |
| 3 | H96-Max-X3 | S905x3: NETWORK: 1000M / TF: 50Mtz / CPU: 2124Mtz | meson-sm1-h96-max-x3.dtb |
| 4 | X96-Max-4G | S905x2: NETWORK: 1000M / TF: 50Mtz / CPU: 1944Mtz | meson-g12a-x96-max.dtb |
| 5 | X96-Max-2G | S905x2: NETWORK: 100M  / TF: 50Mtz / CPU: 1944Mtz | meson-g12a-x96-max-rmii.dtb |
| 6 | X96-Max+ | 905x3: NETWORK: 1000M / TF: 30Mtz / CPU: 2208Mtz | meson-sm1-x96-max-plus-oc.dtb |
| 7 | HK1-Box | S905x3: NETWORK: 1000M / TF: 25Mtz / CPU: 2184Mtz | meson-sm1-hk1box-vontar-x3-oc.dtb |
| 8 | H96-Max-X3 | S905x3: NETWORK: 1000M / TF: 50Mtz / CPU: 2208Mtz | meson-sm1-h96-max-x3-oc.dtb |
| 9 | Octopus-Planet | S905x3: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-gxm-octopus-planet.dtb |
| 10 | Belink GT-King | S922x: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-g12b-gtking.dtb |
| 11 | Belink GT-King Pro | S922x: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-g12b-gtking-pro.dtb |
| 12 | UGOOS AM6 Plus | S922x: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz | meson-g12b-ugoos-am6.dtb |
| 0 | Other | - | Enter the dtb file name of your box |

