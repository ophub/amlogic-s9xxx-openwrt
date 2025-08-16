# OpenWrt

View Chinese description | [查看中文说明](README.cn.md)

The [OpenWrt](https://openwrt.org/) project is a Linux router operating system for embedded devices. OpenWrt is not a single and immutable firmware, but rather provides a fully writable filesystem with package management capabilities, allowing you to freely select the required software packages to customize the router system. For developers, OpenWrt is a framework that allows application development without having to build a complete firmware around it; for ordinary users, it means having the capability for complete customization, and the ability to use the device in unexpected ways. It has over 3000+ standardized application software packages and extensive third-party plugin support, allowing you to easily apply them to various supported devices. Now you can replace the Android TV system on your TV box with the OpenWrt system, turning it into a powerful router.

This project, thanks to numerous [contributors](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/CONTRIBUTORS.md), builds the OpenWrt system for `Amlogic`, `Rockchip`, and `Allwinner` boxes. It supports writing to eMMC for use, supports updating the kernel, and more. For detailed usage instructions, see the [OpenWrt User Guide](./documents). The latest firmware can be downloaded from [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases). You are welcome to `Fork` and customize the software packages. If you find it useful, you can click the `Star` in the upper right corner of the repository to show your support.

## OpenWrt System Description

| SoC  | Device | [Kernel](https://github.com/ophub/kernel) | [OpenWrt](https://github.com/ophub/amlogic-s9xxx-openwrt/releases) |
| ---- | ---- | ---- | ---- |
| a311d | [Khadas-VIM3](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/99), [WXY-OES](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2666) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_a311d.img |
| s922x | [Beelink-GT-King](https://github.com/ophub/amlogic-s9xxx-armbian/issues/370), [Beelink-GT-King-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/707), [Ugoos-AM6-Plus](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/464), [ODROID-N2](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/201), [X88-King](https://github.com/ophub/amlogic-s9xxx-armbian/issues/988), [Ali-CT2000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1150), [WXY-OES-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/3029) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s922x.img |
| s905x3 | [X96-Max+](https://github.com/ophub/amlogic-s9xxx-armbian/issues/351), [HK1-Box](https://github.com/ophub/amlogic-s9xxx-armbian/issues/414), [Vontar-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1006), [H96-Max-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1250), [Ugoos-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/782), [TX3(QZ)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/644), [TX3(BZ)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1077), [X96-Air](https://github.com/ophub/amlogic-s9xxx-armbian/issues/366), [X96-Max+_A100](https://github.com/ophub/amlogic-s9xxx-armbian/issues/779), [A95X-F3-Air](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2282), [Tencent-Aurora-3Pro(s905x3-b)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/506), [X96-Max+Q1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/788), [X96-Max+100W](https://github.com/ophub/amlogic-s9xxx-armbian/issues/909), [X96-Max+_2101](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1086), [Infinity-B32](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1181), [Whale](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1166), [X88-Pro-X3](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1621), [X99-Max-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1621), [Transpeed-X3-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1621) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905x3.img |
| s905x2 | [X96Max-4G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/453), [X96Max-2G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/95), [MECOOL-KM3-4G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/79), [Tanix-Tx5-Max](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/351), [A95X-F2](https://github.com/ophub/amlogic-s9xxx-armbian/issues/851), [HG680-FJ](https://github.com/ophub/amlogic-s9xxx-armbian/pull/3089) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905x2.img |
| s912 | [Tanix-TX8-Max](https://github.com/ophub/amlogic-s9xxx-armbian/issues/500), [Tanix-TX9-Pro(3G)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/315), [Tanix-TX9-Pro(2G)](https://github.com/ophub/amlogic-s9xxx-armbian/issues/740), [Tanix-TX92](https://github.com/ophub/amlogic-s9xxx-armbian/issues/72#issuecomment-1012790770), [Nexbox-A1](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/260), [Nexbox-A95X-A2](https://www.cafago.com/en/p-v2979eu-2g.html),  [A95X](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/260), [H96-Pro-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/72#issuecomment-1013071513), [VORKE-Z6-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/72), [Mecool-M8S-PRO-L](https://github.com/ophub/amlogic-s9xxx-armbian/issues/158), [Vontar-X92](https://github.com/ophub/amlogic-s9xxx-armbian/issues/525), [T95Z-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/668), [Octopus-Planet](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1020), [Phicomm-T1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/522), [TX3-Mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1882), [OneCloudPro-V1.1_V1.2](https://github.com/ophub/amlogic-s9xxx-armbian/pull/2241) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s912.img |
| s905d | [MECOOL-KI-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/59), [Phicomm-N1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/925), [SML-5442TW](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/451) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905d.img |
| s905x | [HG680P](https://github.com/ophub/amlogic-s9xxx-armbian/issues/262), [B860H](https://github.com/ophub/amlogic-s9xxx-armbian/issues/60), [TBee-Box](https://github.com/ophub/amlogic-s9xxx-armbian/issues/98), [T95](https://github.com/ophub/amlogic-s9xxx-armbian/issues/285), [TX9](https://github.com/ophub/amlogic-s9xxx-armbian/issues/645), [XiaoMI-3S](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1405), [X96](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1480), [Nexbox-a95x](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1714) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905x.img |
| s905w | [X96-Mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/621), [TX3-Mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1062), [W95](https://github.com/ophub/amlogic-s9xxx-armbian/issues/570), [X96W/FunTV](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1044), [MXQ-Pro-4K](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1140) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905w.img |
| s905mb | [S65](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1644) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905s905mb.img |
| s905l | [UNT402A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1481), [M201-S](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/444), [MiBox-4](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2101), [MiBox-4C](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1826), [MG101](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1912), [E900V21C](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2341), [IP108H-53u1m](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2357), [Tencent-Aurora-1s](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2465), [B860AV2.1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2491), [B860AV2.1U](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2499), [HM201](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2585) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905l.img |
| s905l2 | [MGV2000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/648), [MGV2000-K](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1839), [MGV3000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/921), [Wojia-TV-IPBS9505](https://github.com/ophub/amlogic-s9xxx-armbian/issues/648), [M301A](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/405), [E900v21E](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1278), [e900v21d](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2127), [CM201-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2188), [IP108H](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2598), [MGV2000-CW](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2616) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905l2.img |
| s905l3 | [CM211-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1318), [CM311-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/763), [HG680-LC](https://github.com/ophub/amlogic-s9xxx-armbian/issues/978), [M401A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/921#issuecomment-1453143251), [UNT400G1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1277), [UNT400G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2625), [UNT402A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1481), [ZXV10-BV310](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1512), [M411A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1817), [ZXV10-B860AV3.2-M](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2012), [ZXV10-B860AV2.1-U](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2273), [E900V22D-2](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2058), [CM201-1-6-YS](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2539), [IP108H](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2539), [M301A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/3055) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905l3.img |
| s905l3a | [E900V22C/D](https://github.com/Calmact/e900v22c), [CM311-1a-YST](https://github.com/ophub/amlogic-s9xxx-armbian/issues/517), [M401A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/732), [M411A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/517), [UNT403A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/970), [UNT413A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/970), [ZTE-B863AV3.2-M](https://github.com/ophub/amlogic-s9xxx-armbian/issues/741), [CM311-1a-CH](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1508), [IP112H](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1520), [B863AV3.1-M2](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2292) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905l3a.img |
| s905l3b | [CM201-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2209), [CM211-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1180), [CM311-1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1268), [E900V21D](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2447), [E900V22D](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1256), [E900V21E](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1514), [E900V22E](https://github.com/ophub/amlogic-s9xxx-armbian/issues/939), [M302A/M304A](https://github.com/ophub/amlogic-s9xxx-armbian/pull/615), [Hisense-IP103H](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1154), [TY1608](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1332), [TY1608](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1568), [MGV2000](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1613), [B860AV-2.1M](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1598), [UNT403A](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1712), [RG020ET-CA](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1860) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905l3b.img |
| s905lb | [Q96-mini](https://github.com/ophub/amlogic-s9xxx-armbian/issues/734), [BesTV-R3300L](https://github.com/ophub/amlogic-s9xxx-armbian/pull/993), [SumaVision-Q7](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1190), [MG101](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1570), [s65](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2128), [IPBS9505](https://github.com/ophub/amlogic-s9xxx-armbian/pull/993#issuecomment-2276804591) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905lb.img |
| s905 | [Beelink-Mini-MX-2G](https://github.com/ophub/amlogic-s9xxx-armbian/issues/127), [Sunvell-T95M](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/337), [MXQ-Pro+4K](https://github.com/ophub/amlogic-s9xxx-armbian/issues/715), [SumaVision-Q5](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1175) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | amlogic_s905.img |
| rk3588(s) | [Radxa-Rock5B](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1240), [Radxa-Rock5C](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2324), [Orange-Pi-5-Plus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2400), [Beelink-IPC-R](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/415), [HLink-H88K](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1726), [HLink-H88K-V3](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1726), [NanoPC-T6](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2453), [Smart-Am60](https://github.com/ophub/amlogic-s9xxx-armbian/pull/2817), [DC-A588](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2988), [Orangepi-5B](https://github.com/ophub/amlogic-s9xxx-armbian/pull/3052) | [rk3588](https://github.com/ophub/kernel/releases/tag/kernel_rk3588) | rockchip_boxname.img |
| rk3568 | [FastRhino-R66S](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1061), [FastRhino-R68S](https://github.com/ophub/amlogic-s9xxx-armbian/issues/774), [Radxa-E25](https://wiki.radxa.com/Rock3/CM/CM3I/E25), [NanoPi-R5S](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1217), [NanoPi-R5C](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1217), [HLink-H66K](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1726), [HLink-H68K](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1726), [HLink-H69K](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1726), [Seewo-sv21](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2017), [Mrkaio-m68s](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2155), [Swan1-w28](https://github.com/ophub/amlogic-s9xxx-armbian/pull/2407), [Ruisen-box](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2508), [DG-TN3568](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2661), [Alark35-3500](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2911), [MMBox-Anas3035](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2995) | [rk35xx](https://github.com/ophub/kernel/releases/tag/kernel_rk35xx) | [rk35xx](https://github.com/ophub/kernel/releases/tag/kernel_rk35xx)<br />[6.x.y](https://github.com/ophub/kernel/releases/tag/kernel_stable) | rockchip_boxname.img |
| rk3566 | [Panther-X2](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1319), [JP-TvBox](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1867), [LCKFB-Taishan-Pi](https://github.com/ophub/amlogic-s9xxx-armbian/pull/2538), [WXY-OEC-turbo-4g](https://github.com/ophub/amlogic-s9xxx-armbian/pull/2736), [Station-M2](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/744) | [rk35xx](https://github.com/ophub/kernel/releases/tag/kernel_rk35xx)<br />[6.x.y](https://github.com/ophub/kernel/releases/tag/kernel_stable) | rockchip_boxname.img |
| rk3528 | [HLink-H28K](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1726), [Radxa-E20C](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2324), [H96-Max-M2](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2404) | [rk35xx](https://github.com/ophub/kernel/releases/tag/kernel_rk35xx) | rockchip_boxname.img |
| rk3399 | [EAIDK-610](https://github.com/ophub/amlogic-s9xxx-armbian/pull/991), [King3399](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1080), [TN3399](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1094), [Kylin3399](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1132), [ZCube1-Max](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1247), [CRRC](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1280), [SMART-AM40](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1317), [SW799](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1326), [ZYSJ](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1380), [DG-3399](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1492), [DLFR100](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1522), [Emb3531](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1549), [Leez-p710](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1609), [tvi3315a](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1687), [xiaobao](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1698), [Fine3399](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1790), [Firefly-RK3399](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/491), [LX-R3S](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2026), [Hugsun-x99](https://github.com/ophub/amlogic-s9xxx-armbian/pull/2050), [Tb-ls3399](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2146), [Hisense-hs530r](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/572), [Tpm312](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2403), [ZK-rk39a](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2446), [YSKJ](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2673), [Fmx1-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/2691), [Sv-33a6x](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/748) | [6.x.y](https://github.com/ophub/kernel/releases/tag/kernel_stable) | rockchip_boxname.img |
| rk3328 | [BeikeYun](https://github.com/ophub/amlogic-s9xxx-armbian/issues/852), [Chainedbox-L1-Pro](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1680), [Station-M1](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1313), [Bqeel-MVR9](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1313), [Renegade/Firefly](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1861) | [All](https://github.com/ophub/kernel/releases/tag/kernel_stable) | rockchip_boxname.img |
| rk3318 | [RX3318-Box](https://github.com/ophub/amlogic-s9xxx-armbian/pull/2129) | [6.x.y](https://github.com/ophub/kernel/releases/tag/kernel_stable) | rockchip_boxname.img |
| h6 | [Vplus](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1100), [Tanix-TX6](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1120), [TQC-A01](https://github.com/ophub/amlogic-s9xxx-armbian/pull/1638) | [6.x.y](https://github.com/ophub/kernel/releases/tag/kernel_stable)<br>[h6](https://github.com/ophub/kernel/releases/tag/kernel_h6) | allwinner_boxname.img |

> [!TIP]
> Currently, the [s905 box](https://github.com/ophub/amlogic-s9xxx-armbian/issues/1173) can only be used with a `SD card` or a `USB drive`, other models of boxes support using the `EMMC`. For more information, please refer to the [Supported Device List Description](make-openwrt/openwrt-files/common-files/etc/model_database.conf). You can refer to the method in Section 12.15 of the instruction manual to [add new supported devices](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/documents/README.md#1215-how-to-add-new-supported-devices). Please read the [OpenWrt User Guide](./documents) before use. It provides solutions to common issues.

## Install and Update OpenWrt

Choose the OpenWrt firmware corresponding to your TV box model, and refer to the corresponding instructions for the use of different devices.

- ### Install OpenWrt

1. For the `Rockchip` platform, please refer to the [Chapter 8](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/documents/README.md#8-installing-armbian-to-emmc) of the instruction manual, the installation method is the same as that of Armbian.

2. For the `Amlogic` and `Allwinner` platforms, use tools like [Rufus](https://rufus.ie/) or [balenaEtcher](https://www.balena.io/etcher/) to write the firmware to USB, then insert the USB with the written firmware into the box. Browser access to OpenWrt's IP (e.g. 192.168.1.1) → `Log in to OpenWrt with the default account` → `System Menu` → `Amlogic Treasure Box` → `Install OpenWrt`, select your box from the dropdown list of supported devices, click `Install OpenWrt` button to install.

- ### Update OpenWrt system or kernel

Browser access to OpenWrt's IP (e.g. 192.168.1.1) → `Log in to OpenWrt with your account` → `System Menu` → `Amlogic Treasure Box` → `Manually Upload Update / Online Download Update`

If you select `Manually Upload Update` [OpenWrt Firmware](https://github.com/ophub/amlogic-s9xxx-openwrt/releases), you can upload the compressed package of the compiled OpenWrt firmware, such as openwrt_xxx_k5.15.50.img.gz (recommended to upload the compressed package, the system will automatically decompress. If you upload the decompressed xxx.img format file, it may fail due to the large file size). After the upload is complete, the interface will display the operation button of `Update Firmware`, click to update.

If you select `Manually Upload Update` [OpenWrt Kernel](https://github.com/ophub/kernel/releases/tag/kernel_stable), you can upload the three kernel files: `boot-xxx.tar.gz`, `dtb-xxx.tar.gz`, `modules-xxx.tar.gz` (other kernel files are not needed, if uploaded simultaneously, it does not affect the update, the system can accurately identify the needed kernel files). After the upload is complete, the interface will display the operation button of `Update Kernel`, click to update. When a kernel update failure causes the system to be unbootable, you can use the `openwrt-kernel -s` command for kernel recovery. For the method, see [Kernel Recovery](documents/README.md#9-update-openwrt-system-or-kernel).

If you select `Online Download Update` for OpenWrt firmware or kernel, it will be downloaded according to the `firmware download address` and `kernel download address` in the `Plugin Settings`. You can customize the download source. For specific operation methods, please refer to the compilation and usage instructions of [luci-app-amlogic](https://github.com/ophub/luci-app-amlogic).

- ### Create swap for OpenWrt

If you feel that the current box's memory is not enough when using memory-intensive applications like `docker`, you can create a `swap` virtual memory partition, and use a certain capacity of the `/mnt/*4` disk space as memory. The unit of the input parameter in the command below is `GB`, the default is `1`.

Browser access to OpenWrt's IP (e.g. 192.168.1.1) → `Log in to OpenWrt with the default account` → `System Menu` → `TTYD Terminal` → enter the command

```yaml
openwrt-swap 1
```

- ### Backup/Restore Original EMMC System

Supports backing up/restoring the `EMMC` to a `SD card` or a `USB flash drive`. We recommend that you backup the Android TV system that comes with the box before installing the OpenWrt system in a brand-new box for future use in restoring the TV system, etc.

Please boot OpenWrt system from a `SD card` or a `USB flash drive`, then from the browser, Browser access to OpenWrt's IP (e.g. 192.168.1.1) → `Log in to OpenWrt with the default account` → `System Menu` → `TTYD Terminal` → enter the command

```yaml
openwrt-ddbr
```

Follow the prompts to enter `b` to backup the system, or enter `r` to restore the system.

> [!IMPORTANT]
> In addition, the Android system can also be flashed into eMMC using the method of flashing via a cable. The download image of the Android system can be found in [Tools](https://github.com/ophub/kernel/releases/tag/tools).

- ### Control LED Display

Browser access to OpenWrt's IP (e.g. 192.168.1.1) → `Log in to OpenWrt with the default account` → `System Menu` → `TTYD Terminal` → enter the command

```yaml
openwrt-openvfd
```

Refer to [LED Screen Display Control Description](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/documents/led_screen_display_control.md) for debugging.

- ### Restore to Initial State

Browser access to OpenWrt's IP (e.g. 192.168.1.1) → `Log in to OpenWrt with the default account` → `System Menu` → `Amlogic Service` → `Backup Firmware Config` → `Snapshot Management` → `Select Initialize Snapshot`, and click on `Restore Snap` to revert to the initial state.

Alternatively, you can navigate to `System menu` → `TTYD Terminal` → Enter the command `firstboot` to restore the system to its initial state. Both methods yield the same result.

- ### More Usage Instructions

Some common problems that might be encountered during the use of OpenWrt can be found in the [User Guide](./documents)

## Local Packaging

1. Install necessary packages (for Ubuntu 22.04 LTS users)
```yaml
sudo apt-get update -y
sudo apt-get full-upgrade -y
# For Ubuntu-22.04
sudo apt-get install -y $(curl -fsSL https://tinyurl.com/ubuntu2204-make-openwrt)
```
2. Clone repository to local `git clone --depth 1 https://github.com/ophub/amlogic-s9xxx-openwrt.git`
3. In the root directory of `~/amlogic-s9xxx-openwrt`, create `openwrt-armsr` folder, and upload the `openwrt-armsr-armv8-generic-rootfs.tar.gz` file to this directory.
4. Enter the packaging command in the root directory of `~/amlogic-s9xxx-openwrt`, such as `sudo ./remake -b s905x3 -k 6.1.10`. The packaged OpenWrt firmware is placed in the `out` folder in the root directory.

- ### Explanation of Local Packaging Parameters

| Parameter | Meaning       | Description |
| --------- | ------------- | ----------- |
| -b        | Board         | Specifies the device code(s) to build. For example, `-b s905x3` builds the device with code s905x3. Multiple device codes can be connected using underscores, such as `-b s905x3_s905d`. Special values: `all` builds all devices; `top50` builds the top 50 devices in the device list; `rest50` builds from the 51st device to the end. The full list of device codes can be found in the `BOARD` entries of [model_database.conf](make-openwrt/openwrt-files/common-files/etc/model_database.conf). Default: `all` |
| -r        | KernelRepo    | Specify the `<owner>/<repo>` of the github.com kernel repository. Default: `ophub/kernel` |
| -u        | kernelUsage   | Set the `tag suffix` of the kernel to be used, such as [stable](https://github.com/ophub/kernel/releases/tag/kernel_stable), [flippy](https://github.com/ophub/kernel/releases/tag/kernel_flippy), [dev](https://github.com/ophub/kernel/releases/tag/kernel_dev), [beta](https://github.com/ophub/kernel/releases/tag/kernel_beta). Default: `stable` |
| -k        | Kernel        | Specify the [kernel](https://github.com/ophub/kernel/releases/tag/kernel_stable) name, such as `-k 5.10.125`. Connect multiple kernels with `_`, such as `-k 5.10.125_5.15.50`. The kernel version freely specified by the `-k` parameter is only valid for kernels using `stable/flippy/dev/beta`. Other kernel series such as [rk3588](https://github.com/ophub/kernel/releases/tag/kernel_rk3588) / [rk35xx](https://github.com/ophub/kernel/releases/tag/kernel_rk35xx) / [h6](https://github.com/ophub/kernel/releases/tag/kernel_h6) can only use specific kernels. |
| -a        | AutoKernel    | Set whether to automatically adopt the latest version of the same series of kernels. When set to `true`, it will automatically search the kernel library for updates of the same series as the kernel specified in `-k`, such as 5.10.125, and will automatically switch to the latest version if there is a version later than 5.10.125. When set to `false`, it will compile the specified version of the kernel. Default: `true` |
| -s        | Size          | Set the size of the system's image partitions. When setting only the ROOTFS partition size, you can specify a single value, for example: `-s 1024`. When setting both BOOTFS and ROOTFS partition sizes, use / to connect the two values, for example: `-s 256/1024`. The default value is `256/1024` |
| -n        | BuilderName   | Set the signature of the OpenWrt system builder. Do not include spaces when setting signatures. Default: `none` |

- `sudo ./remake` : Use default configuration, use the latest kernel package in the kernel library, and package all models of TV boxes.
- `sudo ./remake -b s905x3 -k 6.1.10` : Recommended. Use default configuration for related kernel packaging.
- `sudo ./remake -b s905x3 -k 6.1.y` : Package the relevant kernels using the default configuration; the kernel utilizes the latest version of the 6.1.y series.
- `sudo ./remake -b s905x3_s905d -k 6.1.10_5.15.50` : Use the default configuration and package multiple kernels at the same time. Use `_` to connect multiple kernel parameters.
- `sudo ./remake -b s905x3 -k 6.1.10 -s 1024` : Use the default configuration, specify a kernel, a model for packaging, and set the firmware size to 1024 MiB.
- `sudo ./remake -b s905x3_s905d` : Use default configuration, package all kernels for multiple models of TV boxes, use `_` to connect multiple models.
- `sudo ./remake -k 6.1.10_5.15.50` : Use the default configuration, specify multiple kernels, package all models of TV boxes, and connect kernel packages with `_`.
- `sudo ./remake -k 6.1.10_5.15.50 -a true` : Use the default configuration, specify multiple kernels, package all models of TV boxes, and connect kernel packages with `_`. Automatically upgrade to the latest kernel of the same series.
- `sudo ./remake -s 1024 -k 6.1.10` : Use the default configuration, set the firmware size to 1024 MiB, and specify the kernel as 6.1.10 to package all models of TV boxes.

## Use GitHub Actions for Compilation

You can modify the related personalized firmware configuration files in the [config](config) directory, as well as the [.yml](.github/workflows) file, customize and compile your OpenWrt firmware, and the firmware can be uploaded to `Actions` and `Releases` on github.com.

1. You can view the personalized firmware configuration instructions in the [user documentation](./documents). The compilation process control file is [.yml](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/.github/workflows/build-openwrt-system-image.yml)
2. New compilation: In github.com's [Action](https://github.com/ophub/amlogic-s9xxx-openwrt/actions) select ***`Build OpenWrt system image`***. Click the ***`Run workflow`*** button for one-stop firmware compilation and packaging.
3. Re-compilation: If there is already a compiled `openwrt-armsr-armv8-generic-rootfs.tar.gz` file in [Releases](https://github.com/ophub/amlogic-s9xxx-openwrt/releases), and you just want to remake other different boards, you can skip compiling the Armbian source files and directly use [build-openwrt-using-releases-files.yml](.github/workflows/build-openwrt-using-releases-files.yml) for secondary build.
4. More Support: The compiled `openwrt-armsr-armv8-generic-rootfs.tar.gz` file is a universal file for making firmware for different boards. It is also applicable for creating OpenWrt firmware using [unifreq](https://github.com/unifreq/openwrt_packit)'s packaging scripts. As the pioneer of using OpenWrt and Armbian systems in TV boxes, he provides support for more devices, such as OpenWrt (QEMU version) used in the Armbian system through a `KVM` virtual machine, and Amlogic, Rockchip, and Allwinner series, etc. For packaging methods, please refer to the instructions in his repository. In Actions, through [build-openwrt-using-unifreq-scripts.yml](.github/workflows/build-openwrt-using-unifreq-scripts.yml), you can call his packaging scripts to create more firmware.

```yaml
- name: Package armsr-armv8 as OpenWrt
  uses: ophub/amlogic-s9xxx-openwrt@main
  with:
    openwrt_path: openwrt/bin/targets/*/*/*rootfs.tar.gz
    openwrt_board: s905x3_s905x2_s905x_s905w_s905d_s922x_s912
    openwrt_kernel: 6.1.y_5.15.y
```

- ### GitHub Actions Input Parameters Explanation

These parameters correspond to the `local packaging command`, please refer to the explanations above.

| Parameter | Default Value | Description |
| --------- | ------------- | ----------- |
| openwrt_path | None | Set the file path of `openwrt-armsr-armv8-generic-rootfs.tar.gz`, you can use relative path like `openwrt/bin/targets/*/*/*rootfs.tar.gz` or a network file download URL like `https://github.com/*/releases/*/*rootfs.tar.gz` |
| openwrt_board | all | Set the `board` of the box to be packaged, functionality refers to `-b` |
| kernel_repo | ophub/kernel | Specify `<owner>/<repo>` of the kernel repository on github.com, functionality refers to `-r` |
| kernel_usage | stable | Set the `tags suffix` of the kernel to be used, functionality refers to `-u` |
| openwrt_kernel | 6.1.y_5.15.y | Set the kernel version, functionality refers to `-k` |
| auto_kernel | true | Set whether to automatically adopt the latest version of the same series of kernels, functionality refers to `-a` |
| openwrt_size | 256/1024 | Set the size of the system BOOTFS and ROOTFS partitions, function reference `-s` |
| builder_name | None | Set the signature of the OpenWrt system builder, functionality refers to `-n` |

- ### GitHub Actions Output Variables Explanation

To upload to `Releases`, you need to set `Workflow read/write permissions` for repository. For details, see [usage instructions](./documents/README.md#2-set-the-privacy-variable-github_token).

| Parameter                      | Default Value     | Description                            |
| ------------------------------ | ----------------- | -------------------------------------- |
| ${{ env.PACKAGED_OUTPUTPATH }} | out               | OpenWrt system files output path       |
| ${{ env.PACKAGED_OUTPUTDATE }} | 04.13.1058        | Packaging date (month.day.hourminute)  |
| ${{ env.PACKAGED_STATUS }}     | success / failure | Packaging status. success / failure    |

## Compilation Options of openwrt-*-rootfs.tar.gz for Packaging

| Option | Value |
| ------ | ----- |
| Target System | Arm SystemReady (EFI) compliant |
| Subtarget | 64-bit (armv8) machines |
| Target Profile | Generic EFI Boot |
| Target Images | tar.gz |

For more information, please refer to the [User Documentation](./documents)

## Default Information for OpenWrt Firmware

| Name | Value |
| ---- | ---- |
| Default IP | 192.168.1.1 |
| Default Account | root |
| Default Password | password |
| Default WIFI Name | OpenWrt |
| Default WIFI Password | None |

## Compile the Kernel

For instructions on how to compile the kernel, see [compile-kernel](https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/compile-kernel).

```yaml
- name: Compile the kernel
  uses: ophub/amlogic-s9xxx-armbian@main
  with:
    build_target: kernel
    kernel_version: 6.1.y_5.15.y
    kernel_auto: true
    kernel_sign: -yourname
```

## Resource Description

When making the OpenWrt system, the files used, such as [kernel](https://github.com/ophub/kernel) and [u-boot](https://github.com/ophub/u-boot), are the same files used to create the [Armbian](https://github.com/ophub/amlogic-s9xxx-armbian) system. In order to avoid repeated maintenance, related content has been classified and placed in the corresponding resource repositories, and will be automatically downloaded from the relevant repositories during use.

The [u-boot](https://github.com/ophub/u-boot), [kernel](https://github.com/ophub/kernel) and other resources used by this system mainly come from the [unifreq/openwrt_packit](https://github.com/unifreq/openwrt_packit) project. Some files are shared by users in the [Pull](https://github.com/ophub/amlogic-s9xxx-openwrt/pulls) and [Issues](https://github.com/ophub/amlogic-s9xxx-openwrt/issues) of the [amlogic-s9xxx-openwrt](https://github.com/ophub/amlogic-s9xxx-openwrt) / [amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian) / [luci-app-amlogic](https://github.com/ophub/luci-app-amlogic) / [kernel](https://github.com/ophub/kernel) / [u-boot](https://github.com/ophub/u-boot) and other projects. `unifreq` has opened the door for us to use OpenWrt in TV boxes. Deeply influenced by him, my firmware production and usage follow his consistent standards. To thank these pioneers and sharers, I have recorded them in [CONTRIBUTORS.md](https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/CONTRIBUTORS.md). Once again, I want to thank everyone for giving new life and meaning to the boxes.

## Other Distributions

- [unifreq](https://github.com/unifreq/openwrt_packit) has made `OpenWrt` systems for more boxes such as Amlogic, Rockchip, and Allwinner. It is a benchmark in the box circle, recommended for use.
- The [amlogic-s9xxx-armbian](https://github.com/ophub/amlogic-s9xxx-armbian) project provides the `Armbian` system used in the box, which is also applicable in devices that support OpenWrt.

## Links

- [unifreq](https://github.com/unifreq/openwrt_packit)
- [OpenWrt](https://github.com/openwrt/openwrt)
- [coolsnowwolf](https://github.com/coolsnowwolf/lede)
- [immortalwrt](https://github.com/immortalwrt/immortalwrt)

## License

The amlogic-s9xxx-openwrt © OPHUB is licensed under the [GPL-2.0](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/LICENSE) license

