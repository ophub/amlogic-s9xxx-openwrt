# Add more kernel for Amlogic S9xxx OpenWrt

View Chinese description  |  [查看中文说明](README.cn.md)

***`Flippy`*** shared many of his kernel packages, let us use OpenWrt in Amlogic S9xxx STB so simple. We have collected a lot of kernel packages, you can check them in the [kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel) directory. If you want to build other kernels that are not in the kernel directory, you can use the [openwrt-kernel](openwrt-kernel) script in the repository to automatically extract and generate them from the Armbian/OpenWrt firmware shared by Flippy. Or put Flippy's original kernel directly into the repository for use.

This repository uses the 3 kernel files provided by Flippy to package the OpenWrt firmware. You can freely choose the kernel you like to use.

## Extract the kernel from Armbian or OpenWrt firmware

```shell script
Example: ~/*/amlogic-s9xxx/amlogic-kernel/build-kernel/
 ├── flippy
 │   ├── S9***_Openwrt*.img            #Support suffix: .img/.7z/.img.xz, Use Flippy's S9***_Openwrt*.img files
 │   └── OR: Armbian*Aml-s9xxx*.img    #Support suffix: .img/.7z/.img.xz, Use Flippy's Armbian*.img files
 └── sudo ./openwrt-kernel -e
```
When you only have Flippy's `Armbian` or `OpenWrt` firmware and no `kernel` file, you can put the firmware shared by `Flippy` into the `~/*/amlogic-s9xxx/amlogic-kernel/build-kernel/flippy` directory and run it directly. Run `sudo ./openwrt-kernel -e` command can automatically complete the kernel extraction and generation, and the generated 3 kernel files (boot-${flippy_version}.tar.gz, dtb-amlogic-${flippy_version}.tar.gz & modules-${flippy_version}.tar.gz) fully implement Flippy's file structure standard, which is exactly the same as its original kernel.

When this script is used in the default path of this repository, the generated files will be automatically saved to the kernel fixed storage directory `~/*/amlogic-s9xxx/amlogic-kernel/kernel`. This script also supports separate copying to any repository, and independent use at any location. The generated folder is named after the kernel version number (for example: 5.4.105) and stored in the same directory of the script.

For the firmware with the same kernel version number, you can select one of them to extract the kernel. The kernels extracted from Armbian and OpenWrt are the same, and the kernels extracted from the OpenWrt firmware used by different Amlogic S9xxx STB are also the same (for example, whether you choose `Armbian_20.10_Aml-s9xxx_buster_5.4.105-flippy-55+o.img.xz`, still choose `openwrt_s905x3_multi_R21.2.1_k5.4.105-flippy-55+o.7z`, or you choose `openwrt_s905d_n1_R21.2.1_k5 4.105-flippy-55+o.7z` Because the kernels of these firmwares are all `5.4.105`, the final extracted kernel is the same).

## Use the original kernel provided by Flippy directly

```shell script
Example: ~/*/amlogic-s9xxx/amlogic-kernel/kernel/
 └── ${kernel_version} (The folder name is created based on the kernel version number)
     ├── boot-5.4.108-flippy-56+o.tar.gz
     ├── dtb-amlogic-5.4.108-flippy-56+o.tar.gz
     └── modules-5.4.108-flippy-56+o.tar.gz
```

A set of Flippy's kernel package consists of 3 files: `boot-${flippy_version}.tar.gz`, `dtb-amlogic-${flippy_version}.tar.gz`, `modules-${flippy_version}.tar .gz`

Put the 3 files of a set of kernel packages shared by `Flippy` directly into the `~/*/amlogic-s9xxx/amlogic-kernel/kernel/` corresponding folder under the directory, without other operations.

