#======================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Packaged OpenWrt for S905x3-Boxs and Phicomm-N1
# Function: Install and Upgrading openwrt to the emmc for S905x3-Boxs and Phicomm-N1
# Copyright (C) 2020 Flippy's kernrl files for amlogic-s9xxx
# Copyright (C) 2020 https://github.com/tuanqing/mknop
# Copyright (C) 2020 https://github.com/ophub/amlogic-s9xxx-openwrt
#======================================================================================

include $(TOPDIR)/rules.mk

PKG_NAME:=install-program
PKG_VERSION:=2.2
PKG_RELEASE:=20201201

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=Install and Upgrading openwrt to the emmc for S905x3-Boxs and Phicomm-N1
	DEPENDS:=+block-mount +blkid +parted +dosfstools +e2fsprogs +lsblk +pv +resize2fs +tune2fs +losetup +uuidgen
endef

define Package/$(PKG_NAME)/description
	Install and Upgrading openwrt to the emmc for S905x3-Boxs and Phicomm-N1
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_DIR) $(1)/root/
	$(INSTALL_BIN) ./files/n1-install.sh $(1)/usr/bin/n1-install.sh
	$(INSTALL_BIN) ./files/n1-update.sh $(1)/usr/bin/n1-update.sh
	$(INSTALL_BIN) ./files/s905x3-install.sh $(1)/usr/bin/s905x3-install.sh
	$(INSTALL_BIN) ./files/s905x3-update.sh $(1)/usr/bin/s905x3-update.sh
	$(INSTALL_BIN) ./files/u-boot-2015-phicomm-n1.bin $(1)/root/u-boot-2015-phicomm-n1.bin
	$(INSTALL_BIN) ./files/hk1box-bootloader.img $(1)/root/hk1box-bootloader.img
	$(INSTALL_CONF) ./files/fstab $(1)/etc/config/fstab
	$(INSTALL_CONF) ./files/fstab $(1)/etc/config/fstab.bak
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

