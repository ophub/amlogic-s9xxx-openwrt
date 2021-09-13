# 可以安装在 Amlogic S9xxx 系列机顶盒中使用的 OpenWrt 系统

查看英文说明 | [View English description](README.md)

支持github.com一站式完整编译（从自定义软件包进行编译，到打包固件，完全在giuhub.com一站式完成）；支持在自己的仓库进行个性化软件包选择编译，仅单独引入 GitHub Action 进行固件打包；支持从 github.com 的 `Releases` 中使用已有的 `openwrt-armvirt-64-default-rootfs.tar.gz` 文件直接进行固件打包；支持本地化打包（在本地Ubuntu等环境中进行固件打包）。支持的Amlogic S9xxx系列型号有 ***`s905x3, s905x2, s905x, s905w, s905d, s922x, s912`*** 等，例如 ***`Phicomm-N1, Octopus-Planet, X96-Max+, HK1-Box, H96-Max-X3, Belink GT-King, Belink GT-King Pro, UGOOS AM6 Plus, Fiberhome HG680P, ZTE B860H`*** 等机顶盒。

最新的固件可以在 [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases) 中下载。

本仓库的 OpenWrt 固件打包使用了 `Flippy's` 的 Amlogic S9xxx 纯内核包以及安装和升级脚本等众多资源。欢迎你 `Fork` 并进行 [个性化软件包定制](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/router-config/README.cn.md) 。如果对你有用，可以点仓库右上角的 `Star` 表示支持。

## OpenWrt 固件说明

