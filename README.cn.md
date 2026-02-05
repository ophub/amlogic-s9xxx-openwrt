<div align="center">
    <img src="https://github.com/user-attachments/assets/5fcf18e1-ed16-49d3-9004-5301ac8d4309" alt="OpenWrt" />
</div>

# OpenWrt

查看英文说明 | [View English description](README.md)

[OpenWrt](https://openwrt.org/) 项目是一个针对嵌入式设备的 Linux 路由器操作系统。OpenWrt 不是一个单一且不可更改的固件，而是提供了具有软件包管理功能的完全可写的文件系统，让您可以自由选择需要的软件包来定制路由器系统。对于开发人员来说，OpenWrt 是一个无需围绕它构建完整固件就能开发应用程序的框架；对于普通用户来说，这意味着拥有了完全定制的能力，能以意想不到的方式使用该设备。它拥有超过 3000+ 个标准化应用软件包和非常丰富的第三方插件支持，让您可以轻松地将他们应用于各种支持的设备。现在你可以将电视盒子的安卓 TV 系统更换为 OpenWrt 系统，让他成为一台功能强大的路由器。

本项目托众多的[贡献者](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/CONTRIBUTORS.md)，为 `Amlogic`，`Rockchip` 和 `Allwinner` 盒子构建 OpenWrt 系统。支持写入 eMMC 中使用，支持更新内核等功能，使用方法详见 [OpenWrt 使用文档](./documents/README.cn.md)。最新的固件可以在 [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases) 中下载。欢迎你 `Fork` 并进行个性化软件包定制。如果对你有用，可以点仓库右上角的 `Star` 表示支持。

## OpenWrt 固件默认信息

| 系统名称        | 默认账号 | 默认密码  | SSH 端口 | IP 地址 |
| -------------- | ------- | ------- | ------- | ------- |
| 🛜 [OpenWrt.OS](https://github.com/ophub/amlogic-s9xxx-openwrt/releases) | root | password | 22 | 192.168.1.1 |
| 🐋 [OpenWrt.Docker](https://hub.docker.com/u/ophub) | root | password | 22 | 192.168.1.1 |

## 支持的设备列表

⬆️ 各平台（晶晨/瑞芯微/全志）型号均按 SoC 性能由高至低排列。

| SoC  | [设备](https://github.com/ophub/amlogic-s9xxx-openwrt/releases) | [内核](https://github.com/ophub/kernel) |
| ---- | ---- | ---- |
| a311d | [Khadas-VIM3](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/99), [WXY-OES](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2666) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| s922x | [Beelink-GT-King](https://github.com/ophub/amlogic-s9xxx-armbian/issues/370), [Beelink-GT-King-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/707), [Ugoos-AM6-Plus](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/464), [ODROID-N2](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/201), [X88-King](https://github.com/ophub/amlogic-s9xxx-armbian/issues/988), [Ali-CT2000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1150), [WXY-OES-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/3029) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| s905x3 | [X96-Max+](https://github.com/ophub/amlogic-s9xxx-armbian/issues/351), [HK1-Box](https://github.com/ophub/amlogic-s9xxx-armbian/issues/414), [Vontar-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1006), [H96-Max-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1250), [Ugoos-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/782), [TX3(QZ)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/644), [TX3(BZ)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1077), [X96-Air](https://github.com/ophub/amlogic-s9xxx-armbian/issues/366), [X96-Max+_A100](https://github.com/ophub/amlogic-s9xxx-armbian/issues/779), [A95X-F3-Air](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2282), [Tencent-Aurora-3Pro(s905x3-b)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/506), [X96-Max+Q1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/788), [X96-Max+100W](https://github.com/ophub/amlogic-s9xxx-armbian/issues/909), [X96-Max+_2101](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1086), [Infinity-B32](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1181), [Whale](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1166), [X88-Pro-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1621), [X99-Max-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1621), [Transpeed-X3-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1621) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| s905x2 | [X96Max-4G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/453), [X96Max-2G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/95), [MECOOL-KM3-4G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/79), [Tanix-Tx5-Max](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/351), [A95X-F2](https://github.com/ophub/amlogic-s9xxx-armbian/issues/851), [HG680-FJ](https://github.com/ophub/amlogic-s9xxx-armbian/pull/3089) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| s905l3a | [E900V22C/D](https://github.com/Calmact/e900v22c), [CM311-1a-YST](https://github.com/ophub/amlogic-s9xxx-armbian/issues/517), [M401A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/732), [M411A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/517), [UNT403A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/970), [UNT413A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/970), [ZTE-B863AV3.2-M](https://github.com/ophub/amlogic-s9xxx-armbian/issues/741), [CM311-1a-CH](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1508), [IP112H](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1520), [B863AV3.1-M2](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2292) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| s905l3b | [CM201-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2209), [CM211-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1180), [CM311-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1268), [E900V21D](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2447), [E900V22D](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1256), [E900V21E](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1514), [E900V22E](https://github.com/ophub/amlogic-s9xxx-armbian/issues/939), [M302A/M304A](https://github.com/ophub/amlogic-s9xxx-armbian/pull/615), [Hisense-IP103H](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1154), [TY1608](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1332), [TY1608](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1568), [MGV2000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1613), [B860AV-2.1M](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1598), [UNT403A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1712), [RG020ET-CA](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1860), [M411A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/3272) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| s905l3 | [CM211-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1318), [CM311-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/763), [HG680-LC](https://github.com/ophub/amlogic-s9xxx-armbian/issues/978), [M401A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/921#issuecomment-1453143251), [UNT400G1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1277), [UNT400G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2625), [UNT402A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1481), [ZXV10-BV310](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1512), [M411A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1817), [ZXV10-B860AV3.2-M](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2012), [ZXV10-B860AV2.1-U](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2273), [E900V22D-2](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2058), [CM201-1-6-YS](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2539), [IP108H](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2539), [M301A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/3055) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| s912 | [Tanix-TX8-Max](https://github.com/ophub/amlogic-s9xxx-armbian/issues/500), [Tanix-TX9-Pro(3G)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/315), [Tanix-TX9-Pro(2G)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/740), [Tanix-TX92](https://github.com/ophub/amlogic-s9xxx-armbian/issues/72#issuecomment-1012790770), [Tanix-TX9S](https://github.com/ophub/amlogic-s9xxx-armbian/issues/3282), [Nexbox-A1](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/260), [Nexbox-A95X-A2](https://www.cafago.com/en/p-v2979eu-2g.html),  [A95X](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/260), [H96-Pro-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/72#issuecomment-1013071513), [VORKE-Z6-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/72), [Mecool-M8S-PRO-L](https://github.com/ophub/amlogic-s9xxx-armbian/issues/158), [Vontar-X92](https://github.com/ophub/amlogic-s9xxx-armbian/issues/525), [T95Z-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/668), [Octopus-Planet](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1020), [Phicomm-T1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/522), [TX3-Mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1882), [OneCloudPro-V1.1_V1.2](https://github.com/ophub/amlogic-s9xxx-armbian/pull/2241) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| s905d | [MECOOL-KI-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/59), [Phicomm-N1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/925), [SML-5442TW](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/451) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| s905x | [HG680P](https://github.com/ophub/amlogic-s9xxx-armbian/issues/262), [B860H](https://github.com/ophub/amlogic-s9xxx-armbian/issues/60), [TBee-Box](https://github.com/ophub/amlogic-s9xxx-armbian/issues/98), [T95](https://github.com/ophub/amlogic-s9xxx-armbian/issues/285), [TX9](https://github.com/ophub/amlogic-s9xxx-armbian/issues/645), [XiaoMI-3S](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1405), [X96](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1480), [Nexbox-a95x](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1714), [BTV9](https://github.com/ophub/amlogic-s9xxx-armbian/issues/3256) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| s905mb | [S65](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1644) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| s905l | [UNT402A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1481), [M201-S](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/444), [MiBox-4](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2101), [MiBox-4C](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1826), [MG101](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1912), [E900V21C](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2341), [IP108H-53u1m](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2357), [Tencent-Aurora-1s](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2465), [B860AV2.1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2491), [B860AV2.1U](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2499), [HM201](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2585) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| s905l2 | [MGV2000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/648), [MGV2000-K](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1839), [MGV3000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/921), [Wojia-TV-IPBS9505](https://github.com/ophub/amlogic-s9xxx-armbian/issues/648), [M301A](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/405), [E900v21E](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1278), [e900v21d](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2127), [CM201-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2188), [IP108H](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2598), [MGV2000-CW](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2616) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| s905lb | [Q96-mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/734), [BesTV-R3300L](https://github.com/ophub/amlogic-s9xxx-armbian/pull/993), [SumaVision-Q7](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1190), [MG101](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1570), [s65](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2128), [IPBS9505](https://github.com/ophub/amlogic-s9xxx-armbian/pull/993#issuecomment-2276804591) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| s905w | [X96-Mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/621), [TX3-Mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1062), [W95](https://github.com/ophub/amlogic-s9xxx-armbian/issues/570), [X96W/FunTV](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1044), [MXQ-Pro-4K](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1140), [MeCool-m8s-pro-W](https://github.com/ophub/amlogic-s9xxx-armbian/issues/3245) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| s905 | [Beelink-Mini-MX-2G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/127), [Sunvell-T95M](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/337), [MXQ-Pro+4K](https://github.com/ophub/amlogic-s9xxx-armbian/issues/715), [SumaVision-Q5](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1175) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| rk3588(s) | [Radxa-Rock5B](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1240), [Radxa-Rock5C](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2324), [Orange-Pi-5-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2400), [Beelink-IPC-R](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/415), [HLink-H88K](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1726), [HLink-H88K-V3](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1726), [NanoPC-T6](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2453), [Smart-Am60](https://github.com/ophub/amlogic-s9xxx-armbian/pull/2817), [DC-A588](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2988), [Orangepi-5B](https://github.com/ophub/amlogic-s9xxx-armbian/pull/3052), [CM3588-NAS](https://github.com/ophub/amlogic-s9xxx-armbian/issues/3306), [Rock-5-ITX](https://github.com/ophub/fnnas/issues/355) | [rk3588](https://github.com/ophub/kernel/releases/tag/kernel_rk3588) |
| rk3576 | [NanoPi-m5](https://github.com/ophub/amlogic-s9xxx-armbian/issues/3207) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| rk3399 | [EAIDK-610](https://github.com/ophub/amlogic-s9xxx-armbian/pull/991), [King3399](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1080), [TN3399](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1094), [Kylin3399](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1132), [ZCube1-Max](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1247), [CRRC](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1280), [SMART-AM40](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1317), [SW799](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1326), [ZYSJ](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1380), [DG-3399](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1492), [DLFR100](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1522), [Emb3531](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1549), [Leez-p710](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1609), [tvi3315a](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1687), [xiaobao](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1698), [Fine3399](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1790), [Firefly-RK3399](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/491), [LX-R3S](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2026), [Hugsun-x99](https://github.com/ophub/amlogic-s9xxx-armbian/pull/2050), [Tb-ls3399](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2146), [Hisense-hs530r](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/572), [Tpm312](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2403), [ZK-rk39a](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2446), [YSKJ](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2673), [Fmx1-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2691), [Fmx1-Pro-B](https://github.com/ophub/fnnas/issues/250), [Sv-33a6x](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/748), [AIO-3399b](https://github.com/ophub/amlogic-s9xxx-armbian/issues/3185), [AIO-3399c](https://github.com/ophub/amlogic-s9xxx-armbian/issues/3339), [TaraM](https://github.com/ophub/u-boot/pull/28), [NanoPC-T4](https://github.com/ophub/u-boot/pull/30), [Firefly-Core-3399-JD4](https://github.com/ophub/amlogic-s9xxx-armbian/issues/3354) | [rk35xx](https://github.com/ophub/kernel/releases/tag/kernel_rk35xx)<br />[stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| rk3568 | [FastRhino-R66S](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1061), [FastRhino-R68S](https://github.com/ophub/amlogic-s9xxx-armbian/issues/774), [Radxa-E25](https://wiki.radxa.com/Rock3/CM/CM3I/E25), [NanoPi-R5S](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1217), [NanoPi-R5C](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1217), [HLink-H66K](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1726), [HLink-H68K](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1726), [HLink-H69K](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1726), [Seewo-sv21](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2017), [Mrkaio-m68s](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2155), [Swan1-w28](https://github.com/ophub/amlogic-s9xxx-armbian/pull/2407), [Ruisen-box](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2508), [DG-TN3568](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2661), [Alark35-3500](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2911), [MMBox-Anas3035](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2995), [Wocyber-A3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2978), [Photonicat](https://github.com/ophub/amlogic-s9xxx-openwrt/pull/827), [NSY-G16-Plus](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/845), [NSY-G68-Plus](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/845), [BDY-G18-Pro](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/847), [Gzpeite-P01](https://github.com/ophub/amlogic-s9xxx-armbian/issues/3221), [LZ-K3568](https://github.com/ophub/amlogic-s9xxx-armbian/issues/3304), [BDKJ-One](https://github.com/ophub/u-boot/pull/29), [Station-P2](https://github.com/ophub/fnnas/pull/350) | [rk35xx](https://github.com/ophub/kernel/releases/tag/kernel_rk35xx)<br />[stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| rk3566 | [Panther-X2](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1319), [JP-TvBox](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1867), [LCKFB-Taishan-Pi](https://github.com/ophub/amlogic-s9xxx-armbian/pull/2538), [WXY-OEC-turbo-4g](https://github.com/ophub/amlogic-s9xxx-armbian/pull/2736), [Station-M2](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/744), [Orange-Pi-3B](https://github.com/ophub/fnnas/issues/261) | [rk35xx](https://github.com/ophub/kernel/releases/tag/kernel_rk35xx)<br />[stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| rk3528 | [HLink-H28K](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1726), [Radxa-E20C](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2324), [H96-Max-M2](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2404) | [rk35xx](https://github.com/ophub/kernel/releases/tag/kernel_rk35xx) |
| rk3328 | [BeikeYun](https://github.com/ophub/amlogic-s9xxx-armbian/issues/852), [Chainedbox-L1-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1680), [Station-M1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1313), [Bqeel-MVR9](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1313), [Renegade/Firefly](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1861) | [rk35xx](https://github.com/ophub/kernel/releases/tag/kernel_rk35xx)<br />[stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| rk3318 | [RX3318-Box](https://github.com/ophub/amlogic-s9xxx-armbian/pull/2129) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| h6 | [Vplus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1100), [Tanix-TX6](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1120), [TQC-A01](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1638) | [h6](https://github.com/ophub/kernel/releases/tag/kernel_h6)<br>[stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |
| h618 | [OrangePi-Zero3](https://github.com/ophub/fnnas/issues/158) | [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable) |

> [!TIP]
> 目前 [s905 的盒子](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1173)只能在 `TF/SD/USB` 中使用，其他型号的盒子支持写入 `EMMC` 中使用。更多信息请查阅 [✅支持的设备列表说明](make-openwrt/openwrt-files/common-files/etc/model_database.conf)。可以参考说明文档中 12.15 章节的方法[添加新的支持设备](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/documents/README.cn.md#1215-如何添加新的支持设备)。使用前先阅读 [OpenWrt 使用文档](./documents/README.cn.md)，常见问题都有解决方法。

## 安装及升级 OpenWrt 的相关说明

选择和你的电视盒子型号对应的 OpenWrt 固件，不同设备的使用方法查看对应的说明。

- ### 安装 OpenWrt

1. `Rockchip` 平台的安装方法请查看说明文档中的 [第 8 章节](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/documents/README.cn.md) 的介绍，和 Armbian 的安装方法相同。

2. `Amlogic` 和 `Allwinner` 平台，使用 [Rufus](https://rufus.ie/) 或者 [balenaEtcher](https://www.balena.io/etcher/) 等工具将固件写入 USB 里，然后把写好固件的 USB 插入盒子。浏览器访问 OpenWrt 的 IP(例如 192.168.1.1) → `使用默认账户登录进入 OpenWrt` → `系统菜单` → `晶晨宝盒` → `安装 OpenWrt` ，在支持的设备下拉列表中选择你的盒子，点击 `安装 OpenWrt` 按钮进行安装。

- ### 升级 OpenWrt 系统或内核

浏览器访问 OpenWrt 的 IP(例如 192.168.1.1) →  `使用账户登录进入 OpenWrt` → `系统菜单` → `晶晨宝盒` → `手动上传更新 / 在线下载更新`

如果选择 `手动上传更新` [OpenWrt 固件](https://github.com/ophub/amlogic-s9xxx-openwrt/releases)，可以将编译好 OpenWrt 固件压缩包，如 openwrt_xxx_k5.15.50.img.gz 进行上传（推荐上传压缩包，系统会自动解压。如果上传解压缩后的 xxx.img 格式的文件，可能会因为文件太大而上传失败），上传完成后界面将显示 `更新固件` 的操作按钮，点击即可更新。

如果选择 `手动上传更新` [OpenWrt 内核](https://github.com/ophub/kernel/releases/tag/kernel_stable)，可以将 `boot-xxx.tar.gz`, `dtb-xxx.tar.gz`, `modules-xxx.tar.gz` 这 3 个内核文件上传（其他内核文件不需要，如果同时上传也不影响更新，系统可以准确识别需要的内核文件），上传完成后界面将显示 `更新内核` 的操作按钮，点击即可更新。内核更新失败造成系统无法启动时，可以使用 `openwrt-kernel -s` 命令进行内核恢复，方法详见[内核恢复](documents/README.cn.md#9-升级-openwrt-系统或内核)

如果选择 `在线下载更新` OpenWrt 固件或内核，将根据`插件设置`中的`固件下载地址`和`内核下载地址`进行下载，你可以自定义修改下载来源，具体操作方法详见 [luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) 的编译与使用说明。

- ### 为 OpenWrt 创建 swap

如果你在使用 `docker` 等内存占用较大的应用时，觉得当前盒子的内存不够使用，可以创建 `swap` 虚拟内存分区，将 `/mnt/*4` 磁盘空间的一定容量虚拟成内存来使用。下面命令输入参数的单位是 `GB`，默认为 `1`。

浏览器访问 OpenWrt 的 IP(例如 192.168.1.1) → `使用默认账户登录进入 OpenWrt` → `系统菜单` → `TTYD 终端` → 输入命令

```yaml
openwrt-swap 1
```

- ### 备份/还原 EMMC 原系统

支持在 `TF/SD/USB` 中对盒子的 `EMMC` 分区进行备份/恢复。建议您在全新的盒子里安装 OpenWrt 系统前，先对当前盒子自带的安卓 TV 系统进行备份，以便日后在恢复电视系统等情况下使用。

请从 `TF/SD/USB` 启动 OpenWrt 系统，浏览器访问 OpenWrt 的 IP(例如 192.168.1.1) → `使用默认账户登录进入 OpenWrt` → `系统菜单` → `TTYD 终端` → 输入命令

```yaml
openwrt-ddbr
```

根据提示输入 `b` 进行系统备份，输入 `r` 进行系统恢复。

> [!IMPORTANT]
> 除此之外也可以通过线刷的方法，将安卓系统刷入 eMMC 中，安卓系统的下载镜像可在 [Tools](https://github.com/ophub/kernel/releases/tag/tools) 中查找。

- ### 控制 LED 显示

浏览器访问 OpenWrt 的 IP(例如 192.168.1.1) → `使用默认账户登录进入 OpenWrt` → `系统菜单` → `TTYD 终端` → 输入命令

```yaml
openwrt-openvfd
```

根据 [LED 屏显示控制说明](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/documents/led_screen_display_control.md) 进行调试。

- ### 恢复到初始化状态

浏览器访问 OpenWrt 的 IP(例如 192.168.1.1) → `使用默认账户登录进入 OpenWrt` → `系统菜单` → `晶晨宝盒` → `备份固件配置` → `快照管理` → `初始化快照`，点击 `还原快照` 即可恢复至初始化状态。

也可以在 `系统菜单` → `TTYD 终端` → 输入命令 `firstboot` 恢复系统至初始化状态。这两种方法的操作结果相同。

- ### 更多使用说明

在 OpenWrt 的使用中，一些可能遇到的常见问题详见 [使用文档](./documents/README.cn.md)

## 本地化打包
1. Clone 仓库到本地 `git clone --depth 1 https://github.com/ophub/amlogic-s9xxx-openwrt.git`
2. 安装必要的软件包（如 Ubuntu 24.04）
```yaml
sudo apt-get update -y
sudo apt-get full-upgrade -y
# For Ubuntu-24.04
sudo apt-get install -y $(cat make-openwrt/scripts/ubuntu2404-make-openwrt-depends)
```
3. 在 `~/amlogic-s9xxx-openwrt` 根目录下创建 `openwrt-armsr` 文件夹, 并将 `openwrt-armsr-armv8-generic-rootfs.tar.gz` 文件上传至此目录。
4. 在 `~/amlogic-s9xxx-openwrt` 根目录中输入打包命令，如 `sudo ./remake -b s905x3 -k 6.1.10`。打包完成的 OpenWrt 固件放在根目录下的 `out` 文件夹里。

- ### 本地化打包参数说明

| 参数  | 含义       | 说明               |
| ---- | ---------- | ----------------- |
| -b   | Board      | 指定需要编译的设备代号。例如，`-b s905x3` 表示编译代号为 s905x3 的设备，多个设备可用下划线连接，如 `-b s905x3_s905d`。特殊值：`all` 表示编译全部设备，`first50` 表示编译设备库中的前 50 个，`range50_100` 表示从第 51 个开始至第 100 个，`range100_150` 表示从第 101 个开始至第 150 个，`last20` 表示最后的 20 个。设备代号列表详见 [model_database.conf](make-openwrt/openwrt-files/common-files/etc/model_database.conf) 中的 `BOARD` 配置项。默认值为 `all` |
| -r   | KernelRepo | 指定 github.com 内核仓库的 `<owner>/<repo>`。默认值：`ophub/kernel` |
| -u   | kernelUsage | 设置使用的内核的 `tags 后缀`，如 [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable), [flippy](https://github.com/ophub/kernel/releases/tag/kernel_flippy), [beta](https://github.com/ophub/kernel/releases/tag/kernel_beta)。默认值：`stable` |
| -k   | Kernel     | 指定 [kernel](https://github.com/ophub/kernel/releases/tag/kernel_stable) 名称，如 `-k 5.10.125` . 多个内核使用 `_` 进行连接，如 `-k 5.10.125_5.15.50` 。通过 `-k` 参数自由指定的内核版本只对使用 `stable/flippy/beta` 的内核有效。其他内核系列例如 [rk3588](https://github.com/ophub/kernel/releases/tag/kernel_rk3588) / [rk35xx](https://github.com/ophub/kernel/releases/tag/kernel_rk35xx) / 其他内核系列例如 [h6](https://github.com/ophub/kernel/releases/tag/kernel_h6) 等只能使用特定内核。  |
| -a   | AutoKernel | 设置是否自动采用同系列最新版本内核。当为 `true` 时，将自动在内核库中查找在 `-k` 中指定的内核如 5.10.125 的同系列是否有更新的版本，如有 5.10.125 之后的最新版本时，将自动更换为最新版。设置为 `false` 时将编译指定版本内核。默认值：`true` |
| -p   | IP       | 指定 OpenWrt 系统的默认 IP 地址，例如： `-p 10.1.1.1`。默认值：`192.168.1.1` |
| -s   | Size       | 对系统的镜像分区大小进行设置，只设置 ROOTFS 分区大小时可以只指定一个数值，例如： `-s 1024`。需要同时设置 BOOTFS 和 ROOTFS 分区大小时，使用 / 对两个数值进行连接，例如： `-s 256/1024`。默认值：`256/1024` |
| -n   | BuilderName | 设置 OpenWrt 系统构建者签名。设置签名时请勿包含空格。默认值：`无` |

- `sudo ./remake` : 使用默认配置，使用内核库中的最新内核包，对全部型号的电视盒子进行打包。
- `sudo ./remake -b s905x3 -k 6.1.10` : 推荐使用. 使用默认配置进行相关内核打包。
- `sudo ./remake -b s905x3 -k 6.1.y` : 使用默认配置进行相关内核打包，内核使用 6.1.y 系列的最新版。
- `sudo ./remake -b s905x3_s905d -k 6.1.10_5.15.50` : 使用默认配置，进行多个内核同时打包。使用 `_` 进行多内核参数连接。
- `sudo ./remake -b s905x3 -k 6.1.10 -s 1024` : 使用默认配置，指定一个内核，一个型号进行打包，固件大小设定为 1024 MiB。
- `sudo ./remake -b s905x3_s905d`  使用默认配置，对多个型号的电视盒子进行全部内核打包, 使用 `_` 进行多型号连接。
- `sudo ./remake -k 6.1.10_5.15.50` : 使用默认配置，指定多个内核，进行全部型号电视盒子进行打包, 内核包使用 `_` 进行连接。
- `sudo ./remake -k 6.1.10_5.15.50 -a true` : 使用默认配置，指定多个内核，进行全部型号电视盒子进行打包, 内核包使用 `_` 进行连接。自动升级到同系列最新内核。
- `sudo ./remake -s 1024 -k 6.1.10` : 使用默认配置，设置固件大小为 1024 MiB, 并指定内核为 6.1.10 ，对全部型号电视盒子进行打包。

## 使用 GitHub Actions 进行编译

你可以通过修改 [config](config) 目录的相关个性化固件配置文件，以及 [.yml](.github/workflows) 文件, 自定义和编译适合你的 OpenWrt 固件,  固件可以上传至 github.com 的 `Actions` 和 `Releases` 等处.

1. 你可以在 [使用文档](./documents/README.cn.md) 中查看个性化固件配置说明。编译流程控制文件是 [.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt-system-image.yml)
2. 全新编译：在 github.com 的 [Action](https://github.com/ophub/amlogic-s9xxx-openwrt/actions) 选择 ***`Build OpenWrt system image`*** . 点击 ***`Run workflow`*** 按钮进行固件一站式编译和打包。
3. 再次编译：如果 [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases) 中有已经编译好的 `openwrt-armsr-armv8-generic-rootfs.tar.gz` 文件，你只是想再次制作其他不同 board 的盒子，可以跳过 OpenWrt 源文件的编译，直接使用 [build-openwrt-using-releases-files.yml](.github/workflows/build-openwrt-using-releases-files.yml) 进行二次制作。
4. 更多支持：编译好的 `openwrt-armsr-armv8-generic-rootfs.tar.gz` 文件是制作各种不同 board 固件的通用文件，也适用于使用 [unifreq](https://github.com/unifreq/openwrt_packit) 的打包脚本制作 OpenWrt 固件。他作为在盒子里使用 OpenWrt 和 Armbian 系统的开创者，对更多的设备进行了支持，如在 [Armbian](https://github.com/ophub/amlogic-s9xxx-armbian) 系统中通过 `KVM` 虚拟机使用的 OpenWrt（[QEMU 版](https://github.com/unifreq/openwrt_packit/blob/master/files/qemu-aarch64/qemu-aarch64-readme.md)）、Amlogic、Rockchip，以及 Allwinner 系列等。打包方法详见他的仓库说明，在 Actions 中通过 [build-openwrt-using-unifreq-scripts.yml](.github/workflows/build-openwrt-using-unifreq-scripts.yml) 可以调用他的打包脚本制作更多固件。

```yaml
- name: Package armsr-armv8 as OpenWrt
  uses: ophub/amlogic-s9xxx-openwrt@main
  with:
    openwrt_path: openwrt/bin/targets/*/*/*rootfs.tar.gz
    openwrt_board: s905x3_s905x2_s905x_s905w_s905d_s922x_s912
    openwrt_kernel: 6.1.y_5.15.y
    openwrt_ip: 192.168.1.1
```

- ### GitHub Actions 输入参数说明

相关参数与`本地打包命令`相对应，请参考上面的说明。

| 参数               | 默认值             | 说明                                      |
|-------------------|-------------------|-------------------------------------------|
| openwrt_path      | 无                | 设置 `openwrt-armsr-armv8-generic-rootfs.tar.gz` 的文件路径，可以使用相对路径如 `openwrt/bin/targets/*/*/*rootfs.tar.gz` 或网络文件下载地址如 `https://github.com/*/releases/*/*rootfs.tar.gz` |
| openwrt_board     | all               | 设置打包盒子的 `board` ，功能参考 `-b` |
| kernel_repo       | ophub/kernel      | 指定 github.com 内核仓库的 `<owner>/<repo>`，功能参考 `-r` |
| kernel_usage      | stable            | 设置使用的内核的 `tags 后缀`。功能参考 `-u` |
| openwrt_kernel    | 6.1.y_5.15.y      | 设置内核版本，功能参考 `-k` |
| auto_kernel       | true              | 设置是否自动采用同系列最新版本内核。功能参考 `-a` |
| openwrt_ip        | 192.168.1.1       | 设置 OpenWrt 系统的默认 IP 地址，功能参考 `-p` |
| openwrt_size      | 256/1024          | 设置系统 BOOTFS 和 ROOTFS 分区的大小，功能参考 `-s` |
| openwrt_files     | false             | 添加自定义 OpenWrt 文件。设置后，该目录下的所有文件将被复制到 [common-files](make-openwrt/openwrt-files/common-files) 中。目录结构必须与 OpenWrt 根目录保持一致，以确保文件被正确覆盖到固件中（例如：默认配置文件应存放于 `etc/config/` 子目录下）。 |
| builder_name      | 无                | 设置 OpenWrt 系统构建者签名，功能参考 `-n`     |


- ### GitHub Actions 输出变量说明

上传到 `Releases` 需要给仓库设置 `Workflow 读写权限`，详见[使用说明](./documents/README.cn.md#2-设置隐私变量-github_token)。

| 参数                              | 默认值              | 说明                   |
|----------------------------------|--------------------|------------------------|
| ${{ env.PACKAGED_OUTPUTPATH }}   | out                | Armbian 系统文件输出路径  |
| ${{ env.PACKAGED_OUTPUTDATE }}   | 04.13.1058         | 打包日期（月.日.时分）     |
| ${{ env.PACKAGED_STATUS }}       | success / failure  | 打包状态。成功 / 失败     |

## openwrt-*-rootfs.tar.gz 用于打包的文件编译选项

| Option | Value |
| ------ | ----- |
| Target System | Arm SystemReady (EFI) compliant |
| Subtarget | 64-bit (armv8) machines |
| Target Profile | Generic EFI Boot |
| Target Images | tar.gz |

更多信息请查阅 [使用文档](./documents/README.cn.md)

## 编译内核

内核的编译方法详见 [compile-kernel](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/compile-kernel)

```yaml
- name: Compile the kernel
  uses: ophub/amlogic-s9xxx-armbian@main
  with:
    build_target: kernel
    kernel_version: 6.1.y_5.15.y
    kernel_auto: true
    kernel_sign: -yourname
```

## 资源说明

制作 OpenWrt 系统时，所使用的 [kernel](https://github.com/ophub/kernel) 和 [u-boot](https://github.com/ophub/u-boot) 等文件，与制作 [Armbian](https://github.com/ophub/amlogic-s9xxx-armbian) 系统使用的是相同的文件。为了不重复维护，相关内容归类放在了对应的资源仓库，在使用时将自动从相关仓库进行下载。

本系统所使用的 [u-boot](https://github.com/ophub/u-boot), [kernel](https://github.com/ophub/kernel) 等资源主要从 [unifreq/openwrt_packit](https://github.com/unifreq/openwrt_packit) 的项目中复制而来，部分文件由用户在 [amlogic-s9xxx-openwrt](https://github.com/ophub/amlogic-s9xxx-openwrt) / [amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian) / [luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) / [kernel](https://github.com/ophub/kernel) / [u-boot](https://github.com/ophub/u-boot) 等项目的 [Pull](https://github.com/ophub/amlogic-s9xxx-openwrt/pulls) 和 [Issues](https://github.com/ophub/amlogic-s9xxx-openwrt/issues) 中提供分享。`unifreq` 为我们开启了在电视盒子中使用 OpenWrt 的大门，深受其影响，我的固件在制作和使用中继承了他一贯的标准。为感谢这些开拓者和分享者，我统一在 [CONTRIBUTORS.md](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/CONTRIBUTORS.md) 中进行了记录。再次感谢大家为盒子赋予了新的生命和意义。

## 其他发行版

- [unifreq](https://github.com/unifreq/openwrt_packit) 为晶晨、瑞芯微和全志等更多盒子制作了 `OpenWrt` 系统，属于盒子圈的标杆，推荐使用。
- [amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian) 项目提供了在盒子中使用的 `Armbian` 系统，在支持 OpenWrt 的相关设备中同样适用。
- [fnnas](https://github.com/ophub/fnnas) 项目提供了在盒子中使用的 `FnNAS` 系统，在支持 OpenWrt 的相关设备中同样适用。

## 链接

- [unifreq](https://github.com/unifreq/openwrt_packit)
- [OpenWrt](https://github.com/openwrt/openwrt)
- [coolsnowwolf](https://github.com/coolsnowwolf/lede)
- [immortalwrt](https://github.com/immortalwrt/immortalwrt)

## License

The amlogic-s9xxx-openwrt © OPHUB is licensed under [GPL-2.0](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/LICENSE)
