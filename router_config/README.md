# OpenWrt for S905x3-Boxs and Phicomm-N1

You can modify the configuration file, customize the OpenWrt firmware.

## Related script usage instructions

There are currently two DIY scripts in the root directory of the warehouse: `diy-part1.sh`, `diy-part2.sh` and `.config`, which are executed before and after the update and installation of ` ./scripts/feeds update && ./scripts/feeds install `. You can write the instructions for modifying the source code into the script, such as modifying `the default IP , Host name, theme, add/remove software package...`, etc. If the additional software package has the same name as the existing software package in the OpenWrt source code, the software package with the same name in the OpenWrt source code needs to be deleted, otherwise the packages in OpenWrt will be compiled first. It will automatically traverse all files in the `package` directory when compiling.


Just put the `feeds.conf.default` file into the root directory of the warehouse, it will overwrite the relevant files in the OpenWrt source directory. Create a new `files` directory under the root directory of the warehouse, and put the customized related files in the same directory structure as OpenWrt, and the OpenWrt configuration will be overwritten during compilation.


On the [Action](https://github.com/ophub/amlogic-s9xxx-openwrt/actions) page. Select ***`Build OpenWrt`*** in the list on the left, and Click the ***`Run workflow`*** button on the right. Set ***`SSH connection to Actions: true`*** to use tmate to connect to the `GitHub Actions` virtual server environment. You can directly perform the `make menuconfig` operation to generate the compilation configuration, or any customized operation. After triggering the workflow, wait for the `SSH connection to Actions` step to be executed on the `Actions` page, and then the following three lines of messages will be displayed: 1.` To connect to this session copy-n-paste the following into a terminal or browser`, 2.***` ssh Y26QenMRd@nyc1.tmate.io `***, 3.***` https://tmate.io/t/Y26QenMRd `***. Then copy the `SSH connection command` and paste it into `the terminal` for execution, or copy `the link` to open it in `the browser` and use `the web terminal`. enter the command: ***` cd openwrt && make menuconfig `*** for personalized configuration (The web terminal may encounter a black screen, just press ***`Ctrl+C`***). After completion, press the shortcut key ***` Ctrl+D `*** or execute the ***` exit `*** command to exit, and the subsequent compilation work will proceed automatically.


## Configuration file function description

| Folder/file name | Features |
| ---- | ---- |
| .config | Firmware related configuration, such as firmware kernel, file type, software package, luci-app, luci-theme, etc. |
| files | Create a files directory under the root directory of the warehouse and put the relevant files in. You can use custom files such as network/dhcp/wireless by default when compiling. |
| feeds.conf.default | Just put the feeds.conf.default file into the root directory of the warehouse, it will overwrite the relevant files in the OpenWrt source directory. |
| diy-part1.sh | Execute before updating and installing feeds, you can write instructions for modifying the source code into the script, such as adding/modifying/deleting feeds.conf.default. |
| diy-part2.sh | After updating and installing feeds, you can write the instructions for modifying the source code into the script, such as modifying the default IP, host name, theme, adding/removing software packages, etc. |


## .github/workflow/*.yml related environment variable description

| Environment variable | Features |
| ---- | ---- |
| REPO_URL | Source code warehouse address |
| REPO_BRANCH | Source branch |
| FEEDS_CONF | Custom feeds.conf.default file name |
| CONFIG_FILE | Custom .config file name |
| DIY_P1_SH | Custom diy-part1.sh file name |
| DIY_P2_SH | Custom diy-part2.sh file name |
| UPLOAD_BIN_DIR | Upload the bin directory (all ipk files and firmware). Default false |
| UPLOAD_FIRMWARE | Upload firmware catalog. Default true |
| UPLOAD_RELEASE | Upload firmware to release. Default true |
| UPLOAD_COWTRANSFER | Upload the firmware to CowTransfer.com. Default false |
| UPLOAD_WERANSFER | Upload the firmware to WeTransfer.com. Default failure |
| RECENT_LASTEST | maximum retention days for release, artifacts and logs in GitHub Release and Actions. |
| TZ | Time zone setting |
| GITHUB_REPOSITORY | Github.com Environment variables. The owner and repository name. For example, ophub/op. |
| secrets.GITHUB_TOKEN | Personal center: Settings → Developer settings → Personal access tokens → Generate new token ( Name: GITHUB_TOKEN, Select: public_repo ). |

## Firmware compilation parameters

| Option | Value |
| ---- | ---- |
| Target System | QEMU ARM Virtual Machine |
| Subtarget | QEMU ARMv8 Virtual Machine(cortex-a53) |
| Target Profile | Default |
| Target Images | squashfs |
| LuCI -> Applications | in the file: .config |

## Firmware information

| Name | Value |
| ---- | ---- |
| Default IP | 192.168.1.1 |
| Default username | root |
| Default password | password |
| Default WIFI name | OpenWrt |
| Default WIFI password | none |
