# 使用 GitHub Actions 云编译 OpenWrt

查看英文说明 | [View English description](README.md)

使用 GitHub Actions 云编译 OpenWrt 的方法，以及本说明文档中的很多内容，来自 P3TERX, Flippy, tuanqing 等众多技术创新者和资源分享者, 因为众人的奉献，让我们在 Amlogic S9xxx 盒子中使用 OpenWrt 变的如此简单。

Github Actions 是 Microsoft 推出的一项服务，它提供了性能配置非常不错的虚拟服务器环境，基于它可以进行构建、测试、打包、部署项目。对于公开仓库可免费无时间限制地使用，且单次编译时间长达 6 个小时，这对于编译 OpenWrt 来说是够用的（我们一般在3小时左右可以完成一次编译工作）。分享只是为了交流经验，不足的地方请大家理解，请不要在网络上发起各种不好的攻击行为，也不要恶意使用 GitHub Actions。

# 目录

- [使用 GitHub Actions 云编译 OpenWrt](#使用-github-actions-云编译-openwrt)
- [目录](#目录)
  - [1. 注册自己的 Github 的账户](#1-注册自己的-github-的账户)
  - [2. 设置隐私变量 GITHUB_TOKEN](#2-设置隐私变量-github_token)
  - [3. Fork 仓库并设置 RELEASES_TOKEN](#3-fork-仓库并设置-releases_token)
  - [4. 个性化 OpenWrt 固件定制文件说明](#4-个性化-openwrt-固件定制文件说明)
    - [4.1 .config 文件说明](#41-config-文件说明)
      - [4.1.1 首先让固件支持本国语言](#411-首先让固件支持本国语言)
      - [4.1.2 选择个性化软件包](#412-选择个性化软件包)
    - [4.2 DIY脚本操作: diy-part1.sh 和 diy-part2.sh](#42-diy脚本操作-diy-part1sh-和-diy-part2sh)
      - [举例1，添加第三方软件包](#举例1添加第三方软件包)
      - [举例2，用第三方软件包替换当前源码库中的已有的同名软件包](#举例2用第三方软件包替换当前源码库中的已有的同名软件包)
      - [举例3，通过修改源码库中的代码来实现某些需求](#举例3通过修改源码库中的代码来实现某些需求)
  - [5. 编译固件](#5-编译固件)
    - [5.1 手动编译](#51-手动编译)
    - [5.2 定时编译](#52-定时编译)
  - [6. 保存固件](#6-保存固件)
    - [6.1 保存到 Github Actions](#61-保存到-github-actions)
    - [6.2 保存到 GitHub Releases](#62-保存到-github-releases)
    - [6.3 保存到第三方](#63-保存到第三方)
  - [7. 下载固件](#7-下载固件)
    - [7.1 从 Github Actions 下载](#71-从-github-actions-下载)
    - [7.2 从 Github Releases 下载](#72-从-github-releases-下载)
    - [7.3 从第三方下载](#73-从第三方下载)
  - [8. 安装固件](#8-安装固件)
    - [8.1 在编译时集成 luci-app-amlogic 操作面板](#81-在编译时集成-luci-app-amlogic-操作面板)
    - [8.2 使用操作面板安装](#82-使用操作面板安装)
    - [8.3 使用脚本命令安装](#83-使用脚本命令安装)
  - [9. 升级固件](#9-升级固件)
    - [9.1 使用操作面板安装](#91-使用操作面板安装)
    - [9.2 使用升级固件脚本命令安装](#92-使用升级固件脚本命令安装)
    - [9.3 通过升级 OpenWrt 内核进行升级](#93-通过升级-openwrt-内核进行升级)
  - [10. 个性化固件定制晋级教程](#10-个性化固件定制晋级教程)
    - [10.1 认识完整的 .config 文件](#101-认识完整的-config-文件)
    - [10.2 认识 workflow 文件](#102-认识-workflow-文件)
      - [10.2.1 更换编译源码库的地址和分支](#1021-更换编译源码库的地址和分支)
      - [10.2.2 更改盒子的型号和内核版本号](#1022-更改盒子的型号和内核版本号)
    - [10.3 自定义 banner 信息](#103-自定义-banner-信息)
    - [10.4 自定义 feeds 配置文件](#104-自定义-feeds-配置文件)
    - [10.5 自定义软件默认配置信息](#105-自定义软件默认配置信息)
    - [10.6 Opkg 软件包管理](#106-opkg-软件包管理)
    - [10.7 使用 Web 界面管理软件包](#107-使用-web-界面管理软件包)
    - [10.8 如果安装失败并且无法启动时如何救砖](#108-如果安装失败并且无法启动时如何救砖)
    - [10.9 在安装了主线 u-boot 后无法启动](#109-在安装了主线-u-boot-后无法启动)
    - [10.10 设置盒子从 USB/TF/SD 中启动](#1010-设置盒子从-usbtfsd-中启动)

## 1. 注册自己的 Github 的账户

注册自己的账户，以便进行固件个性化定制的继续操作。点击 giuhub.com 网站右上角的 `Sign up` 按钮，根据提示注册自己的账户。

## 2. 设置隐私变量 GITHUB_TOKEN

设置 Github 隐私变量 `GITHUB_TOKEN` 。在固件编译完成后，我们需要上传固件到 Releases ，我们根据 Github 官方的要求设置这个变量，方法如下：
Personal center: Settings > Developer settings > Personal access tokens > Generate new token ( Name: GITHUB_TOKEN, Select: public_repo )。其他选项根据自己需要可以多选。提交保存，复制系统生成的加密 KEY 的值，先保存到自己电脑的记事本，下一步会用到这个值。图示如下：

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418474-85032b00-7a03-11eb-85a2-759b0320cc2a.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418479-8b91a280-7a03-11eb-8383-9d970f4fffb6.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418483-90565680-7a03-11eb-8320-0df1174b0267.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418493-9815fb00-7a03-11eb-862e-deca4a976374.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418485-93514700-7a03-11eb-848d-36de784a4438.jpg width="300" />
</div>

## 3. Fork 仓库并设置 RELEASES_TOKEN

现在可以 Fork 仓库了，打开仓库 https://github.com/ophub/amlogic-s9xxx-openwrt ，点击右上的 Fork 按钮，复制一份仓库代码到自己的账户下，稍等几秒钟，提示 Fork 完成后，到自己的账户下访问自己仓库里的 amlogic-s9xxx-openwrt 。在右上角的 Settings > Secrets > New repostiory secret ( Name: RELEASES_TOKEN, Value: 填写刚才GITHUB_TOKEN的值 )，保存。图示如下：

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418568-0eb2f880-7a04-11eb-81c9-194e32382998.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418571-12467f80-7a04-11eb-878e-012c2ba11772.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418573-15417000-7a04-11eb-97a7-93973d7479c2.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418579-1c687e00-7a04-11eb-9941-3d37be9012ef.jpg width="300" />
</div>

## 4. 个性化 OpenWrt 固件定制文件说明

经过前面 3 步准备工作，现在开始进行个性化固件定制吧。在 [router-config/lede-master](https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/router-config/lede-master) 目录下，除了说明文件外，其他三个是进行 OpenWrt 固件个性化定制的文件。这个章节我们只做最简单的说明，让你一动手就能体验到个性化定制的快乐，比较复杂的定制化操作我放在了第 10 节里，这需要你有一点点基础。

### 4.1 .config 文件说明

这个文件是 OpenWrt 软件包个性化定制的核心文件，包含了全部的配置信息，文件里面每一行代码代表一项个性化配置选项。虽然项目很多，但管理很简单。我们开始动手操作吧。

#### 4.1.1 首先让固件支持本国语言

在# National language packs, luci-i18n-base: 以法国为例，启用法语支持，就把

```yaml
# CONFIG_PACKAGE_luci-i18n-base-fr is not set
```

修改为

```yaml
CONFIG_PACKAGE_luci-i18n-base-fr=y
```

.config 文件里的个性化定制全部这样操作即可。把自己不需要的项目，在行首填写 `#` ，在行尾把 `=y` 改为 `is not set` 。对于自己需要的项目，去掉行首的 `#` ，结尾把 `is not set` 改为 `=y`

#### 4.1.2 选择个性化软件包

在 `#LuCI-app:` 启用和删除默认软件包的做法和上面一样,这次我们删除默认软件包里的 `luci-app-zerotier` 这个插件，就把

```yaml
CONFIG_PACKAGE_luci-app-zerotier=y
```
修改为

```yaml
# CONFIG_PACKAGE_luci-app-zerotier is not set
```

我想你应该已经很明白怎么个性化配置了，.config 文件每行代表一个配置项，都可以使用这样的方法启用或删除固件里的默认配置，这个文件的完整内容有几千行，我提供的只是精简版，如何获得完整配置文件，进行更加复杂的个性化定制，我们放在第 10 节里介绍。

### 4.2 DIY脚本操作: diy-part1.sh 和 diy-part2.sh

脚本 diy-part1.sh 和 diy-part2.sh ，它们分别在更新与安装 feeds 的前后执行，当我们引入 OpenWrt 的源码库进行个性化固件编译时，有时想改写源码库中的部分代码，或者增加一些第三方提供的软件包，删除或者替换源码库中的一些软件包，比如修改默认 IP、主机名、主题、添加 / 删除软件包等操作，这些对源码库的修改指令可以写到这 2 个脚本中。我们以 coolsnowwolf 提供的 OpenWrt 源码库作为编译对象，举几个例子。

我们以下的操作都以这个源码库为基础: [https://github.com/coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)

#### 举例1，添加第三方软件包

第一步，在 diy-part2.sh 里加入以下代码：

```yaml
git clone https://github.com/jerrykuku/luci-app-ttnode.git package/lean/luci-app-ttnode
```

第二步，到 .config 文件里添加这个第三方软件包的启用代码：

```yaml
CONFIG_PACKAGE_luci-app-ttnode=y
```

这样就完成了第三方软件包的集成，扩充了当前源码库中没有的软件包。

#### 举例2，用第三方软件包替换当前源码库中的已有的同名软件包

第一步，在 diy-part2.sh 里加入以下代码：用第一行代码先删除源码库中原来的软件，再用第二行代码引入第三方的同名软件包。

```yaml
rm -rf package/lean/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon
```

第二步，到 .config 文件里添加第三方软件包

```yaml
CONFIG_PACKAGE_luci-theme-argon=y
```

这样就实现了使用第三方软件包替换当前源码库中的已有的同名软件包。

#### 举例3，通过修改源码库中的代码来实现某些需求

我们增加 `luci-app-cpufreq` 对 `aarch64` 的支持，以便在我们的固件中使用（有些修改要谨慎，你必须知道你在做什么）。

源文件地址： [luci-app-cpufreq/Makefile](https://github.com/coolsnowwolf/lede/blob/master/package/lean/luci-app-cpufreq/Makefile) 。修改代码加入对 aarch64 的支持：

```yaml
sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' package/lean/luci-app-cpufreq/Makefile
```

这样就实现了对源码的修改。通过 diy-part1.sh 和 diy-part2.sh 这两个脚本，我们添加了一些操作命令，让编译的固件更符合我们的个性化需求。

## 5. 编译固件

固件编译的流程在 .github/workflows/build-openwrt-lede.yml 文件里控制，在 workflows 目录下还有其他 .yml 文件，实现其他不同的功能。固件编译的方式很多，可以设置定时编译，手动编译，或者设置一些特定事件来触发编译。我们先从简单的操作开始。

### 5.1 手动编译

在自己仓库的导航栏中，点击 Actions 按钮，再依次点击 Build OpenWrt > Run workflow > Run workflow ，开始编译，等待大约 3 个小时，全部流程都结束后就完成编译了。图示如下：

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418662-a0226a80-7a04-11eb-97f6-aeb893336e8c.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418663-a31d5b00-7a04-11eb-8d34-57d430696901.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418666-a7497880-7a04-11eb-9ed0-be738e22f7ae.jpg width="300" />
</div>

### 5.2 定时编译

在 .github/workflows/build-openwrt-lede.yml 文件里，使用 Cron 设置定时编译，5 个不同位置分别代表的意思为 分钟 (0 - 59) / 小时 (0 - 23) / 日期 (1 - 31) / 月份 (1 - 12) / 星期几 (0 - 6)(星期日 - 星期六)。通过修改不同位置的数值来设定时间。系统默认使用 UTC 标准时间，请根据你所在国家时区的不同进行换算。

```yaml
schedule:
  - cron: '0 17 * * *'
```

## 6. 保存固件

固件保存的设置也在 .github/workflows/build-openwrt-lede.yml 文件里控制。我们将编译好的固件通过脚本自动上传到 github 官方提供的 Actions 和 Releases 里面，或者上传到第三方（ 如 WeTransfer ）。

现在 github 里 Actions 的最长保存期是 90 天，Releases 是永久，第三方如 WeTransfer 是 7 天。首先我们感谢这些服务商提供的免费支持，但是也请各位节约使用，我们提倡合理使用免费服务。

### 6.1 保存到 Github Actions

```yaml
- name: Upload artifact to Actions
  uses: kittaakos/upload-artifact-as-is@master
  if: steps.build.outputs.status == 'success' && env.UPLOAD_FIRMWARE == 'true' && !cancelled()
  with:
    path: ${{ env.FILEPATH }}/
```

### 6.2 保存到 GitHub Releases

```yaml
- name: Upload OpenWrt Firmware to Release
  uses: ncipollo/release-action@v1
  if: steps.build.outputs.status == 'success' && env.UPLOAD_RELEASE == 'true' && !cancelled()
  with:
    tag: openwrt_s9xxx_${{ env.FILE_DATE }}
    artifacts: ${{ env.FILEPATH }}/*
    allowUpdates: true
    token: ${{ secrets.GITHUB_TOKEN }}
    body: |
      This is OpenWrt firmware for Amlogic s9xxx tv box
      * Firmware information
      Default IP: 192.168.1.1
      Default username: root
      Default password: password
      Default WIFI name: OpenWrt
      Default WIFI password: none
      Install to EMMC: Login to OpenWrt → System → Amlogic Service → Install OpenWrt
```
### 6.3 保存到第三方

```yaml
- name: Upload OpenWrt Firmware to WeTransfer
  if: steps.build.outputs.status == 'success' && env.UPLOAD_WETRANSFER == 'true' && !cancelled()
  run: |
    curl -fsSL git.io/file-transfer | sh
    ./transfer wet -s -p 16 --no-progress ${{ env.FILEPATH }}/{openwrt_s9xxx_*,openwrt_n1_*} 2>&1 | tee wetransfer.log
    echo "WET_URL=$(cat wetransfer.log | grep https | cut -f3 -d" ")" >> $GITHUB_ENV
```

## 7. 下载固件

下载我们已经编译好并上传至相关存储位置的 OpenWrt 固件。

### 7.1 从 Github Actions 下载

点击仓库导航条里的 Actions 按钮，在 All workflows 列表里，点击已经编译完成的固件列表，在里面的固件列表里，选择和自己盒子型号对应的固件。图示如下：

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418782-08714c00-7a05-11eb-9556-91575640a4bb.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418785-0ad3a600-7a05-11eb-9fdd-519835a14eaa.jpg width="300" />
</div>

### 7.2 从 Github Releases 下载

从仓库首页右下角的 Release 版块进入，选择和自己盒子型号对应的固件。图示如下：

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418828-466e7000-7a05-11eb-8f69-a89a1d158a4b.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418841-55edb900-7a05-11eb-9650-7100ebd6042c.jpg width="300" />
</div>

### 7.3 从第三方下载

在 .github/workflows/build-openwrt-lede.yml 文件里，我们默认关闭了上传至第三方的选项，如果你需要，把 false 改为 ture ，下次编译完成就上传到第三方了。第三方的网址可以在固件编译流程的日志里看到，也可以输出到编译信息里。

```yaml
UPLOAD_COWTRANSFER: false
UPLOAD_WETRANSFER: false
```

上传至第三方的支持来自 https://github.com/Mikubill/transfer ，如果你需要，可以根据他的说明添加更多第三方支持（控制你的创造力，不要浪费太多的免费资源）。图示如下：

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418921-b5e45f80-7a05-11eb-80ba-02edb0698270.jpg width="300" />
</div>

## 8. 安装固件

### 8.1 在编译时集成 luci-app-amlogic 操作面板

1. `svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic`
2. 在执行 `menuconfig` 后，可以选择插件 `LuCI ---> 3. Applications  ---> <*> luci-app-amlogic`

插件的更多说明详见：[https://github.com/ophub/luci-app-amlogic](https://github.com/ophub/luci-app-amlogic)

### 8.2 使用操作面板安装

从浏览器访问 OpenWrt 的默认 IP: 192.168.1.1 → `使用默认账户登录进入 OpenWrt` → `系统菜单` → `晶晨宝盒` → `安装 OpenWrt` 。

### 8.3 使用脚本命令安装

从浏览器访问 OpenWrt 的默认 IP: 192.168.1.1 → `使用默认账户登录进入 openwrt` → `系统菜单` → `TTYD 终端` → 输入写入EMMC的命令: 

```yaml
openwrt-install-amlogic
```

同一个型号的盒子，固件通用，比如 `openwrt_s905x3_v*.img` 固件可以用于 `x96max plus, hk1, h96` 等 `s905x3` 型号的盒子。在安装脚本将 OpenWrt 写入 EMMC 时，会提示你选择自己的盒子，请根据提示正确选择。

除默认的 13 个型号的盒子是自动安装外，当你选择 0 进行自选 .dtb 文件安装时，需要填写具体的 .dtb 文件名称，你可以从这里查阅准确的文件名并填写，具体参见 [amlogic-dtb](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian/amlogic-dtb)

## 9. 升级固件

### 9.1 使用操作面板安装

从浏览器访问 openwrt 系统，在 `系统` 菜单下，选择 `晶晨宝盒`，选择 `升级 OpenWrt 固件` 功能进行升级。（你可以从高版本如 5.15.25 升级到低版本如 5.4.180 ，也可以从低版本如 5.4.180 升级到高版本如 5.15.25 。内核版本号的高低不影响升级，可自由升级/降级）。

### 9.2 使用升级固件脚本命令安装

从浏览器访问 OpenWrt 系统，在 `系统` 菜单下 → `晶晨宝盒` → 上传固件包 ***`openwrt*.img.gz (支持的后缀有: *.img.xz, *.img.gz, *.7z, *.zip)`*** 到默认的上传路径 ***`/mnt/mmcblk*p4/`***, 然后在 `系统菜单` → `TTYD 终端` → 输入升级命令:

```yaml
openwrt-update-amlogic
```

💡提示: 脚本 `openwrt-update-amlogic` 会自动从 `/mnt/mmcblk*p4/` 目录中寻找各种后缀的升级文件，你可以通过晶晨宝盒插件或其他软件将升级固件手动上传至 `/mnt/mmcblk*p4/` 目录下。

如果在 `/mnt/mmcblk*p4/` 目录下仅有一个符合要求的升级文件时，你可以直接运行升级命令 `openwrt-update-amlogic` 进行升级，无需输入固件名称的参数。如果目录中有多个符合要求的可用于升级 OpenWrt 的文件时，请在 `openwrt-update-amlogic` 命令后面空格，并输入 `你指定使用的升级固件`（如 `openwrt-update-amlogic openwrt_s905x3_v5.4.180_2021.03.17.0412.img.gz` ）。

- 脚本  `openwrt-update-amlogic` 在目录中的查找顺序说明

| 目录 | `/mnt/mmcblk*p4/` 1-6 |
| ---- | ---- |
| 顺序 | `你指定使用的升级固件` → `*.img` → `*.img.xz` → `*.img.gz` → `*.7z` → `*.zip` → |

### 9.3 通过升级 OpenWrt 内核进行升级

从浏览器访问 openwrt 系统，在 `系统` 菜单下 → `晶晨宝盒` → 上传内核包 ***`（共有 3 文件：boot-*，dtb-amlogic-*，modules-*）`*** 到默认的上传路径 ***`/mnt/mmcblk*p4/`***, 然后在 `系统菜单` → `TTYD 终端` → 输入内核更换命令:

```yaml
openwrt-kernel
```

💡提示: 脚本会自动从 `/mnt/mmcblk*p4/` 目录中寻找内核文件，你可以通过 `openwrt` → `系统菜单` → `晶晨宝盒` 将内核文件上传到默认的上传路径 `/mnt/mmcblk*p4/` ，也可以借助 WinSCP 等软件将内核文件手动上传至 `/mnt/mmcblk*p4/` 目录下。

更换 OpenWrt 内核仅做了内核替换，固件原本的各种个性化配置均保持不变。是一种最简单的升级方法。支持内核高/低版本自由更换。

## 10. 个性化固件定制晋级教程

如果你把教程看到这个步骤了，我相信你已经知道怎么快乐的玩耍了。但是继续深入的探索下去，将开启一个不平凡的折腾之旅，你将碰到很多的问题，这需要你有不断探索的心理准备，要善于使用搜索引擎解决问题，要花一定的时间去一些 openwrt 社区学习。

### 10.1 认识完整的 .config 文件

使用 openwrt 的官方源码库，或者其他分支的源码库进行一次本地化编译，如选择 https://github.com/coolsnowwolf/lede 的源码库，根据它的编译说明，在本地安装 Ubuntu 系统，部署环境并完成一次本地编译。在本地编译配置界面中，你也可以看到很多丰富的说明，这将加强你对 openwrt 编译过程的理解。

当你在本地完成 openwrt 个性化配置后，保存并退出配置界面，你可以在本地 openwrt 源码库的根目录下找到 .config 文件（ 在代码库的根目录下输入 `ls -a` 命令查看全部隐藏文件），你可以把这个文件直接上传到 github.com 里你的仓库里，替换 router-config/lede-master/.config 这个文件。

### 10.2 认识 workflow 文件

GitHub官方给出了详细的说明，关于 GitHub Actions 的使用方法，你可以从这里开始认识它: [GitHub Actions 快速入门](https://docs.github.com/cn/actions/quickstart)

让我们以现在仓库中正在使用的这个编译流程控制文件为例简单介绍下: [build-openwrt-lede.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt-lede.yml)

#### 10.2.1 更换编译源码库的地址和分支


```yaml
#在第17行: 是指定openwrt编译源码的地址
REPO_URL: https://github.com/coolsnowwolf/lede

#在第18行: 是指定分支的名称
REPO_BRANCH: master
```
你可以修改成其他源码库的地址，如采用官方的源码库，使用其 `openwrt-21.02` 分支:
```yaml
REPO_URL: https://github.com/openwrt/openwrt
REPO_BRANCH: openwrt-21.02
```

#### 10.2.2 更改盒子的型号和内核版本号

在第96行附近, 查找标题为 `Build OpenWrt firmware` 的编译步骤, 其代码块类似这样:
```yaml
    - name: Build OpenWrt firmware
      if: steps.compile.outputs.status == 'success' && env.UPLOAD_FIRMWARE == 'true' && !cancelled()
      id: build
      run: |
        [ -d openwrt-armvirt ] || mkdir -p openwrt-armvirt
        cp -f openwrt/bin/targets/*/*/*.tar.gz openwrt-armvirt/ && sync
        sudo rm -rf openwrt && sync
        sudo rm -rf /workdir && sync
        sudo chmod +x make
        sudo ./make -d -b s905x3_s905x2_s905x_s905d_s922x_s912 -k 5.15.25_5.4.180
        cd out/ && sudo gzip *.img
        cp -f ../openwrt-armvirt/*.tar.gz . && sync
        echo "FILEPATH=$PWD" >> $GITHUB_ENV
        echo "::set-output name=status::success"
```
修改 `-d` 后面的参数为你的盒子的型号。修改 `-k` 的参数为你选择的内核版本号，如: `sudo ./make -d -b s905x -k 5.4.180` 可以指定的参数及更多使用方法详见: [打包命令的相关参数说明](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/README.cn.md#打包命令的相关参数说明)

### 10.3 自定义 banner 信息

默认的 [banner](https://github.com/coolsnowwolf/lede/blob/master/package/base-files/files/etc/banner) 信息如下，你可以修改这个文件来定制专属自己的个性化 banner 信息。将你做好的 banner 文件放入 [etc/banner](../amlogic-s9xxx/common-files/files/etc) 目录，即可在编译时自动替换。

```yaml
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 %D %V, %C
 -----------------------------------------------------
 ```

### 10.4 自定义 feeds 配置文件

当你查看源码库中的 feeds.conf.default 文件时，你是不是发现这里引入了很多软件包的源码库呢，没错，我们在 GitHub 上可以找到 openwrt 官方提供的源码库，还有很多人分享的 openwrt 的分支及软件包，如果你了解他们，可以从这里添加。比如 coolsnowwolf 源码库中的 [feeds.conf.default](https://github.com/coolsnowwolf/lede/blob/master/feeds.conf.default)

### 10.5 自定义软件默认配置信息

我们在使用的 openwrt 的时候，已经对很多软件进行了配置，这些软件的配置信息大部分都保存在了你的 openwrt 的 /etc/config/ 等相关目录下，把这些配置信息的存储文件复制到 GitHub 中仓库根目录下的 files 文件夹中，请保持目录结构和文件名称相同。在 openwrt 编译时，这些配置信息的存储文件将会被编译到你的固件中，具体做法在 .github/workflows/build-openwrt-lede.yml 文件中，让我们在一起看看这段代码吧：

```yaml
- name: Load custom configuration
  run: |
    [ -e files ] && mv files openwrt/files
    [ -e $CONFIG_FILE ] && mv $CONFIG_FILE openwrt/.config
    chmod +x $DIY_P2_SH
    cd openwrt
    $GITHUB_WORKSPACE/$DIY_P2_SH
```

请不要复制那些涉及隐私的配置信息文件，如果你的仓库是公开的，那么你放在 files 目录里的文件也是公开的，千万不要把秘密公开。一些密码等信息，可以使用你刚才在 GitHub Actions 快速上手指南里学习到的私钥设置等方法来加密使用。你一定要了解你在做什么。

### 10.6 Opkg 软件包管理

像大多数 Linux 发行版（ 或移动设备操作系统，例如 Android 或 iOS ）一样，可以通过从软件包存储库（ 本地或 Internet ）下载和安装软件包来升级系统的功能。opkg 实用程序是用于此作业的轻量级软件包管理器。 旨在将软件添加到嵌入式设备的固件中。Opkg 是用于根文件系统的完整软件包管理器，包括内核模块和驱动程序。软件包管理器 opkg 尝试解决存储库中软件包的依赖关系，如果失败，它将报告错误并中止该软件包的安装。第三方软件包可能缺少依赖项，可以从软件包的来源中获得。要忽略依赖项错误，请传递 `--force-depends` 参数。

- 如果您使用的是快照/主干/最新版本，则如果存储库中的软件包所使用的内核版本比您拥有的内核版本新，则安装软件包可能会失败。在这种情况下，您将收到错误消息如`无法满足以下依赖关系……`。对于 OpenWrt 固件的这种用法，强烈建议你在 OpenWrt 固件编译时直接集成你所需要的软件包。

- 非 openwrt.org 官方插件，例如 `luci-app-uugamebooster` ，`luci-app-xlnetacc` 等，需要在固件编译期间直接集成进行编译。这些软件包不能使用 opkg 从镜像服务器直接安装，但是你可以手动上传这些软件包到 openwrt 并使用 opkg 来安装它。

- 在主干/快照上时，内核和kmod软件包被标记为保留，`opkg upgrade` 命令将不会尝试更新它们。

Common commands:
```
opkg update                                       #更新可用的软件包列表
opkg upgrade <pkgs>                               #升级软件包
opkg install <pkgs>                               #安装软件包
opkg install --force-reinstall <pkgs>             #强制重新安装软件包
opkg configure <pkgs>                             #配置未打包的软件包
opkg remove <pkgs | regexp>                       #移除软件包
opkg list                                         #列出可用的软件包
opkg list-installed                               #列出已经安装的软件包
opkg list-upgradable                              #列出已安装和可升级的软件包
opkg list | grep <pkgs>                           #查找与关键字匹配的软件包
```
更多帮助请查阅 [opkg](https://openwrt.org/docs/guide-user/additional-software/opkg)

### 10.7 使用 Web 界面管理软件包

将 OpenWrt 固件安装到设备后，可以通过 WebUI 来安装其他软件包。

1. 登录 OpenWrt → `系统` → `软件包`
2. 点击 `刷新列表` 按钮进行更新
3. 填写 `过滤器` 字段，然后单击 `查找软件包` 按钮以搜索特定的软件包
4. 切换到 `可用软件包` 选项卡以显示可以安装的软件包
5. 切换到 `已安装的软件包` 选项卡以显示和删除已安装的软件包

如果要使用 LuCI 配置服务，请搜索并安装 `luci-app-*` 软件包。

更多帮助请查阅 [packages](https://openwrt.org/packages/start)

### 10.8 如果安装失败并且无法启动时如何救砖

- 一般情况下，重新插入电源，如果可以从 USB 中启动，只要重新安装即可，多试几次。

- 如果接入显示器后，屏幕是黑屏状态，无法从 USB 启动，就需要进行盒子的短接初始化了。先将盒子恢复到原来的安卓系统，再重新刷入 OpenWrt 系统。首先下载 [amlogic_usb_burning_tool](https://github.com/ophub/script/releases/download/dev/amlogic_usb_burning_tool_v3.2.0_and_driver.tar.gz) 系统恢复工具并安装好。

```
以 x96max+ 为例

刷机准备：

1. [ 准备一条 USB 双公头数据线 ]: https://www.ebay.com/itm/152516378334
2. [ 准备一个曲别针 ]: https://www.ebay.com/itm/133577738858
3. [ 下载盒子的 Android TV 固件包 ]: https://xdafirmware.com/x96-max-plus-2
4. [ 在盒子的主板上确认短接点的位置 ]:
   https://user-images.githubusercontent.com/68696949/110590933-67785300-81b3-11eb-9860-986ef35dca7d.jpg

操作方法：

1. 使用 [ USB 双公头数据线 ] 将 [ 盒子 ] 与 [ 电脑 ] 进行连接。
2. 打开刷机软件 USB Burning Tool:
   [ 文件 → 导入固件包 ]: X96Max_Plus2_20191213-1457_ATV9_davietPDA_v1.5.img
   [ 选择 ]：擦除 flash
   [ 选择 ]：擦除 bootloader
   点击 [ 开始 ] 按钮
3. 使用 [ 曲别针 ] 将盒子主板上的 [ 两个短接点进行短接连接 ]。
   如果进度条没有走动，可以尝试插入电源。通长情况下不用电源支持供电，只 USB 双公头的供电即可满足刷机要求。
4. 当看到 [ 进度条开始走动 ] 后，拿走曲别针，不再短接。
5. 当看到 [ 进度条 100% ], 则刷机完成，盒子已经恢复成 Android TV 系统。
   点击 [ 停止 ] 按钮, 拔掉 [ 盒子 ] 和 [ 电脑 ] 之间的 [ USB 双公头数据线] 。
6. 如果以上某个步骤失败，就再来一次，直至成功。
```

当完成恢复出厂设置，盒子已经恢复成 Android TV 系统，其他安装 OpenWrt 系统的操作，就和你之前第一次安装系统时的要求一样了，再来一遍即可。使用写盘软件把 OpenWrt 写入 USB，将写好的 USB 插入盒子，使用牙签等顶住盒子的 AV 孔里的复位键，插入电源，等待 5 秒后松开牙签顶着的复位键，OpenWrt 将从 USB 中启动。

### 10.9 在安装了主线 u-boot 后无法启动

- 极少数设备选择写入主线 `u-boot` 后可能会无法启动，在显示器中看到的提示为 `=>` 符号结尾的一段代码。这时你需要在 TTL 上焊接一个 5-10 K 的上拉或下拉电阻，解决盒子容易受周围电磁信号干扰而导致无法启动的问题，焊接电阻后就可以从 EMMC 启动了。

如果你选择安装了主线 `u-boot` 并且无法启动，请将盒子接入屏幕，查看是否为这样的提示：

```
Net: eth0: ethernet0ff3f0000
Hit any key to stop autoboot: 0
=>
```

如果你的现象如上所示，那么你需要在 TTL 上焊接一个电阻了: [X96 Max Plus's V4.0 主板示意图](https://user-images.githubusercontent.com/68696949/110910162-ec967000-834b-11eb-8fa6-64727ccbe4af.jpg)

```
#######################################################           #####################################################
#                                                     #           #                                                   #
#   上拉电阻: 在 TTL 的 RX 和 GND 之间焊接                #           #   下拉电阻: 在 TTL 的 3.3V 和 RX 之间焊接            #
#                                                     #           #                                                   #
#            3.3V   RX       TX       GND             #     OR    #        3.3V               RX     TX     GND       #
#                    ┖————█████████————┚              #           #         ┖————█████████————┚                       #
#                      上拉电阻（5~10K）                #           #            下拉电阻 (5~10K)                        #
#                                                     #           #                                                   #
#######################################################           #####################################################
```

### 10.10 设置盒子从 USB/TF/SD 中启动

- 把刷好固件的 USB/TF/SD 插入盒子。
- 开启开发者模式: 设置 → 关于本机 → 版本号 (如: X96max plus...), 在版本号上快速连击 5 次鼠标左键, 看到系统显示 `开启开发者模式` 的提示。
- 开启 USB 调试模式: 系统 → 高级选选 → 开发者选项 (设置 `开启USB调试` 为启用)。启用 `ADB` 调试。
- 安装 ADB 工具：下载 [adb](https://github.com/ophub/script/releases/download/dev/adb.tar.gz) 并解压，将 `adb.exe`，`AdbWinApi.dll`，`AdbWinUsbApi.dll` 三个文件拷⻉到 `c://windows/` 目录下的 `system32` 和 `syswow64` 两个文件夹内，然后打开 `cmd` 命令面板，使用 `adb --version` 命令，如果有显示就表示可以使用了。
- 进入 `cmd` 命令模式。输入 `adb connect 192.168.1.137` 命令（其中的 ip 根据你的盒子修改，可以到盒子所接入的路由器设备里查看），如果链接成功会显示 `connected to 192.168.1.137:5555`
- 输入 `adb shell reboot update` 命令，盒子将重启并从你插入的 USB/TF/SD 启动，从浏览器访问固件的 IP 地址，或者 SSH 访问即可进入固件。
- 登录 OpenWrt 系统: 将你的盒子与电脑进行直连 → 关闭电脑的 WIFI 选项，只使用有线网卡 → 将有线网卡的网络设置为和 OpenWrt 相同的网段，如果 OpenWrt 的默认 IP 是: `192.168.1.1` ，你可以设置电脑的 IP 为 `192.168.1.2` ，子网掩码设置为 `255.255.255.0`, 除这 2 个选项外，其他选项不用设置。你就可以从浏览器进入 OpwnWrt 了，默认 IP : `192.168.1.1`, 默认账号: `root`, 默认密码: `password`