| 型号  | 机顶盒 | OpenWrt固件 |
| ---- | ---- | ---- |
| s905x3 | [X96-Max+](https://tokopedia.link/uMaH09s41db), [HK1-Box](https://tokopedia.link/xhWeQgTuwfb), [H96-Max-X3](https://tokopedia.link/KuWvwoYuwfb), [Ugoos-X3](https://tokopedia.link/duoIXZpdGgb), [X96-Air](https://tokopedia.link/5WHiETbdGgb), [A95XF3-Air](https://tokopedia.link/ByBL45jdGgb) | openwrt_s905x3_k*.img |
| s905x2 | [X96Max-4G](https://tokopedia.link/HcfLaRzjqeb), [X96Max-2G](https://tokopedia.link/HcfLaRzjqeb) | openwrt_s905x2_k*.img |
| s905x | [HG680P](https://tokopedia.link/HbrIbqQcGgb), [B860H](https://tokopedia.link/LC4DiTXtEib) | openwrt_s905x_k*.img |
| s905w | [X96-Mini](https://tokopedia.link/ro207Hsjqeb), [TX3-Mini](https://www.tokopedia.com/beststereo/tanix-tx3-mini-2gb-16gb-android-7-1-kodi-17-3-amlogic-s905w-4k-tv-box) | openwrt_s905w_k*.img |
| s922x | [Belink](https://tokopedia.link/RAgZmOM41db), [Belink-Pro](https://tokopedia.link/sfTHlfS41db), [Ugoos-AM6-Plus](https://tokopedia.link/pHGKXuV41db) | openwrt_s922x_k*.img |
| s912 | [H96-Pro-Plus](https://tokopedia.link/jb42fsBdGgb), Octopus-Planet | openwrt_s912_k*.img |
| s905d | Phicomm-N1 | openwrt_s905d_k*.img |


## 安装及升级 OpenWrt 的相关说明

选择和你的机顶盒型号对应的 OpenWrt 固件，使用 [Rufus](https://rufus.ie/) 或者 [balenaEtcher](https://www.balena.io/etcher/) 等工具将固件写入USB里，然后把写好固件的USB插入机顶盒。

- ### 安装 OpenWrt

从浏览器访问 OpenWrt 的默认 IP: 192.168.1.1 → `使用默认账户登录进入 OpenWrt` → `系统菜单` → `晶晨宝盒` → `安装 OpenWrt`

- ### 升级 OpenWrt 内核

从浏览器访问 OpenWrt 的 IP 如: 192.168.1.1 →  `使用账户登录进入 OpenWrt` → `系统菜单` → `晶晨宝盒` → `升级 OpenWrt`

提示：安装/升级等功能由 [luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) 提供可视化操作支持。也支持[命令操作](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/router-config/README.cn.md#8-安装固件)。

## OpenWrt 固件编译及打包说明

支持多种方式进行固件编译和打包，你可以选择任意一种你喜欢的方式进行使用。

- ### Github.com 一站式编译和打包

你可以通过修改 `router-config` 目录的相关个性化固件配置文件，以及 `.yml` 文件, 自定义和编译适合你的 OpenWrt 固件,  固件可以上传至 github.com 的 `Actions` 和 `Releases` 等处.

1. 你可以在 [router-config](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/router-config/README.cn.md) 中查看个性化固件配置说明。编译流程控制文件是 [.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt-lede.yml) 
2. 在 github.com 的 [Action](https://github.com/ophub/amlogic-s9xxx-openwrt/actions) 选择 ***`Build OpenWrt`*** . 点击 ***`Run workflow`*** 按钮进行固件一站式编译和打包。

```yaml
- name: Build OpenWrt firmware
  id: build
  run: |
    [ -d openwrt-armvirt ] || mkdir -p openwrt-armvirt
    cp -f openwrt/bin/targets/*/*/*.tar.gz openwrt-armvirt/ && sync
    sudo chmod +x make
    sudo ./make -d -b s905x3_s905x2_s905x_s905w_s905d_s922x_s912 -k 5.10.64_5.4.145
    echo "PACKAGED_OUTPUTPATH=${PWD}/out" >> $GITHUB_ENV
    echo "PACKAGED_OUTPUTDATE=$(date +"%Y.%m.%d.%H%M")" >> $GITHUB_ENV
    echo "::set-output name=status::success"
```

输出的变量 ${{ env.PACKAGED_OUTPUTPATH }} 即打包文件所在路径。

- ### 仅单独引入 GitHub Action 进行固件打包

相关代码可以查看 [.yml](https://github.com/ophub/op/blob/main/.github/workflows/build-openwrt-s9xxx.yml)

在你的仓库里，当你完成 ARMv8 类型的 OpenWrt 固件包编译时，可以在流程控制文件 .github/workflows/.yml 中单独引入本仓库的打包脚本进行打包，代码如下:

```yaml
- name: Package Armvirt as OpenWrt
  uses: ophub/amlogic-s9xxx-openwrt@main
  with:
    armvirt64_path: openwrt/bin/targets/*/*/*.tar.gz
    amlogic_openwrt: s905x3_s905x2_s905x_s905w_s905d_s922x_s912
    amlogic_kernel: 5.10.64_5.4.145
    auto_kernel: true
    amlogic_size: 1024
```
- GitHub Action 输入参数说明

| 参数                   | 默认值                  | 说明                                            |
|------------------------|------------------------|------------------------------------------------|
| armvirt64_path         | no                     | 设置 `openwrt-armvirt-64-default-rootfs.tar.gz` 的文件路径，使用文件在当前工作流中的路径如 `openwrt/bin/targets/*/*/*.tar.gz` |
| amlogic_openwrt        | s905d_s905x3           | 设置打包盒子的 `SOC` ，默认 `all` 打包全部盒子，可指定单个盒子如 `s905x3` ，可选择多个盒子用_连接如 `s905x3_s905d` 。各盒子的SoC代码为：`s905x3`, `s905x2`, `s905x`, `s905w`, `s905d`, `s922x`, `s912` |
| amlogic_kernel         | 5.10.64_5.4.145         | 设置内核版本，ophub 的 [kernel](https://github.com/ophub/flippy-kernel/tree/main/library) 库里收藏了众多 Flippy 的原版内核，可以查看并选择指定。 |
| auto_kernel            | true                   | 设置是否自动采用同系列最新版本内核。当为 `true` 时，将自动在内核库中查找在 `amlogic_kernel` 中指定的内核如 5.13.2 的 5.13 同系列是否有更新的版本，如有 5.13.3 及之后的最新版本时，将自动更换为最新版。设置为 `false` 时将编译指定版本内核。默认值：`true` |
| amlogic_size           | 1024                   | 设置固件 ROOT 分区的大小                         |

- GitHub Action 输出变量说明

| 参数                                      | 默认值                  | 说明                       |
|------------------------------------------|-------------------------|---------------------------|
| ${{ env.PACKAGED_OUTPUTPATH }}           | ${PWD}/out              | 打包后的固件所在文件夹的路径  |
| ${{ env.PACKAGED_OUTPUTDATE }}           | 2021.04.21.1058         | 打包日期                   |
| ${{ env.PACKAGED_STATUS }}               | success / failure       | 打包状态。成功 / 失败       |

- 上传固件到 github.com 的 Actions:
 
```yaml
- name: Upload artifact to Actions
  uses: kittaakos/upload-artifact-as-is@master
  with:
    path: ${{ env.PACKAGED_OUTPUTPATH }}/
```

- 上传固件到 github.com 的 Release:

```yaml
- name: Upload OpenWrt Firmware to Release
  uses: softprops/action-gh-release@v1
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  with:
    tag_name: openwrt_s9xxx
    files: ${{ env.PACKAGED_OUTPUTPATH }}/*
    body: |
      This is OpenWrt firmware for Amlogic S9xxx STB.
      More information ...
```

- ### 使用 Github.com 的 Releases 中已有的 rootfs 文件直接进行固件打包

如果你仓库的 [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases) 中已经有 `openwrt-armvirt-64-default-rootfs.tar.gz` 文件，你可以直接进行打包.

- Releases中的 `tag_name` 标签必须以 `openwrt_s9xxx_.*` 的样式进行命名。
- `openwrt-armvirt-64-default-rootfs.tar.gz` 是打包要使用的文件。

相关代码可以查看 [use-releases-file-to-packaging.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/use-releases-file-to-packaging.yml)

```yaml
- name: Build OpenWrt firmware
  id: build
  run: |
    [ -d openwrt-armvirt ] || mkdir -p openwrt-armvirt
    curl -s "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases" | grep -o "openwrt_s9xxx_.*/openwrt-armvirt-.*\.tar.gz" | head -n 1 > DOWNLOAD_URL
    [ -s DOWNLOAD_URL ] && wget -q -P openwrt-armvirt https://github.com/${GITHUB_REPOSITORY}/releases/download/$(cat DOWNLOAD_URL)
    sudo chmod +x make
    sudo ./make -d -b s905x3_s905x2_s905x_s905w_s905d_s922x_s912 -k 5.10.64_5.4.145
    echo "PACKAGED_OUTPUTPATH=${PWD}/out" >> $GITHUB_ENV
    echo "PACKAGED_OUTPUTDATE=$(date +"%Y.%m.%d.%H%M")" >> $GITHUB_ENV
    echo "::set-output name=status::success"
```

这个功能一般用于更换内核快速打包，如果你的仓库中有 `openwrt-armvirt-64-default-rootfs.tar.gz` 文件，你想使用其他内核版本的 OpenWrt 时，就可以直接指定相关内核进行快速打包了，而不用再进行漫长的固件编译等待。仓库里收藏了 `Flippy` 的很多内核 [kernel](https://github.com/ophub/flippy-kernel/tree/main/library) 和 Amlogic 的 dtb 文件 [amlogic-dtb](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb) ，你可以随时调用进行编译。

- ### 本地化打包
1. 安装必要的软件包（如 Ubuntu 20.04 LTS 用户）
```yaml
sudo apt-get update -y
sudo apt-get full-upgrade -y
sudo apt-get install -y $(curl -fsSL git.io/ubuntu-2004-openwrt)
```
2. Clone 仓库到本地 `git clone --depth 1 https://github.com/ophub/amlogic-s9xxx-openwrt.git`
3. 在 `~/amlogic-s9xxx-openwrt` 根目录下创建 `openwrt-armvirt` 文件夹, 并将 `openwrt-armvirt-64-default-rootfs.tar.gz` 文件上传至此目录。
4. 将内核包按对应的版本号命名如 `5.13.2` 放入 `~/amlogic-s9xxx-openwrt/amlogic-s9xxx/amlogic-kernel` 目录下。
5. 在 `~/amlogic-s9xxx-openwrt` 根目录中输入打包命令，如 `sudo ./make` 进行选择设置，打包完成的 OpenWrt 固件放在根目录下的 `out` 文件夹里。

## 打包命令的相关参数说明

- `sudo ./make -d -b s905x3 -k 5.4.145` : 推荐使用. 使用默认配置进行相关内核打包。
- `sudo ./make -d -b s905x3_s905d -k 5.10.64_5.4.145` : 使用默认配置，进行多个内核同时打包。使用 `_` 进行多内核参数连接。
- `sudo ./make -d` : 使用默认配置，使用内核库中的最新内核包，对全部型号的机顶盒进行打包。
- `sudo ./make -d -b s905x3 -k 5.4.145 -s 1024` : 使用默认配置，指定一个内核，一个型号进行打包，固件大小设定为1024M。
- `sudo ./make -d -b s905x3_s905d`  使用默认配置，对多个型号的机顶盒进行全部内核打包, 使用 `_` 进行多型号连接。
- `sudo ./make -d -k 5.10.64_5.4.145` : 使用默认配置，指定多个内核，进行全部型号机顶盒进行打包, 内核包使用 `_` 进行连接。
- `sudo ./make -d -k 5.10.64_5.4.145 -a true` : 使用默认配置，指定多个内核，进行全部型号机顶盒进行打包, 内核包使用 `_` 进行连接。自动升级到同系列最新内核。
- `sudo ./make -d -k latest` : 使用默认配置，最新的内核包，对全部型号的机顶盒进行打包。
- `sudo ./make -d -s 1024 -k 5.4.145` : 使用默认配置，设置固件大小为 1024M, 并指定内核为 5.4.145 ，对全部型号机顶盒进行打包。
- `sudo ./make -h` : 显示帮助文档。
- `sudo ./make` : 如果你对脚本很熟悉，可以在本地编译时，这样进行问答式参数配置。

| 参数 | 含义 | 说明 |
| ---- | ---- | ---- |
| -d | Defaults | 使用默认配置 |
| -b | Build | 指定机顶盒型号，如 `-b s905x3` . 多个型号使用 `_` 进行连接，如 `-b s905x3_s905d` . 可以指定的型号有: `s905x3`, `s905x2`, `s905x`, `s905w`, `s905d`, `s922x`, `s912` |
| -k | Kernel | 指定内核，如 `-k 5.4.145` . 多个内核使用 `_` 进行连接，如 `-k 5.10.64_5.4.145` [kernel](https://github.com/ophub/flippy-kernel/tree/main/library) |
| -a | AutoKernel | 设置是否自动采用同系列最新版本内核。当为 `true` 时，将自动在内核库中查找在 `-k` 中指定的内核如 5.13.2 的 5.13 同系列是否有更新的版本，如有 5.13.3 及之后的最新版本时，将自动更换为最新版。设置为 `false` 时将编译指定版本内核。默认值：`true` |
| -s | Size | 对固件的大小进行设置，默认大小为 1024M, 固件大小必须大于 256M. 例如： `-s 1024` |
| -h | help | 展示帮助文档. |

## ~/openwrt-armvirt/*-rootfs.tar.gz 用于打包的文件编译选项

| Option | Value |
| ---- | ---- |
| Target System | QEMU ARM Virtual Machine |
| Subtarget | QEMU ARMv8 Virtual Machine(cortex-a53) |
| Target Profile | Default |
| Target Images | tar.gz |

更多信息请查阅 [router-config](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/router-config/README.cn.md)

## OpenWrt 固件默认信息

| 名称 | 值 |
| ---- | ---- |
| 默认 IP | 192.168.1.1 |
| 默认账号 | root |
| 默认密码 | password |
| 默认 WIFI 名称 | OpenWrt |
| 默认 WIFI 密码 | none |

## 旁路网关设置

如果你的机顶盒以旁路网关的方式运行，你可以根据需要在防火墙中添加路由规则 (网络 → 防火墙 → 自定义路由规则):

```yaml
iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE        #If the interface is eth0.
iptables -t nat -I POSTROUTING -o br-lan -j MASQUERADE      #If the interface is br-lan bridged.
```

## 鸣谢

- [OpenWrt](https://github.com/openwrt/openwrt)
- [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
- [Lienol/openwrt](https://github.com/Lienol/openwrt)
- [unifreq/openwrt_packit](https://github.com/unifreq/openwrt_packit)

## License

[LICENSE](https://github.com/ophub/op/blob/main/LICENSE) © OPHUB

