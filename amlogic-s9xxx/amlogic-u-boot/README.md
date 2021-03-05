# u-boot files of amlogic-s9xxx 5.10 kernel

The amlogic-s9xxx 5.10 kernel version currently does not support writing to EMMC and only supports starting and using in `TF/SD card`. When using the 5.10 kernel version, you need to copy the corresponding `u-boot-*.bin` file to `u-boot.ext` (TF/SD card boot file) and `u-boot.emmc` (EMMC boot file).

## Correspondence between u-boot-*.bin file and amlogic-s9xxx boxes

| Serial | Box | Model | u-boot |
| ---- | ---- | ---- | ---- |
| 1 | X96-Max+ | S905x3 | s905x3-u-boot-510kernel-x96maxplus.bin |
| 2 | HK1-Box | S905x3 | s905x3-u-boot-510kernel-x96maxplus.bin |
| 3 | H96-Max-X3 | S905x3 | s905x3-u-boot-510kernel-x96maxplus.bin |
| 4 | X96-Max-4G | S905x2 | s905x2-u-boot-510kernel-sei510.bin |
| 5 | X96-Max-2G | S905x2 | s905x2-u-boot-510kernel-sei510.bin |
| 6 | Belink GT-King | S922x | s922x-u-boot-510kernel-gtking.bin |
| 7 | Belink GT-King Pro | S922x | s922x-u-boot-510kernel-gtkingpro.bin |
| 8 | UGOOS AM6 Plus | S922x | s922x-u-boot-510kernel-gtkingpro.bin |
| 9 | Fiberhome HG680P | S905x | s905x-u-boot-510kernel-p212.bin |
| 10 | ZTE B860H | S905x | s905x-u-boot-510kernel-p212.bin |
| 11 | Phicomm-n1 | S905d | s905d-u-boot-510kernel-phicommn1.bin |
| 12 | Octopus-Planet | S912 | s912-u-boot-510kernel-octopusplanet.bin |

