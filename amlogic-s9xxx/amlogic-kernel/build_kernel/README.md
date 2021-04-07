# Build kernel for Amlogic S9xxx STB

View Chinese description  |  [查看中文说明](README.cn.md)

You can install `Flippy’s` OpenWrt firmware and use it. If you want to define some plug-ins and make your own dedicated OpenWrt firmware, you can use this script to generate a kernel package adapted to this github source code. You have two ways to get the kernel, one is to use the ***`Flippy’s *.img file`*** provided by him to extract. another way is to use the kernel files provided by Flippy to synthesize ***`(boot-${flippy_version}.tar.gz, dtb-amlogic-${flippy_version}.tar.gz & modules-${flippy_version}.tar.gz)`***. The operation of these two methods is as follows:

The first method: 
```shell script
Example: ~/*/amlogic-s9xxx/amlogic-kernel/build-kernel/
 ├── flippy
 │   ├── N1_Openwrt*.img               #Support suffix: .img/.7z/.img.xz, Use Flippy's N1_Openwrt.img files
 │   ├── OR: S9***_Openwrt*.img        #Support suffix: .img/.7z/.img.xz, Use Flippy's S9***_Openwrt*.img files
 │   └── OR: Armbian*Aml-s9xxx*.img    #Support suffix: .img/.7z/.img.xz, Use Flippy's Armbian*.img files
 └── make_use_img.sh
```

Put the ***`Flippy’s *.img file`*** E.g: ***`N1_Openwrt*.img`*** file into the ***`${flippy_folder}`*** folder, Modify ${flippy_file} to kernel file name. E.g: ***`flippy_file="N1_Openwrt_R20.10.20_k5.9.5-flippy-48+.img"`***. ( If the file of ${flippy_file} is not found, Will search for other *.img and *.img.xz files in the ${flippy_folder} directory. ) then run the script:
```shell script
cd build-kernel/
sudo ./make_use_img.sh
```

The second method: 
```shell script
Example: ~/*/amlogic-s9xxx/amlogic-kernel/build-kernel/
 ├── flippy
 │   ├── boot-5.9.5-flippy-48+.tar.gz
 │   ├── dtb-amlogic-5.9.5-flippy-48+.tar.gz
 │   └── modules-5.9.5-flippy-48+.tar.gz
 └── make_use_kernel.sh
```

put ***`boot-${flippy_version}.tar.gz, dtb-amlogic-${flippy_version}.tar.gz & modules-${flippy_version}.tar.gz`*** the three files into the ***`${flippy_folder}`*** folder, Modify ${flippy_version} to kernel version. E.g: ***`flippy_version="5.9.5-flippy-48+"`***. ( If the files of ${flippy_version} is not found, Will search for other files in the ${flippy_folder} directory. ) then run the script:
```shell script
cd build-kernel/
sudo ./make_use_kernel.sh
```

The generated files ***` kernel.tar.xz & modules.tar.xz `*** will be directly placed in the kernel directory of this github: ***` ~/amlogic-s9xxx/amlogic-kernel/kernel/${build_save_folder} `***

The third method: 
```shell script
Example: ~/*/amlogic-s9xxx/amlogic-kernel/kernel/
 └── 5.4.108 (The directory name is created based on the kernel version number)
     ├── boot-5.4.108-flippy-56+o.tar.gz
     ├── dtb-amlogic-5.4.108-flippy-56+o.tar.gz
     └── modules-5.4.108-flippy-56+o.tar.gz
```

A set of Flippy's kernel package consists of 3 files: `boot-${flippy_version}.tar.gz`, `dtb-amlogic-${flippy_version}.tar.gz`, `modules-${flippy_version}.tar .gz`

Put the 3 files of a set of kernel packages shared by `Flippy` directly into the `~/*/amlogic-s9xxx/amlogic-kernel/kernel/5.4.108 (directory name is created according to the kernel version number)` directory, without other operations, you can directly use the packaging script for OpenWrt production, such as: `sudo ./make -d -b s905d_s905x3 -k 5.4.108`

If you store 2 kernel packages (kernel.tar.xz and modules.tar.xz) reorganized using the repository kernel packaging script in the kernel directory, and at the same time store 3 original kernel files of Flippy (boot-*, dtb) -amlogic-*, modules-*), then when using `sudo ./make -d -b s905d_s905x3 -k 5.4.108` script packaging, `kernel.tar.xz` and `modules.tar.xz` will be used first. If you don't need to add or modify the 3 kernel files, such as add .dtb files, it is recommended that you directly use the 3 kernel files by Flippy. For example [5.4.108](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel/5.4.108)

## Update and supplement dtb file

Thanks for the `Flippy's` continuous research, `OpenWrt` can be installed and used in more boxes, but these latest .dtb files are not in the old version of the kernel package, you can use the latest version of [the .dtb file library](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb) in the repository to update the previous kernel package. Update `kernel.tar.xz` files in the [kernel directory](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel) with the latest .dtb file.

```shell script
Example: ~/*/amlogic-s9xxx/
 ├── amlogic-dtb
 │   └── *.dtb
 └── amlogic-kernel
     └── build_kernel
         └── update_dtb.sh
```

```shell script
cd build-kernel/
sudo ./update_dtb.sh
```
