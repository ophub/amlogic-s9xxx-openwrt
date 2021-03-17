# 可以安装在Amlogic S9xxx系列机顶盒中使用的OpenWrt系统

查看英文说明 | [View English description](README.md)

支持github.com一站式完整编译（从自定义软件包进行编译，到打包固件，完全在giuhub.com一站式完成）；支持在自己的仓库进行个性化软件包选择编译，仅单独跨仓库引入打包脚本进行固件打包；支持从 github.com 的 `Releases` 中使用已有的 `openwrt-armvirt-64-default-rootfs.tar.gz` 文件直接进行固件打包；支持本地化打包（在本地Ubuntu等环境中进行固件打包）。支持的Amlogic S9xxx系列型号有 ***`S905x3, S905x2, S922x, S905x, S905d, s912`*** 等，例如 ***`Phicomm-N1, Octopus-Planet, X96-Max+, HK1-Box, H96-Max-X3, Belink GT-King, Belink GT-King Pro, UGOOS AM6 Plus, Fiberhome HG680P, ZTE B860H`*** 等机顶盒。

最新的固件可以在 [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases) 中下载。一些重要的更新内容可以在 [ChangeLog.md](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/ChangeLog.md) 中查阅。

本仓库的 OpenWrt 固件打包使用了 ***`Flippy's`*** 的 Amlogic S9xxx 内核，以及安装/升级脚本等众多资源。欢迎你 `Fork` 并进行 [个性化软件包定制](router_config/Documentation.cn.md) 。如果对你有用，可以点仓库右上角的 `Star` 表示支持。

## OpenWrt固件说明

