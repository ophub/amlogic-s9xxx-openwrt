# 使用 GitHub Actions 云编译 OpenWrt

查看英文说明 | [View English description](README.md)

使用 GitHub Actions 云编译 OpenWrt 的方法，以及本说明文档中的很多内容，来自 P3TERX, Flippy, tuanqing 等众多技术创新者和资源分享者, 因为众人的奉献，让我们在 Amlogic S9xxx 机顶盒中使用 OpenWrt 变的如此简单。

Github Actions 是 Microsoft 推出的一项服务，它提供了性能配置非常不错的虚拟服务器环境，基于它可以进行构建、测试、打包、部署项目。对于公开仓库可免费无时间限制地使用，且单次编译时间长达 6 个小时，这对于编译 OpenWrt 来说是够用的（我们一般在3小时左右可以完成一次编译工作）。分享只是为了交流经验，不足的地方请大家理解，请不要在网络上发起各种不好的攻击行为，也不要恶意使用 GitHub Actions。

# 目录

1. [注册自己的 Github 的账户](#1-注册自己的-github-的账户)
2. [设置隐私变量 GITHUB_TOKEN](#2-设置隐私变量-github_token)
3. [Fork 仓库并设置 RELEASES_TOKEN](#3-fork-仓库并设置-releases_token)
4. [个性化 OpenWrt 固件定制文件说明](#4-个性化-openwrt-固件定制文件说明)
    - 4.1 [.config 文件说明](#41-config-文件说明)
        - 4.1.1 [首先让固件支持本国语言](#411-首先让固件支持本国语言)
        - 4.1.2 [选择个性化软件包](#412-选择个性化软件包)
    - 4.2 [DIY脚本操作: diy-part1.sh 和 diy-part2.sh](#42-diy脚本操作-diy-part1sh-和-diy-part2sh)
        - 4.2.1 [举例1，添加第三方软件包](#举例1添加第三方软件包)
        - 4.2.2 [举例2，用第三方软件包替换当前源码库中的已有的同名软件包](#举例2用第三方软件包替换当前源码库中的已有的同名软件包)
        - 4.2.3 [举例3，通过修改源码库中的代码来实现某些需求](#举例3通过修改源码库中的代码来实现某些需求)
5. [编译固件](#5-编译固件)
    - 5.1 [手动编译](#51-手动编译)
    - 5.2 [定时编译](#52-定时编译)
6. [保存固件](#6-保存固件)
    - 6.1 [保存到 Github Actions](#61-保存到-github-actions)
    - 6.2 [保存到 GitHub Releases](#62-保存到-github-releases)
    - 6.3 [保存到第三方](#63-保存到第三方)
7. [下载固件](#7-下载固件)
    - 7.1 [从 Github Actions 下载](#71-从-github-actions-下载)
    - 7.2 [从 Github Releases 下载](#72-从-github-releases-下载)
    - 7.3 [从第三方下载](#73-从第三方下载)
8. [安装固件](#8-安装固件)
9. [升级固件](#9-升级固件)
10. [个性化固件定制晋级教程](#10-个性化固件定制晋级教程)
    - 10.1 [认识完整的 .config 文件](#101-认识完整的-config-文件)
    - 10.2 [认识 workflow 文件](#102-认识-workflow-文件)
    - 10.3 [使用 SSH 远程连接 GitHub Actions 进行个性化配置](#103-使用-ssh-远程连接-github-actions-进行个性化配置)
    - 10.4 [自定义 feeds 配置文件](#104-自定义-feeds-配置文件)
    - 10.5 [自定义软件默认配置信息](#105-自定义软件默认配置信息)
    - 10.6 [Opkg 软件包管理](#106-opkg-软件包管理)
    - 10.7 [使用 Web 界面管理软件包](#107-使用-Web-界面管理软件包)
    - 10.8 [如果安装失败并且无法启动时如何救砖](#108-如果安装失败并且无法启动时如何救砖)

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

经过前面 3 步准备工作，现在开始进行个性化固件定制吧。在 /router_config 目录下，除了说明文件外，其他三个是进行 OpenWrt 固件个性化定制的文件。这个章节我们只做最简单的说明，让你一动手就能体验到个性化定制的快乐，比较复杂的定制化操作我放在了第 10 节里，这需要你有一点点基础。

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

固件编译的流程在 .github/workflows/build-openwrt.yml 文件里控制，在 workflows 目录下还有其他 .yml 文件，实现其他不同的功能。固件编译的方式很多，可以设置定时编译，手动编译，或者设置一些特定事件来触发编译。我们先从简单的操作开始。

### 5.1 手动编译

在自己仓库的导航栏中，点击 Actions 按钮，再依次点击 Build OpenWrt > Run workflow > Run workflow ，开始编译，等待大约 3 个小时，全部流程都结束后就完成编译了。图示如下：

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418662-a0226a80-7a04-11eb-97f6-aeb893336e8c.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418663-a31d5b00-7a04-11eb-8d34-57d430696901.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418666-a7497880-7a04-11eb-9ed0-be738e22f7ae.jpg width="300" />
</div>

### 5.2 定时编译

在 .github/workflows/build-openwrt.yml 文件里，使用 Cron 设置定时编译，5 个不同位置分别代表的意思为 分钟 (0 - 59) / 小时 (0 - 23) / 日期 (1 - 31) / 月份 (1 - 12) / 星期几 (0 - 6)(星期日 - 星期六)。通过修改不同位置的数值来设定时间。系统默认使用 UTC 标准时间，请根据你所在国家时区的不同进行换算。

```yaml
schedule:
  - cron: '0 17 * * *'
```

## 6. 保存固件

固件保存的设置也在 .github/workflows/build-openwrt.yml 文件里控制。我们将编译好的固件通过脚本自动上传到 github 官方提供的 Actions 和 Releases 里面，或者上传到第三方（ 如 WeTransfer ）。

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
  uses: softprops/action-gh-release@v1
  if: steps.build.outputs.status == 'success' && env.UPLOAD_RELEASE == 'true' && !cancelled()
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  with:
    tag_name: openwrt_s9xxx_${{ env.FILE_DATE }}
    files: ${{ env.FILEPATH }}/*
    body: |
      This is OpenWrt firmware for Amlogic S9xxx STB
      * Firmware information
      Default IP: 192.168.1.1
      Default username: root
      Default password: password
      Default WIFI name: OpenWrt
      Default WIFI password: none
      Install command: openwrt-install
      Update command: openwrt-update
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

点击仓库导航条里的 Actions 按钮，在 All workflows 列表里，点击已经编译完成的固件列表，在里面的固件列表里，选择和自己机顶盒型号对应的固件。图示如下：

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418782-08714c00-7a05-11eb-9556-91575640a4bb.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418785-0ad3a600-7a05-11eb-9fdd-519835a14eaa.jpg width="300" />
</div>

### 7.2 从 Github Releases 下载

从仓库首页右下角的 Release 版块进入，选择和自己机顶盒型号对应的固件。图示如下：

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418828-466e7000-7a05-11eb-8f69-a89a1d158a4b.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418841-55edb900-7a05-11eb-9650-7100ebd6042c.jpg width="300" />
</div>

### 7.3 从第三方下载

在 .github/workflows/build-openwrt.yml 文件里，我们默认关闭了上传至第三方的选项，如果你需要，把 false 改为 ture ，下次编译完成就上传到第三方了。第三方的网址可以在固件编译流程的日志里看到，也可以输出到编译信息里。

```yaml
UPLOAD_COWTRANSFER: false
UPLOAD_WETRANSFER: false
```

上传至第三方的支持来自 https://github.com/Mikubill/transfer ，如果你需要，可以根据他的说明添加更多第三方支持（控制你的创造力，不要浪费太多的免费资源）。图示如下：

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418921-b5e45f80-7a05-11eb-80ba-02edb0698270.jpg width="300" />
</div>

## 8. 安装固件

在浏览器中输入 `192.168.1.1` 访问 openwrt ，默认的用户名是 `root` ，默认的密码是 `password` ，登录后，在系统菜单下，选择 `TTYD 终端` ，进来直接输入 `openwrt-install` 命令进行安装。更多的详细操作，可以在仓库的安装详细说明中查看： [install-program](https://github.com/ophub/amlogic-s9xxx-OpenWrt/tree/main/amlogic-s9xxx/install-program)

## 9. 升级固件

登录你的 openwrt 系统，在 `系统` 菜单下，选择 `文件传输` 功能上传固件，稍等片刻，看到系统提示上传完成后，选择 `TTYD 终端` 菜单，输入 `openwrt-update` 命令升级。（你可以从高版本如 5.40 升级到低版本如 5.30 ，也可以从低版本如 5.91 升级到高版本如 5.96 。内核版本号的高低不影响升级，可自由升级/降级）。更多的详细操作，可以在仓库的升级详细说明中查看： [install-program](https://github.com/ophub/amlogic-s9xxx-OpenWrt/tree/main/amlogic-s9xxx/install-program)

## 10. 个性化固件定制晋级教程

如果你把教程看到这个步骤了，我相信你已经知道怎么快乐的玩耍了。但是继续深入的探索下去，将开启一个不平凡的折腾之旅，你将碰到很多的问题，这需要你有不断探索的心理准备，要善于使用搜索引擎解决问题，要花一定的时间去一些 openwrt 社区学习。

### 10.1 认识完整的 .config 文件

使用 openwrt 的官方源码库，或者其他分支的源码库进行一次本地化编译，如选择 https://github.com/coolsnowwolf/lede 的源码库，根据它的编译说明，在本地安装 Ubuntu 系统，部署环境并完成一次本地编译。在本地编译配置界面中，你也可以看到很多丰富的说明，这将加强你对 openwrt 编译过程的理解。

当你在本地完成 openwrt 个性化配置后，保存并退出配置界面，你可以在本地 openwrt 源码库的根目录下找到 .config 文件（ 在代码库的根目录下输入 `ls -a` 命令查看全部隐藏文件），你可以把这个文件直接上传到 github.com 里你的仓库里，替换 router_config/.config 这个文件。

### 10.2 认识 workflow 文件

GitHub官方给出了详细的说明，关于 GitHub Actions 的使用方法，你可以从这里开始认识它: [GitHub Actions 快速入门](https://docs.github.com/cn/actions/quickstart)

### 10.3 使用 SSH 远程连接 GitHub Actions 进行个性化配置

你在 10.1 中进行了本地化编译，对相关的交互界面有了一定的认识，这个经验非常有用，以后你可以在 GitHub Actions 的云编译中实现和本地化一样的操作。

在手动启动 GitHub Actions 固件编译时，把 `SSH connection to Actions` 的值由默认的 `false` 改为 `true` ，然后在工作流中等待大约 10 分钟，当编译进程完成前面几步到达 `SSH connection to Actions` 这个步骤时，从运行日志中可以看到绿色的 SSH 远程连接命令和浏览器访问网址，推荐复制绿色的 SSH 远程连接命令，在 SSH 运行终端里黏贴命令并回车，根据提示按 `q` 键进入控制面板，输入 `cd openwrt && make menuconfig` 命令进入 openwrt 个性化配置选项面板，完成各种操作后保存退出，按 `ctrl + d` 退出 SSH 远程连接进程，让GitHub Actions继续编译。

SSH操作时，复制 `ssh ...io` 这部分绿色的 SSH 远程连接命令。MAC 电脑可以直接使用系统自带的终端。如果你有正在运行状态的 openwrt ，可以使用它系统菜单下的 `TTYD 终端` 。如果你的电脑安装了 SecureCRT 或者 PuTTY 等软件，可以使用任意一款支持 SSH 协议的软件。

如果你没有任何 SSH 终端，你可以复制绿色网址下面的 `https://tma...` 的网址，在浏览器中打开，根据提示输入的命令和在终端中一样。在浏览器中操作时响应速度可能比在支持 SSH 协议的软件里使用要慢一点。图示如下：

<div style="width:100%;margin-top:40px;margin:5px;">
<img src=https://user-images.githubusercontent.com/68696949/109418960-e1ffe080-7a05-11eb-94f6-2c9bd8f5481c.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418962-e4fad100-7a05-11eb-87af-e924d4ff3da6.jpg width="300" />
<img src=https://user-images.githubusercontent.com/68696949/109418965-e926ee80-7a05-11eb-8f25-4443b9f845f7.jpg width="300" />
</div>

### 10.4 自定义 feeds 配置文件

当你查看源码库中的 feeds.conf.default 文件时，你是不是发现这里引入了很多软件包的源码库呢，没错，我们在 GitHub 上可以找到 openwrt 官方提供的源码库，还有很多人分享的 openwrt 的分支及软件包，如果你了解他们，可以从这里添加。比如 coolsnowwolf 源码库中的 [feeds.conf.default](https://github.com/coolsnowwolf/lede/blob/master/feeds.conf.default)

### 10.5 自定义软件默认配置信息

我们在使用的 openwrt 的时候，已经对很多软件进行了配置，这些软件的配置信息大部分都保存在了你的 openwrt 的 /etc/config/ 等相关目录下，把这些配置信息的存储文件复制到 GitHub 中仓库根目录下的 files 文件夹中，请保持目录结构和文件名称相同。在 openwrt 编译时，这些配置信息的存储文件将会被编译到你的固件中，具体做法在 .github/workflows/build-openwrt.yml 文件中，让我们在一起看看这段代码吧：

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
opkg update                     #更新可用的软件包列表  
opkg upgrade <pkgs>             #升级软件包  
opkg install <pkgs>             #安装软件包  
opkg configure <pkgs>           #配置未打包的软件包  
opkg remove <pkgs | regexp>     #移除软件包
opkg list                       #列出可用的软件包  
opkg list-installed             #列出已经安装的软件包  
opkg list-upgradable            #列出已安装和可升级的软件包
opkg list | grep <pkgs>         #查找与关键字匹配的软件包
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

通常情况下，请重新插入 USB 并重新安装即可。

- [如果无法再次从 USB 启动 OpenWrt 系统](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/README.cn.md#安装升级失败后如何救砖)
- [如果选择使用主线 u-boot 后无法启动](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/amlogic-s9xxx/install-program/README.cn.md#在安装了主线-u-boot-后无法启动)

