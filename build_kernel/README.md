# Build amlogic-s9xxx kernel for Phicomm-N1 & S905x3-Boxs

If you use Phicomm N1 & S905x3-Boxs to install OpenWrt, you must know ‘Flippy’. He provides many versions of openwrt firmware for Phicomm-N1 & S905x3-Boxs and shares his series of Armbian kernels. If you have heard of ‘Flippy’ for the first time, you can find it through a search engine, E.g: ***` Flippy n1 `***

## Usage

You can install Flippy’s OpenWrt firmware and use it. If you want to define some plug-ins and make your own dedicated op firmware, you can use this script to generate a kernel package adapted to this github source code. You have two ways to get the kernel, one is to use the kernel file provided by Flippy to synthesize ***`(boot-${flippy_version}.tar.gz, dtb-amlogic-${flippy_version}.tar.gz & modules-${flippy_version}.tar.gz)`***, another way is to use the ***`Flippy’s kernel file`*** provided by him to extract. The operation of these two methods is as follows:

The first method: 
```shell script
Example: ~/openwrt-kernel-for-amlogic-s9xxx/build-kernel/
 ├── flippy
 │   ├── N1_Openwrt*.img                   # Recommend Use Flippy's N1_Openwrt.img files
 │   ├── OR: S905x3_Openwrt*.img           # Use Flippy's S905x3_Openwrt*.img files
 │   └── OR: Armbian*Aml-s9xxx*.img        # Use Flippy's Armbian*.img files
 └── make_use_img.sh
```

Put the ***`Flippy’s kernel file`*** E.g: ***`N1_Openwrt*.img`*** file into the ***`${flippy_folder}`*** folder, Modify ${flippy_file} to kernel file name. E.g: ***`flippy_file="N1_Openwrt_R20.10.20_k5.9.5-flippy-48+.img"`***. then run the script:
```shell script
sudo ./make_use_img.sh
```

The second method: 
```shell script
Example: ~/openwrt-kernel-for-amlogic-s9xxx/build-kernel/
 ├── flippy
 │   ├── boot-5.9.5-flippy-48+.tar.gz
 │   ├── dtb-amlogic-5.9.5-flippy-48+.tar.gz
 │   └── modules-5.9.5-flippy-48+.tar.gz
 └── make_use_kernel.sh
```

put ***`boot-${flippy_version}.tar.gz, dtb-amlogic-${flippy_version}.tar.gz & modules-${flippy_version}.tar.gz`*** the three files into the ***`${flippy_folder}`*** folder, Modify ${flippy_version} to kernel version. E.g: ***`flippy_version="5.9.5-flippy-48+"`***. then run the script:
```shell script
sudo ./make_use_kernel.sh
```

The generated files ***` kernel.tar.gz & modules.tar.gz `*** will be directly placed in the kernel directory of this github: ***` ~/openwrt-kernel-for-amlogic-s9xxx/armbian/kernel-amlogic/kernel/${build_save_folder} `***

## Update and supplement dtb file

Update kernel.tar.xz files in the kernel directory with the latest dtb file.
```shell script
sudo ./update_dtb.sh
```

