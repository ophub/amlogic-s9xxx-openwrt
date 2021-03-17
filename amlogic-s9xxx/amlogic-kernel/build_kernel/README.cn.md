# 构建 Amlogic S9xxx 系列机顶盒中 OpenWrt 使用的内核

查看英文说明 | [View English description](README.md)

***`Flippy`*** 分享了他的众多内核包，让我们在 Amlogic S9xxx 机顶盒中使用 OpenWrt 变的如此简单。我们珍藏了很多内核包，你可以在 [kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel) 目录里查阅。如果你想构建内核目录里没有的其他内核，可以使用仓库提供的工具，从 Flippy 分享的 Armbian/OpenWrt/Kernel 等资源中进行自动提取和生成。相关工具见 [build_kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/build_kernel) 。现将几种方法介绍如下：

第一种方法: 

```shell script
Example: ~/*/amlogic-s9xxx/amlogic-kernel/build-kernel/
 ├── flippy
 │   ├── N1_Openwrt*.img               #Support suffix: .img/.7z/.img.xz, Use Flippy's N1_Openwrt.img files
 │   ├── OR: S9***_Openwrt*.img        #Support suffix: .img/.7z/.img.xz, Use Flippy's S9***_Openwrt*.img files
 │   └── OR: Armbian*Aml-s9xxx*.img    #Support suffix: .img/.7z/.img.xz, Use Flippy's Armbian*.img files
 └── make_use_img.sh
```

将 `Flippy` 分享的 Armbian 或 OpenWrt 固件放入 `~/*/amlogic-s9xxx/amlogic-kernel/build-kernel/flippy` 目录下，直接运行 `make_use_img.sh` 命令即可自动完成内核提取和生成，内核文件将自动保存在固定存放目录 `~/*/amlogic-s9xxx/amlogic-kernel/kernel` 中。

相同内核版本的固件包，任选一个放入即可，从 Armbian 及 OpenWrt 提取的内核是一样的，各种 OpenWrt 型号提取的结果也是一样的（例如无论你选择的是 `Armbian_20.10_Aml-s9xxx_buster_5.4.105-flippy-55+o.img.xz` ，还是选择了 `openwrt_s905x3_multi_R21.2.1_k5.4.105-flippy-55+o.7z` ，或者你选择了 `openwrt_s905d_n1_R21.2.1_k5.4.105-flippy-55+o.7z` 因为这几个固件的内核都是 `5.4.105` ，所以最终提取的内核是一样的）。

如果你在 `build-kernel/flippy` 目录下有多个 Flippy 的固件，那么你要手动修改下 `make_use_img.sh` 文件，在里面的 `flippy_file="N1_Openwrt_R20.10.20_k5.9.5-flippy-48+.img"` 处，修改为你这次要提取的固件包的名称。如果此目录下只有一个 Flippy 的固件包，直接运行 `make_use_img.sh` 命令即可，无需修改脚本文件，脚本将会在此目录下自动模糊查找并自动匹配这个文件并进行内核提取制作，内核提取脚本会自动解压缩，支持的后缀格式有 `.7z/.img.xz/.img` 。推荐你一次在 `build-kernel/flippy` 目录 中只放入一个文件进行内核提取制作，这样省去了修改  `make_use_img.sh` 的步骤，提取完一个再放入另一个，逐个放入进行内核提取制作。

```shell script
cd build-kernel/
sudo ./make_use_img.sh
```

第二种方法: 

```shell script
Example: ~/*/amlogic-s9xxx/amlogic-kernel/build-kernel/
 ├── flippy
 │   ├── boot-5.9.5-flippy-48+.tar.gz
 │   ├── dtb-amlogic-5.9.5-flippy-48+.tar.gz
 │   └── modules-5.9.5-flippy-48+.tar.gz
 └── make_use_kernel.sh
```

Flippy 的一套内核包由 3 个文件共同组成： `boot-${flippy_version}.tar.gz`, `dtb-amlogic-${flippy_version}.tar.gz`, `modules-${flippy_version}.tar.gz`

将 `Flippy` 分享的一套内核包的 3 个文件放入 `~/*/amlogic-s9xxx/amlogic-kernel/build-kernel/flippy` 目录下，直接运行 `make_use_kernel.sh` 命令即可自动完成内核提取和生成，内核文件将自动保存在内核文件存放的固定目录 `~/*/amlogic-s9xxx/amlogic-kernel/kernel` 中。

如果你在 `build-kernel/flippy` 目录下有多套内核包，那么你要手动修改下 `make_use_kernel.sh` 文件，在里面的 `flippy_version="5.9.5-flippy-48+"` 处，修改为你这次要提取的内核版本号。如果此目录下只有一套内核包（ 3个内核文件是一套 ），直接运行 `make_use_kernel.sh` 命令即可，无需修改脚本文件，脚本将会在此目录下自动模糊查找并自动匹配这套内核并进行内核提取制作，内核提取脚本会自动解压缩，支持的后缀格式为 `.tar.gz` 。推荐你一次在 `build-kernel/flippy` 目录 中只放入一套内核包进行内核提取制作，这样省去了修改  `make_use_kernel.sh` 的步骤，提取完一套再放入另一套，逐套放入进行内核提取制作。

```shell script
cd build-kernel/
sudo ./make_use_kernel.sh
```

## 更新内核库中的已有文件

随着 `Flippy` 的不断创新，更多的机顶盒纳入了可使用范围，当有新机型出现时，原内核包中可能缺少这款机顶盒的 [.dtb](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb) 文件，这时我们需要对已有的内核包进行批量更新了。运行 `update_dtb.sh` 命令可以对已有内核包统一批量更新。在执行更新命令时会提示你选择更新对象，可以单独升级 `kernel.tar.xz` 或 `modules.tar.xz` 文件，也可以一次全部进行更新。内核更新脚本同样适用于给现有的内核包统一添加 WIFI 驱动等其他更新操作。更新完成的内核包会自动覆盖回原路径 [kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel)

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
