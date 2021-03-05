#======================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Packaged OpenWrt for S9xxx-Boxs
# Function: Install and Upgrading openwrt to the emmc for S9xxx-Boxs
# Copyright (C) 2020 Flippy
# Copyright (C) 2020 https://github.com/tuanqing/mknop
# Copyright (C) 2020 https://github.com/ophub/amlogic-s9xxx-openwrt
#======================================================================================

include $(TOPDIR)/rules.mk

PKG_NAME:=install-program
PKG_VERSION:=3.2
PKG_RELEASE:=20210305

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=Install and Upgrading openwrt to the emmc for S9xxx-Boxs
	DEPENDS:=+block-mount +blkid +parted +dosfstools +e2fsprogs +lsblk +pv +resize2fs +tune2fs +losetup +uuidgen
endef

define Package/$(PKG_NAME)/description
	Install and Upgrading openwrt to the emmc for S9xxx-Boxs
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_BIN) ./files/s9xxx-install.sh $(1)/usr/bin/s9xxx-install.sh
	$(INSTALL_BIN) ./files/s9xxx-update.sh $(1)/usr/bin/s9xxx-update.sh
	$(INSTALL_CONF) ./files/fstab.etc $(1)/etc/fstab
	$(INSTALL_CONF) ./files/fstab.config $(1)/etc/config/fstab
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