| 型号  | 机顶盒 | OpenWrt固件 |
| ---- | ---- | ---- |
| s905x3 | [x96](https://tokopedia.link/uMaH09s41db), [hk1](https://tokopedia.link/pNHf5AE41db), [h96](https://tokopedia.link/wRh6SVI41db) | openwrt_s905x3_v*.img |
| s905x2 | [x96max4g](https://tokopedia.link/HcfLaRzjqeb), [x96max2g](https://tokopedia.link/ro207Hsjqeb) | openwrt_s905x2_v*.img |
| s905x | [hg680p](https://tokopedia.link/NWF1Skg21db), [b860h](https://tokopedia.link/fp8wG3711db) | openwrt_s905x_v*.img |
| s922x | [belink](https://tokopedia.link/RAgZmOM41db), [belinkpro](https://tokopedia.link/sfTHlfS41db), [ugoos](https://tokopedia.link/pHGKXuV41db) | openwrt_s922x_v*.img |
| s912 | octopus | openwrt_s912_v*.img |
| s905d | n1 | openwrt_s905d_v*.img |

## 写入EMMC及升级系统的相关说明

选择和你的机顶盒型号对应的 OpenWrt 固件，使用 [balenaEtcher](https://www.balena.io/etcher/) 等工具将固件写入USB里，然后把写好固件的USB插入机顶盒。

***`安装 OpenWrt`***

- 从浏览器访问OpenWrt的默认IP: 192.168.1.1 → `使用默认账户登录进入 openwrt` → `系统菜单` → `TTYD 终端` → 输入写入EMMC的命令: 

```yaml
openwrt-install
```
***`升级 OpenWrt`***

- 从浏览器访问OpenWrt的IP如: 192.168.1.1 →  `使用账户登录进入 openwrt` → `系统菜单` → `文件传输` → 上传固件包 ***`openwrt*.img.gz (支持的后缀有: *.img.xz, *.img.gz, *.7z, *.zip)`*** 到默认的上传路径 ***`/tmp/upload/`***, 然后在 `系统菜单` → `TTYD 终端` → 输入升级命令: 

```yaml
openwrt-update
```

更多安装/升级说明详见 [install-program](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/install-program)

## OpenWrt固件编译及打包说明

支持多种方式进行固件编译和打包，你可以选择任意一种你喜欢的方式进行使用。

- ### Github.com 一站式编译和打包

你可以通过修改 `router_config` 目录的相关个性化固件配置文件，以及 `.yml` 文件, 自定义和编译适合你的 OpenWrt 固件,  固件可以上传至 github.com 的 `Actions` 和 `Releases` 等处.

1. 你可以在 [router_config](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/router_config) 目录里进行个性化固件配置. 编译流程控制文件是 [.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt.yml) 
2. 在github.com的 [Action](https://github.com/ophub/amlogic-s9xxx-openwrt/actions) 选择 ***`Build OpenWrt`*** . 点击 ***`Run workflow`*** 按钮进行固件一站式编译和打包。

- ### 仅单独跨仓库引入打包脚本进行固件打包

相关代码可以查看 [.yml](https://github.com/ophub/op/blob/main/.github/workflows/build-openwrt-s9xxx.yml)

在你的仓库里，当你完成 ARMv8 类型的 OpenWrt 固件包编译时，可以在流程控制文件 .github/workflows/.yml 中单独引入本仓库的打包脚本进行打包，代码如下:

```yaml
- name: Build OpenWrt for Amlogic S9xxx STB
  id: build
  run: |
    git clone --depth 1 https://github.com/ophub/amlogic-s9xxx-openwrt.git
    cd amlogic-s9xxx-openwrt/
    [ -d openwrt-armvirt ] || mkdir -p openwrt-armvirt
    cp -f ../openwrt/bin/targets/*/*/*.tar.gz openwrt-armvirt/ && sync
    sudo rm -rf ../openwrt && sync
    sudo rm -rf /workdir && sync
    sudo chmod +x make
    sudo ./make -d -b s905x3_s905x2_s905x_s905d_s922x_s912 -k 5.9.14_5.4.83
    cd out/ && sudo gzip *.img
    cp -f ../openwrt-armvirt/*.tar.gz . && sync
    echo "FILEPATH=$PWD" >> $GITHUB_ENV
    echo "::set-output name=status::success"
```

- 上传固件到github.com的 Actions:
 
```yaml
- name: Upload artifact to Actions
  uses: kittaakos/upload-artifact-as-is@master
  with:
    path: ${{ env.FILEPATH }}/
```

- 上传固件到github.com的 Release:

```yaml
- name: Upload OpenWrt Firmware to Release
  uses: softprops/action-gh-release@v1
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  with:
    tag_name: openwrt_s9xxx
    files: ${{ env.FILEPATH }}/*
    body: |
      This is OpenWrt firmware for Amlogic S9xxx STB.
      More information ...
```

- ### 使用github.com 的 Releases 中已有的 rootfs 文件直接进行固件打包

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
    sudo ./make -d -b s905x3_s905x2_s905x_s905d_s922x_s912 -k 5.9.14_5.4.83
    cd out/ && sudo gzip *.img
    cp -f ../openwrt-armvirt/*.tar.gz . && sync
    echo "FILEPATH=$PWD" >> $GITHUB_ENV
    echo "FILE_DATE=$(date +"%Y.%m.%d.%H%M")" >> $GITHUB_ENV
    echo "::set-output name=status::success"
```

这个功能一般用于更换内核快速打包，如果你的仓库中有 `openwrt-armvirt-64-default-rootfs.tar.gz` 文件，你想使用其他内核版本的 OpenWrt 时，就可以直接指定相关内核进行快速打包了，而不用再进行漫长的固件编译等待。仓库里收藏了 `Flippy` 的很多内核 [kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel) 和 Amlogic 的 dtb 文件 [amlogic-dtb](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb) ，你可以随时调用进行编译。

- ### 本地化打包

1. Clone 仓库到本地 `git clone --depth 1 https://github.com/ophub/amlogic-s9xxx-openwrt.git`
2. 在根目录下创建 `openwrt-armvirt` 文件夹, 并将 `openwrt-armvirt-64-default-rootfs.tar.gz` 文件上传至此目录。
3. 在 `~/amlogic-s9xxx-openwrt` 根目录中输入打包命令，如 `sudo ./make -d -b s905x3_s905d -k 5.4.75_5.9.5` ，打包完成的 OpenWrt 固件放在根目录下的 `out` 文件夹里。

## 打包命令的相关参数说明

- `sudo ./make -d -b s905x3 -k 5.9.5` : 推荐使用. 使用默认配置进行相关内核打包。
- `sudo ./make -d -b s905x3_s905d -k 5.4.75_5.9.5` : 使用默认配置，进行多个内核同时打包。使用 `_` 进行多内核参数连接。
- `sudo ./make -d` : 使用默认配置，使用内核库中的全部内核包 、对全部型号的机顶盒进行打包（这需要很大很大的空间存储全部固件）。
- `sudo ./make -d -b s905x3 -k 5.9.2 -s 1024` : 使用默认配置，指定一个内核，一个型号进行打包，固件大小设定为1024M。
- `sudo ./make -d -b s905x3_s905d`  使用默认配置，对多个型号的机顶盒进行全部内核打包, 使用 `_` 进行多型号连接（要很大空间）。
- `sudo ./make -d -k 5.4.73_5.9.2` : 使用默认配置，指定多个内核，进行全部型号机顶盒进行打包, 内核包使用 `_` 进行连接。
- `sudo ./make -d -k latest` : 使用默认配置，最新的内核包，对全部型号的机顶盒进行打包。
- `sudo ./make -d -s 1024 -k 5.7.15` : 使用默认配置，设置固件大小为 1024M, 并指定内核为 5.7.15 ，对全部型号机顶盒进行打包。
- `sudo ./make -h` : 显示帮助文档。
- `sudo ./make` : 如果你对脚本很熟悉，可以在本地编译时，这样进行问答式参数配置。

| 参数 | 含义 | 说明 |
| ---- | ---- | ---- |
| -d | Defaults | 使用默认配置 |
| -b | Build | 指定机顶盒型号，如 `-b s905x3` . 多个型号使用 `_` 进行连接，如 `-b s905x3_s905d` . 可以指定的型号有: `s905x3`, `s905x2`, `s905x`, `s905d`, `s922x`, `s912` |
| -k | Kernel | 指定内核，如 `-k 5.4.50` . 多个内核使用 `_` 进行连接，如 `-k 5.4.50_5.9.5` 内核库请查阅 [kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel) |
| -s | Size | 对固件的大小进行设置，默认大小为 1024M, 固件大小必须大于 256M. 例如： `-s 1024` |
| -h | help | 展示帮助文档. |

## 构建更多内核包

***`Flippy`*** 分享了他的众多内核包，让我们在 Amlogic S9xxx 机顶盒中使用 OpenWrt 变的如此简单。我们珍藏了很多内核包，你可以在 [kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/kernel) 目录里查阅。如果你想构建内核目录里没有的其他内核，可以使用仓库提供的工具，从 Flippy 分享的 Armbian/OpenWrt/Kernel 等资源中进行自动提取和生成。相关工具见 [build_kernel](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-kernel/build_kernel)

## ~/openwrt-armvirt/* 用于打包的文件编译选项

| Option | Value |
| ---- | ---- |
| Target System | QEMU ARM Virtual Machine |
| Subtarget | QEMU ARMv8 Virtual Machine(cortex-a53) |
| Target Profile | Default |
| Target Images | squashfs |

更多信息请查阅 [router_config](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/router_config)

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
- Flippy: 让 OpenWrt 可以在 Amlogic s9xxx 系列机顶盒中运行的技术创新人才、伟大的贡献者。
- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [tuanqing/mknop](https://github.com/tuanqing/mknop)
- [Mikubill/transfer](https://github.com/Mikubill/transfer)

## License

[LICENSE](https://github.com/ophub/op/blob/main/LICENSE) © OPHUB

