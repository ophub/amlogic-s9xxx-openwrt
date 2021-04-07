#======================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Packaged OpenWrt for Amlogic S9xxx STB
# Function: Install and Update openwrt to emmc for Amlogic S9xxx STB
# Copyright (C) 2020 Flippy
# Copyright (C) 2020 https://github.com/tuanqing/mknop
# Copyright (C) 2020 https://github.com/ophub/amlogic-s9xxx-openwrt
#======================================================================================

include $(TOPDIR)/rules.mk

PKG_NAME:=install-program
PKG_VERSION:=3.6
PKG_RELEASE:=20210407

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=Install and Update openwrt to emmc for Amlogic S9xxx STB
	DEPENDS:=+block-mount +blkid +parted +dosfstools +e2fsprogs +lsblk +pv +resize2fs +tune2fs +losetup +uuidgen
endef

define Package/$(PKG_NAME)/description
	Install and Update openwrt to emmc for Amlogic S9xxx STB
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) ./files/openwrt-install $(1)/usr/bin/openwrt-install
	$(INSTALL_BIN) ./files/openwrt-update $(1)/usr/bin/openwrt-update
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

