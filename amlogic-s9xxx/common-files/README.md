# Common file description

- files: The files in the `files` directory are custom files, which must be completely consistent with the structure and file naming and storage under the ***`root`*** directory in openwrt. If there are files in this directory, they will be automatically copied to the openwrt directory during `sudo ./make`. E.g:

```yaml
etc/config/network
lib/u-boot
```

- patches: The files in the `patches` directory are patch files, which are integrated when build kernel files.

